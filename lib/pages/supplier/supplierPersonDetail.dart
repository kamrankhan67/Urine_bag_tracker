import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urine_bag/commons/addButton.dart';

class SupplierPersonDetail extends StatefulWidget {
  const SupplierPersonDetail({
    super.key,
    required this.personName,
    required this.supplyItem,
  });
  final String personName;
  final String supplyItem;

  @override
  State<SupplierPersonDetail> createState() => _SupplierPersonDetailState();
}

class _SupplierPersonDetailState extends State<SupplierPersonDetail> {
  final TextEditingController _balController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _balController.dispose();
    _itemController.dispose();
    _dateController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.personName),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSheet,
        label: const Text("New Bill"),
        icon: const Icon(Icons.add_shopping_cart_outlined),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 👤 Header Info Section
            _buildProfileSection(theme),
            
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text("Purchase History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("SuplierDetail")
                  .doc(widget.personName)
                  .collection("Bills")
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading bills"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.history_outlined, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text("No purchase records found", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final ds = snapshot.data!.docs[index];
                    return _billCard(ds, theme);
                  },
                );
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(ThemeData theme) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection("SuplierDetail").doc(widget.personName).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) return const SizedBox();
        final data = snapshot.data!;
        
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.colorScheme.primary.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                   Container(
                     padding: const EdgeInsets.all(12),
                     decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.1), shape: BoxShape.circle),
                     child: Icon(Icons.business_rounded, color: theme.colorScheme.primary),
                   ),
                   const SizedBox(width: 16),
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(widget.supplyItem, style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                         Text(widget.personName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                       ],
                     ),
                   ),
                ],
              ),
              const Divider(height: 32),
              Row(
                children: [
                  _infoBit(Icons.location_on_outlined, "Location", data['location'] ?? "N/A"),
                  const Spacer(),
                  _infoBit(Icons.phone_outlined, "Phone", data['phone'] ?? "N/A"),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoBit(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Widget _billCard(DocumentSnapshot ds, ThemeData theme) {
    final data = ds.data() as Map<String, dynamic>;
    final date = data['date'] ?? "";
    final quantity = data['quantity'] ?? 0;
    final itemName = data['item'] ?? "";
    final balance = data['balance'] ?? 0;
    final perPiece = quantity != 0 ? (balance / quantity) : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(date, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
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
            _billRow("Item", itemName, isBold: true),
            const SizedBox(height: 8),
            _billRow("Quantity", "$quantity"),
            const SizedBox(height: 8),
            _billRow("Per Unit Cost", perPiece.toStringAsFixed(2)),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Balance", style: TextStyle(fontWeight: FontWeight.w500)),
                Text("PKR $balance", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _billRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.w500, fontSize: 14)),
      ],
    );
  }

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 24),
                const Text("New Supply Record", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                      setState(() => _dateController.text = "${picked.day}/${picked.month}/${picked.year}");
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _itemController,
                  decoration: const InputDecoration(labelText: "Item Name", prefixIcon: Icon(Icons.shopping_bag_outlined)),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: "Quantity", prefixIcon: Icon(Icons.tag_rounded)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _balController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: "Balance", prefixIcon: Icon(Icons.payments_outlined)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                AddButton(
                  isLoading: _isLoading,
                  text: "Save Invoice",
                  fn: () {
                    final qty = int.tryParse(_quantityController.text) ?? 0;
                    final bal = int.tryParse(_balController.text) ?? 0;
                    if (_dateController.text.isEmpty ||
                        _itemController.text.isEmpty ||
                        qty == 0) {
                      _showSnack("Please fill all fields.");
                      return;
                    }
                    _addSupplyDetail(widget.personName, _dateController.text, qty,
                        _itemController.text, bal, context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addSupplyDetail(String person, String date, int quantity, String item, int bal, BuildContext context) async {
    String randomDocId = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance.collection("SuplierDetail").doc(widget.personName).collection("Bills").doc().set({
        "date": date,
        "quantity": quantity,
        "item": item,
        "balance": bal,
        "ledgerDocId": randomDocId,
        "createdAt": FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance.collection("Inventory").doc(widget.supplyItem).collection("Ledger").doc(randomDocId).set({
        "Date": date,
        "Quantity": quantity, // ✅ store as int
        "Color": "Green",
        "Description": person,
        "Timestamp": FieldValue.serverTimestamp(), // ✅ rename to Timestamp
      });

      await FirebaseFirestore.instance.collection("Inventory").doc(widget.supplyItem).update({
        "quantity": FieldValue.increment(quantity),
        "total quantity": FieldValue.increment(quantity),
        "total value": FieldValue.increment(bal),
      });

      if (mounted) Navigator.pop(context);
      _showSnack("Invoice saved!");
    } catch (e) {
      _showSnack("Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showDeleteDialog(String billId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Record?"),
        content: const Text("This purchase will be removed and inventory totals will be adjusted back."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteBill(billId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteBill(String billId) async {
    try {
      DocumentSnapshot ds = await FirebaseFirestore.instance
          .collection("SuplierDetail")
          .doc(widget.personName)
          .collection("Bills")
          .doc(billId)
          .get();

      if (!ds.exists) return;

      var ledgerDocId = ds["ledgerDocId"];
      int qty = ds["quantity"] ?? 0;
      int bal = ds["balance"] ?? 0;

      await FirebaseFirestore.instance.collection("SuplierDetail").doc(widget.personName).collection("Bills").doc(billId).delete();

      if (ledgerDocId != null) {
        await FirebaseFirestore.instance.collection("Inventory").doc(widget.supplyItem).collection("Ledger").doc(ledgerDocId).delete();
      }

      await FirebaseFirestore.instance.collection("Inventory").doc(widget.supplyItem).update({
        "quantity": FieldValue.increment(-qty),
        "total quantity": FieldValue.increment(-qty),
        "total value": FieldValue.increment(-bal),
      });

      _showSnack("Record deleted successfully");
    } catch (e) {
      _showSnack("Error deleting record: $e");
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
