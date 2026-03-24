import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urine_bag/commons/addButton.dart';

class PackagerDetailView extends StatefulWidget {
  const PackagerDetailView({super.key, required this.packagerName});
  final String packagerName;

  @override
  State<PackagerDetailView> createState() => _PackagerDetailViewState();
}

class _PackagerDetailViewState extends State<PackagerDetailView> {
  bool _isInitLoading = true;
  List<String> inventoryDocIds = [];
  

  @override
  void initState() {
    super.initState();
    _fetchInventoryDocs();
  }

  Future<void> _fetchInventoryDocs() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Inventory').get();
      if (mounted) {
        setState(() {
          inventoryDocIds = snapshot.docs.map((doc) => doc.id).toList();
          _isInitLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching inventory documents: $e");
      if (mounted) setState(() => _isInitLoading = false);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery History'),
      ),
      body: _isInitLoading 
        ? const Center(child: CircularProgressIndicator())
        : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Packaging")
                .doc(widget.packagerName)
                .collection("Deliver")
                .orderBy('Actual Date', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text("Error loading delivery records"));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No delivery history found"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final ds = snapshot.data!.docs[index];
                  return _deliveryCard(ds, theme);
                },
              );
            },
          ),
    );
  }

  Widget _deliveryCard(DocumentSnapshot ds, ThemeData theme) {
    Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
    final date = data["Date"] ?? "No Date";
    final expectedCartons = data["Delivered Expected Carton"] ?? 0;

    // Filter items to show only actual inventory counts
    final items = Map<String, dynamic>.from(data)
      ..remove("Actual Date")
      ..remove("Date")
      ..remove("Inventory Ledger")
      ..remove("Delivered Expected Carton")
      ..remove("createdAt");

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Delivery Date", style: theme.textTheme.labelMedium?.copyWith(color: Colors.grey)),
                    const SizedBox(height: 2),
                    Text(date, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(
                  onPressed: () => _deliveredEdit(context, ds.id),
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const Divider(height: 24),
            
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: items.entries.map((e) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${e.key}: ",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        "${e.value}",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.inventory_2_outlined, size: 16, color: theme.colorScheme.secondary),
                  const SizedBox(width: 8),
                  const Text("Expected Cartons:", style: TextStyle(fontSize: 13)),
                  const Spacer(),
                  Text("$expectedCartons", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deliveredEdit(BuildContext context, String id) async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("Packaging")
        .doc(widget.packagerName)
        .collection("Deliver")
        .doc(id)
        .get();

    if (!ds.exists) return;
    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditDeliverModal(
        doc: ds,
        packagerName: widget.packagerName,
        inventoryDocIds: inventoryDocIds,
      ),
    );
  }
}

class _EditDeliverModal extends StatefulWidget {
  final DocumentSnapshot doc;
  final String packagerName;
  final List<String> inventoryDocIds;

  const _EditDeliverModal({
    required this.doc,
    required this.packagerName,
    required this.inventoryDocIds,
  });

  @override
  State<_EditDeliverModal> createState() => _EditDeliverModalState();
}

class _EditDeliverModalState extends State<_EditDeliverModal> {
  final Map<String, TextEditingController> controllers = {};
  late TextEditingController dateController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final data = widget.doc.data() as Map<String, dynamic>? ?? {};
    dateController = TextEditingController(text: data["Date"] ?? "");
    for (var docId in widget.inventoryDocIds) {
      controllers[docId] = TextEditingController(
        text: (data[docId] ?? 0).toString(),
      );
    }
  }

  @override
  void dispose() {
    dateController.dispose();
    for (var c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        top: 24,
        left: 24,
        right: 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Edit Delivery Info",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: "Date",
                prefixIcon: Icon(Icons.calendar_today_outlined),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Quantities Delivered",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            ...widget.inventoryDocIds.map((e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextField(
                  controller: controllers[e],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: e,
                    prefixIcon: const Icon(Icons.tag_rounded),
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            AddButton(
              isLoading: _isLoading,
              text: "Update Record",
              fn: () async {
                setState(() => _isLoading = true);
                try {
                  Map<String, dynamic> updatedFields = {};
                  Map<String, dynamic> incrementFields = {};

                  final data = widget.doc.data() as Map<String, dynamic>? ?? {};
                  for (var docId in widget.inventoryDocIds) {
                    int newValue = int.tryParse(controllers[docId]?.text ?? "0") ?? 0;
                    int oldValue = data[docId] ?? 0;
                    updatedFields[docId] = newValue;
                    incrementFields[docId] = FieldValue.increment(newValue - oldValue);
                  }
                  updatedFields["Date"] = dateController.text;

                  await FirebaseFirestore.instance
                      .collection("Packaging")
                      .doc(widget.packagerName)
                      .collection("Deliver")
                      .doc(widget.doc.id)
                      .update(updatedFields);

                  await FirebaseFirestore.instance
                      .collection("Packaging")
                      .doc(widget.packagerName)
                      .update(incrementFields);

                  final currentData = widget.doc.data() as Map<String, dynamic>? ?? {};
                  for (var e in widget.inventoryDocIds) {
                    int newValue = int.tryParse(controllers[e]?.text ?? "0") ?? 0;
                    int oldValue = currentData[e] ?? 0;
                    int difference = newValue - oldValue;

                    if (difference != 0) {
                      await FirebaseFirestore.instance
                          .collection("Inventory")
                          .doc(e)
                          .update({
                        "quantity": FieldValue.increment(-difference),
                      });
                      if (widget.doc["Inventory Ledger"] != null) {
                        await FirebaseFirestore.instance
                            .collection("Inventory")
                            .doc(e)
                            .collection("Ledger")
                            .doc(widget.doc["Inventory Ledger"])
                            .update({
                              "Quantity": -newValue, // ✅ negative for delivery
                              "Timestamp": FieldValue.serverTimestamp(),
                            });
                      }
                    }
                  }

                  if (mounted) Navigator.pop(context);
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: $e")),
                    );
                  }
                } finally {
                  if (mounted) setState(() => _isLoading = false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
