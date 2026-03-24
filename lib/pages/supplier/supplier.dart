import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urine_bag/commons/addButton.dart';
import 'package:urine_bag/pages/supplier/supplierDetal.dart';

class Supplier extends StatefulWidget {
  const Supplier({super.key});

  @override
  State<Supplier> createState() => _SupplierState();
}

class _SupplierState extends State<Supplier> {
  final TextEditingController _addSupplierController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _addSupplierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supply Categories'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSheet,
        label: const Text("Add Category"),
        icon: const Icon(Icons.category_outlined),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Supplier").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading categories"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text("No supply categories found", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final ds = snapshot.data!.docs[index];
              return _categoryCard(ds, context, theme);
            },
          );
        },
      ),
    );
  }

  Widget _categoryCard(DocumentSnapshot ds, BuildContext context, ThemeData theme) {
    final name = ds["name"] ?? ds.id;
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.05)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SupplierDetail(supplyItem: name),
            ),
          );
        },
        onLongPress: () => _showDeleteDialog(name),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withOpacity(0.05),
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.layers_outlined,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
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
                "New Category",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Add a new type of material or supply item.",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _addSupplierController,
                decoration: const InputDecoration(
                  labelText: "Category Name",
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 32),
              AddButton(
                isLoading: _isLoading,
                text: "Create Category",
                fn: () => _addSupply(_addSupplierController.text, context),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addSupply(String text, BuildContext context) async {
    String supplierName = text.trim();
    if (supplierName.isEmpty) {
      _showSnack("Category name cannot be empty.");
      return;
    }

    setState(() => _isLoading = true);
    try {
      DocumentReference supplierRef = FirebaseFirestore.instance.collection("Supplier").doc(supplierName);
      DocumentSnapshot existingSupplier = await supplierRef.get();

      if (existingSupplier.exists) {
        _showSnack("Category already exists.");
        if (mounted) Navigator.pop(context);
        return;
      }

      // Create Supplier Category
      await supplierRef.set({
        "name": supplierName,
        "created_at": FieldValue.serverTimestamp(),
      });

      // Create matching Inventory entry
      await FirebaseFirestore.instance.collection("Inventory").doc(supplierName).set({
        "name": supplierName,
        "quantity": 0,
        "total value": 0,
        "total quantity": 0,
        "created_at": FieldValue.serverTimestamp(),
      });

      _addSupplierController.clear();
      if (mounted) Navigator.pop(context);
      _showSnack("Category added successfully!");
    } catch (e) {
      _showSnack("Error: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showDeleteDialog(String item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete $item?"),
        content: const Text("This will permanently remove this category and all its records. This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCategory(item);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCategory(String item) async {
    try {
      // 1) Delete related SuplierDetail docs
      final querySnap = await FirebaseFirestore.instance.collection("SuplierDetail").where("item", isEqualTo: item).get();
      for (final doc in querySnap.docs) {
        await doc.reference.delete();
      }

      // 2) Delete Supplier Category doc
      await FirebaseFirestore.instance.collection("Supplier").doc(item).delete();

      // 3) Delete Inventory and its Ledger
      QuerySnapshot ledgerDocs = await FirebaseFirestore.instance.collection("Inventory").doc(item).collection("Ledger").get();
      for (var doc in ledgerDocs.docs) {
        await doc.reference.delete();
      }
      await FirebaseFirestore.instance.collection("Inventory").doc(item).delete();

      _showSnack("Category deleted successfully");
    } catch (e) {
      _showSnack("Error deleting category: $e");
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
