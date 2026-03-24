import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urine_bag/commons/addButton.dart';
import 'package:urine_bag/pages/supplier/supplierPersonDetail.dart';

class SupplierDetail extends StatefulWidget {
  const SupplierDetail({super.key, required this.supplyItem});
  final String supplyItem;

  @override
  State<SupplierDetail> createState() => _SupplierDetailState();
}

class _SupplierDetailState extends State<SupplierDetail> {
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _supplierController.dispose();
    _locationController.dispose();
    _phoneNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.supplyItem} Suppliers'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSheet,
        label: const Text("Add Supplier"),
        icon: const Icon(Icons.person_add_alt_outlined),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("SuplierDetail")
            .where("item", isEqualTo: widget.supplyItem)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading suppliers"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text("No suppliers for ${widget.supplyItem}", style: const TextStyle(color: Colors.grey)),
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
              return _supplierCard(ds, theme);
            },
          );
        },
      ),
    );
  }

  Widget _supplierCard(DocumentSnapshot ds, ThemeData theme) {
    final name = ds.id;
    final location = ds["location"] ?? "Unknown Location";
    final phone = ds["phone"] ?? "No Phone";

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          child: Icon(Icons.person_outline, color: theme.colorScheme.primary),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(location, style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.phone_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(phone, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SupplierPersonDetail(
                personName: name,
                supplyItem: widget.supplyItem,
              ),
            ),
          );
        },
        onLongPress: () => _showDeleteDialog(name),
      ),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 24),
              const Text("Register Supplier", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextField(
                controller: _supplierController,
                decoration: const InputDecoration(labelText: "Supplier Name", prefixIcon: Icon(Icons.person_outline)),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "Location", prefixIcon: Icon(Icons.location_on_outlined)),
                keyboardType: TextInputType.streetAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneNoController,
                decoration: const InputDecoration(labelText: "Phone Number", prefixIcon: Icon(Icons.phone_outlined)),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),
              AddButton(
                isLoading: _isLoading,
                text: "Add Supplier",
                fn: () => _addSupply(_supplierController.text, _locationController.text, _phoneNoController.text, context),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addSupply(String name, String loc, String ph, BuildContext context) async {
    String supplierName = name.trim();
    String location = loc.trim();
    String phone = ph.trim();

    if (supplierName.isEmpty || location.isEmpty || phone.isEmpty) {
      _showSnack("Please fill all fields.");
      return;
    }

    if (!RegExp(r'^[0-9]{7,15}$').hasMatch(phone)) {
      _showSnack("Enter a valid phone number.");
      return;
    }

    setState(() => _isLoading = true);
    try {
      DocumentReference ref = FirebaseFirestore.instance.collection("SuplierDetail").doc(supplierName);
      DocumentSnapshot existing = await ref.get();

      if (existing.exists) {
        _showSnack("Supplier already exists.");
        if (mounted) Navigator.pop(context);
        return;
      }

      await ref.set({
        "location": location,
        "phone": phone,
        "item": widget.supplyItem,
        "created_at": FieldValue.serverTimestamp(),
      });

      _supplierController.clear();
      _locationController.clear();
      _phoneNoController.clear();
      if (mounted) Navigator.pop(context);
      _showSnack("Supplier registered successfully!");
    } catch (e) {
      _showSnack("Error adding supplier: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showDeleteDialog(String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Remove Supplier?"),
        content: Text("Delete '$name' from ${widget.supplyItem} list? This will also remove their transaction records from inventory ledger."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteSupplier(name);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteSupplier(String name) async {
    int quantityToDelete = 0;
    try {
      // 1) Delete SuplierDetail doc
      await FirebaseFirestore.instance.collection("SuplierDetail").doc(name).delete();

      // 2) Remove related ledger entries and calculate quantity for correction
      QuerySnapshot ledgerDocs = await FirebaseFirestore.instance
          .collection("Inventory")
          .doc(widget.supplyItem)
          .collection("Ledger")
          .get();

      for (var doc in ledgerDocs.docs) {
        if (doc["Description"] == name) {
          final qText = doc["Quantity"].toString().replaceAll("+", "");
          quantityToDelete += int.tryParse(qText) ?? 0;
          await doc.reference.delete();
        }
      }

      // 3) Update Inventory totals
      await FirebaseFirestore.instance.collection("Inventory").doc(widget.supplyItem).update({
        "quantity": FieldValue.increment(-quantityToDelete),
        "total quantity": FieldValue.increment(-quantityToDelete),
      });

      _showSnack("Supplier removed successfully");
    } catch (e) {
      _showSnack("Error deleting supplier: $e");
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
