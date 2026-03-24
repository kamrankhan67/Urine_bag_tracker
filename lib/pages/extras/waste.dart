import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urine_bag/commons/addButton.dart';

class Waste extends StatefulWidget {
  const Waste({super.key});

  @override
  State<Waste> createState() => _WasteState();
}

class _WasteState extends State<Waste> {
  final Map<String, TextEditingController> _controllers = {};
  List<String> _inventoryDocIds = [];
  final TextEditingController _dateController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchInventoryDocs();
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _fetchInventoryDocs() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Inventory').get();
      setState(() {
        _inventoryDocIds = snapshot.docs.map((doc) => doc.id).toList();
        for (var docId in _inventoryDocIds) {
          if (!_controllers.containsKey(docId)) {
            _controllers[docId] = TextEditingController();
          }
        }
      });
    } catch (e) {
      _showSnack("Error fetching inventory: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Waste Management"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSheet,
        label: const Text("Record Waste"),
        icon: const Icon(Icons.add_circle_outline),
        backgroundColor: theme.colorScheme.error,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Extras")
            .doc("Waste")
            .collection("Detail")
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading waste records"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete_sweep_outlined, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text("No waste records found", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final ds = snapshot.data!.docs[index];
              return _wasteRecordCard(ds, theme);
            },
          );
        },
      ),
    );
  }

  Widget _wasteRecordCard(DocumentSnapshot ds, ThemeData theme) {
    var data = ds.data() as Map<String, dynamic>;
    final date = data["Date"] ?? "N/A";
    
    // Extract items with non-zero waste
    final wasteItems = data.entries.where((e) => 
      e.key != "Date" && 
      e.key != "LedgerDocId" && 
      e.key != "createdAt" && 
      (e.value is num && e.value > 0)
    ).toList();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(date, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  ],
                ),
                IconButton(
                  onPressed: () => _showDeleteDialog(ds.id),
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const Divider(height: 24),
            const Text("Wasted Items", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: wasteItems.map((item) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.colorScheme.error.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(item.key, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 8),
                    Text("-${item.value}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.colorScheme.error)),
                  ],
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                top: 24,
                left: 24,
                right: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 24),
                  const Text("Report Waste", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text("Enter quantity for items that were wasted.", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: "Date", prefixIcon: Icon(Icons.calendar_today_outlined)),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setModalState(() => _dateController.text = "${picked.day}/${picked.month}/${picked.year}");
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _inventoryDocIds.length,
                      itemBuilder: (context, index) {
                        final id = _inventoryDocIds[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: TextField(
                            controller: _controllers[id],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: id,
                              prefixIcon: const Icon(Icons.inventory_2_outlined),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  AddButton(
                    isLoading: _isLoading,
                    text: "Submit Waste Report",
                    fn: () => _sendData(context, setModalState),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Future<void> _sendData(BuildContext context, StateSetter setModalState) async {
    if (_dateController.text.isEmpty) {
      _showSnack("Please select a date.");
      return;
    }

    setModalState(() => _isLoading = true);
    try {
      String randomDocId = DateTime.now().millisecondsSinceEpoch.toString();
      Map<String, int> dataToSend = {};

      // Validate stock for all items
      for (var docId in _inventoryDocIds) {
        int val = int.tryParse(_controllers[docId]!.text.trim()) ?? 0;
        if (val > 0) {
          DocumentSnapshot invDoc = await FirebaseFirestore.instance.collection('Inventory').doc(docId).get();
          if (invDoc.exists) {
            int stock = invDoc['quantity'] ?? 0;
            if (val > stock) {
              _showSnack("Insufficient stock for $docId (Available: $stock)");
              setModalState(() => _isLoading = false);
              return;
            }
            dataToSend[docId] = val;
          }
        }
      }

      if (dataToSend.isEmpty) {
        _showSnack("No waste quantities entered.");
        setModalState(() => _isLoading = false);
        return;
      }

      // Save waste record
      await FirebaseFirestore.instance
          .collection('Extras')
          .doc("Waste")
          .collection("Detail")
          .add({
            "LedgerDocId": randomDocId,
            "Date": _dateController.text,
            ...dataToSend,
            "createdAt": FieldValue.serverTimestamp(),
          });

      // Update inventory and ledgers
      for (var entry in dataToSend.entries) {
        await FirebaseFirestore.instance.collection("Inventory").doc(entry.key).update({
          "quantity": FieldValue.increment(-entry.value),
        });
        await FirebaseFirestore.instance.collection("Inventory").doc(entry.key).collection("Ledger").doc(randomDocId).set({
          "Quantity": -entry.value,
          "Description": "Waste",
          "Color": "Red",
          "Date": _dateController.text,
          "Timestamp": FieldValue.serverTimestamp(),
        });
      }

      for (var controller in _controllers.values) {
        controller.clear();
      }
      if (mounted) Navigator.pop(context);
      _showSnack("Waste report submitted!");
    } catch (e) {
      _showSnack("Error: $e");
    } finally {
      setModalState(() => _isLoading = false);
    }
  }

  void _showDeleteDialog(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Record?"),
        content: const Text("This report will be removed and inventory levels will be restored."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteData(docId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteData(String docId) async {
    try {
      DocumentSnapshot ds = await FirebaseFirestore.instance
          .collection("Extras")
          .doc("Waste")
          .collection("Detail")
          .doc(docId)
          .get();

      if (ds.exists) {
        var data = ds.data() as Map<String, dynamic>;
        String? ledgerId = data["LedgerDocId"];
        
        // Restore inventory
        for (var entry in data.entries) {
          if (entry.key != "Date" && entry.key != "LedgerDocId" && entry.key != "createdAt" && entry.value is num) {
            await FirebaseFirestore.instance.collection("Inventory").doc(entry.key).update({
              "quantity": FieldValue.increment(entry.value),
            });
            if (ledgerId != null) {
              await FirebaseFirestore.instance.collection("Inventory").doc(entry.key).collection("Ledger").doc(ledgerId).delete();
            }
          }
        }
      }

      await FirebaseFirestore.instance.collection("Extras").doc("Waste").collection("Detail").doc(docId).delete();
      _showSnack("Record deleted successfully");
    } catch (e) {
      _showSnack("Error: $e");
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
