import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urine_bag/commons/addButton.dart';
import 'package:urine_bag/pages/auth/authentication.dart';
import 'package:urine_bag/pages/extras/extras.dart';
import 'package:urine_bag/pages/inventory/inventory.dart';
import 'package:urine_bag/pages/packager/packager.dart';
import 'package:urine_bag/pages/supplier/supplier.dart';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StreamSubscription<DocumentSnapshot>? _readyBagsSubscription;
  StreamSubscription<QuerySnapshot>? _inventorySubscription;
  StreamSubscription<QuerySnapshot>? _packagerSubscription;
  Map<String, TextEditingController> controllers = {};
  List<String> inventoryDocIds = [];
  final TextEditingController _dateController = TextEditingController();
  bool _isSending = false;
  bool _isReceiving = false;

  final TextEditingController _recievedCartonController =
      TextEditingController();
  final TextEditingController _recievedDateController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  int readyBags = 0;
  int readyPieces = 0;
  String? selectedItem;
  String? receivedSelectedItem;
  List<String> packagerDocIds = [];

  @override
  void initState() {
    super.initState();
    _fetchInventoryDocs();
    _fetchPackagerDocs();
    _fetchReadyBags();
    
  }


  Future<void> _fetchReadyBags() async {
    _readyBagsSubscription = FirebaseFirestore.instance
        .collection("Extras")
        .doc("Ready Bags")
        .snapshots()
        .listen((snapshot) {
          if (!mounted) return;

          if (snapshot.exists) {
            setState(() {
              readyBags = snapshot.get("Ready Cartons") ?? 0;
              readyPieces = snapshot.get("Ready Pieces") ?? 0;
            });
          }
        });
  }

  Future<void> _fetchInventoryDocs() async {
    _inventorySubscription = FirebaseFirestore.instance
        .collection('Inventory')
        .snapshots()
        .listen((snapshot) {
      if (!mounted) return;
      setState(() {
        inventoryDocIds = snapshot.docs.map((doc) => doc.id).toList();

        // 1) Clean up controllers for deleted items
        controllers.keys.toList().forEach((id) {
          if (!inventoryDocIds.contains(id)) {
            controllers[id]?.dispose();
            controllers.remove(id);
          }
        });

        // 2) Initialize new controllers
        for (var docId in inventoryDocIds) {
          if (!controllers.containsKey(docId)) {
            controllers[docId] = TextEditingController();
          }
        }
      });
    }, onError: (e) => print("Error streaming inventory: $e"));
  }

  Future<void> _fetchPackagerDocs() async {
    _packagerSubscription = FirebaseFirestore.instance
        .collection('Packaging')
        .snapshots()
        .listen((snapshot) {
      if (!mounted) return;
      setState(() {
        packagerDocIds = snapshot.docs.map((doc) => doc.id).toList();

        // Safety: Un-select if the selected packager was deleted
        if (selectedItem != null && !packagerDocIds.contains(selectedItem)) {
          selectedItem = null;
        }
        if (receivedSelectedItem != null &&
            !packagerDocIds.contains(receivedSelectedItem)) {
          receivedSelectedItem = null;
        }
      });
    }, onError: (e) => print("Error streaming packagers: $e"));
  }

  Future<void> _sendData(StateSetter setModalState) async {
    if (selectedItem == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a packager")));
      return;
    }

    setModalState(() => _isSending = true);
    try {
      final String randomId = DateTime.now().millisecondsSinceEpoch.toString();

      // Build dataToSend and remove zero values (optional but cleaner)
      final Map<String, int> dataToSend = {};
      controllers.forEach((docId, controller) {
        int value = int.tryParse(controller.text.trim()) ?? 0;
        if (value < 0) value = 0;
        if (value > 0) dataToSend[docId] = value;
      });

      if (dataToSend.isEmpty) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Enter at least one quantity.")),
        );
        return;
      }

      final packagingRef = FirebaseFirestore.instance
          .collection("Packaging")
          .doc(selectedItem);

      // ✅ Create Deliver doc ref now (but we will write it ONLY inside transaction)
      final deliverDocRef = packagingRef.collection("Deliver").doc();

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // 1) CHECK STOCK FOR ALL ITEMS FIRST
        for (final entry in dataToSend.entries) {
          final invRef = FirebaseFirestore.instance
              .collection("Inventory")
              .doc(entry.key);

          final invSnap = await transaction.get(invRef);

          if (!invSnap.exists) {
            Navigator.pop(context);
            throw Exception("Inventory item ${entry.key} does not exist.");
          }

          final dynamic q = invSnap.data()?["quantity"];
          final int currentQty = (q is int)
              ? q
              : int.tryParse(q?.toString() ?? "0") ?? 0;

          if (currentQty < entry.value) {
            Navigator.pop(context);
            throw Exception(
              "Not enough stock for ${entry.key}. Available: $currentQty, Requested: ${entry.value}",
            );
          }
        }

        // 2) APPLY UPDATES + LEDGER (only after all checks pass)
        for (final entry in dataToSend.entries) {
          final invRef = FirebaseFirestore.instance
              .collection("Inventory")
              .doc(entry.key);

          transaction.update(invRef, {
            "quantity": FieldValue.increment(-entry.value),
          });

          final ledgerRef = invRef.collection("Ledger").doc(randomId);
          transaction.set(ledgerRef, {
            "Date": _dateController.text.trim(),
            "Quantity": -entry.value, // ✅ store as int, not string
            "Color": "Red",
            "Description": selectedItem!,
            "Timestamp": FieldValue.serverTimestamp(),
          });
        }

        // 3) CREATE DELIVER DOC (only if stock ok)
        transaction.set(deliverDocRef, {
          "Actual Date": DateTime.now(),
          "Date": _dateController.text.trim(),
          "Delivered Expected Carton": 0,
          "Inventory Ledger": randomId,
          ...dataToSend, // writes item quantities
        });

        // 4) UPDATE PACKAGING TOTALS
        final Map<String, dynamic> incMap = {};
        dataToSend.forEach((key, value) {
          incMap[key] = FieldValue.increment(value);
        });
        transaction.update(packagingRef, incMap);
      });

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Data sent successfully!")));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      // ✅ Don't pop here unless you want to close sheet on error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setModalState(() => _isSending = false);
    }
  }

  @override
  void dispose() {
    _readyBagsSubscription?.cancel();
    _inventorySubscription?.cancel();
    _packagerSubscription?.cancel();

    controllers.forEach((key, controller) => controller.dispose());

    _dateController.dispose();
    _recievedCartonController.dispose();
    _recievedDateController.dispose();
    _statusController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: theme.colorScheme.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Authentication()),
          );
        },
        label: const Text("Notebook", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.menu_book, color: Colors.white),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Munir & Sons",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Overview",
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _homeContainer(
                          "Ready Bags",
                          '$readyBags',
                          '$readyPieces',
                          theme.colorScheme.secondary,
                          context,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Extras()),
                          ),
                          child: Container(
                            height: 140,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.auto_awesome_motion_rounded, size: 32, color: Colors.white),
                                SizedBox(height: 12),
                                Text(
                                  "Extras",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "Actions",
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _actionCard(
                          title: "Send",
                          icon: Icons.send_rounded,
                          color: Colors.deepOrangeAccent,
                          onTap: _showSendModal,
                          theme: theme,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _actionCard(
                          title: "Receive",
                          icon: Icons.call_received_rounded,
                          color: const Color(0xFF43A047),
                          onTap: _showReceiveModal,
                          theme: theme,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "Quick Access",
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  _quickAccessTile(
                    title: "Inventory",
                    icon: Icons.inventory_2_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Inventory()),
                    ),
                    theme: theme,
                  ),
                  _quickAccessTile(
                    title: "Supplier",
                    icon: Icons.local_shipping_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Supplier()),
                    ),
                    theme: theme,
                  ),
                  _quickAccessTile(
                    title: "Packaging",
                    icon: Icons.add_box_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Packager()),
                    ),
                    theme: theme,
                  ),
                  const SizedBox(height: 100), // Spacing for FAB
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickAccessTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }

  void _showSendModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _modalWrapper(
        title: "Deliver Item",
        child: StatefulBuilder(
          builder: (context, setModalState) => Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Packaging').snapshots(),
                builder: (context, snapshot) {
                  final docs = snapshot.data?.docs.map((d) => d.id).toList() ?? [];
                  if (selectedItem != null && !docs.contains(selectedItem)) {
                    selectedItem = null;
                  }
                  return docs.isEmpty
                      ? const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("No Packager found")))
                      : DropdownButtonFormField<String>(
                          value: selectedItem,
                          decoration: const InputDecoration(labelText: "Select Packager"),
                          items: docs.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (val) => setModalState(() => selectedItem = val),
                        );
                }
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Date",
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setModalState(() {
                      _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Inventory').snapshots(),
                builder: (context, snapshot) {
                  final ids = snapshot.data?.docs.map((d) => d.id).toList() ?? [];
                  return Column(
                    children: ids.map((docId) {
                      if (!controllers.containsKey(docId)) {
                        controllers[docId] = TextEditingController();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextField(
                          controller: controllers[docId],
                          decoration: InputDecoration(labelText: docId),
                          keyboardType: TextInputType.number,
                        ),
                      );
                    }).toList(),
                  );
                }
              ),
              const SizedBox(height: 24),
              AddButton(
                isLoading: _isSending,
                text: "Confirm Delivery",
                fn: () => _sendData(setModalState),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReceiveModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _modalWrapper(
        title: "Receive Item",
        child: StatefulBuilder(
          builder: (context, setModalState) => Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Packaging').snapshots(),
                builder: (context, snapshot) {
                  final docs = snapshot.data?.docs.map((d) => d.id).toList() ?? [];
                  if (receivedSelectedItem != null && !docs.contains(receivedSelectedItem)) {
                    receivedSelectedItem = null;
                  }
                  return docs.isEmpty
                      ? const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("No Packager found")))
                      : DropdownButtonFormField<String>(
                          value: receivedSelectedItem,
                          decoration: const InputDecoration(labelText: "Select Packager"),
                          items: docs.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (val) => setModalState(() => receivedSelectedItem = val),
                        );
                }
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _recievedDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Date",
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setModalState(() {
                      _recievedDateController.text = "${picked.day}/${picked.month}/${picked.year}";
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _recievedCartonController,
                decoration: const InputDecoration(labelText: "Cartons"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _statusController,
                decoration: const InputDecoration(
                  labelText: "Status",
                  hintText: "e.g. Paid / UnPaid",
                ),
              ),
              const SizedBox(height: 32),
              AddButton(
                isLoading: _isReceiving,
                text: "Record Receipt",
                fn: () => _recievedItem(
                  _recievedDateController.text,
                  receivedSelectedItem!,
                  int.tryParse(_recievedCartonController.text) ?? 0,
                  _statusController.text,
                  context,
                  setModalState,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modalWrapper({required String title, required Widget child}) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 16,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 24),
            child,
          ],
        ),
      ),
    );
  }

  Widget _homeContainer(
    String title,
    String cartons,
    String pieces,
    Color color,
    BuildContext context,
  ) {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_rounded, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "$cartons Cartons",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Text(
            "$pieces Pieces",
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _recievedItem(
    String date,
    String name,
    int carton,
    String status,
    BuildContext context,
    StateSetter setModalState,
  ) async {
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid packager name")));
      return;
    }

    if (carton <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Carton must be greater than 0")),
      );
      return;
    }

    setModalState(() => _isReceiving = true);
    try {
      DocumentReference packagingRef = FirebaseFirestore.instance
          .collection("Packaging")
          .doc(name);

      await packagingRef.collection("Received").doc().set({
        "Date": date.trim(),
        "Received_carton": carton,
        "Received_pieces": carton * 144,
        "Received_box": carton * 48,
        "Status": status.trim(),
        "createdAt": FieldValue.serverTimestamp(),
      });

      await packagingRef.update({
        "Received Carton": FieldValue.increment(carton),
        "Pieces": FieldValue.increment(carton * 144),
        "Boxes": FieldValue.increment(carton * 48),
      });

      if (!mounted) return;

      final docRef = FirebaseFirestore.instance
          .collection("Extras")
          .doc("Ready Bags");

      final doc = await docRef.get();

      if (doc.exists) {
        await docRef.update({
          "Ready Cartons": FieldValue.increment(carton),
          "Ready Pieces": FieldValue.increment(carton * 144),
        });
      } else {
        await docRef.set({
          "Ready Cartons": carton,
          "Ready Pieces": carton * 144,
        });
      }

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Received item added successfully!")),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      setModalState(() => _isReceiving = false);
    }
  }
}
