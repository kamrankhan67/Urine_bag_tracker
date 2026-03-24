import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urine_bag/commons/addButton.dart';
import 'package:urine_bag/pages/extras/labourPerson.dart';

class Labour extends StatefulWidget {
  const Labour({super.key});

  @override
  State<Labour> createState() => _LabourState();
}

class _LabourState extends State<Labour> {
  final TextEditingController _addCategoryController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _addCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Labour Categories'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSheet,
        label: const Text("New Category"),
        icon: const Icon(Icons.add_task_rounded),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Extras").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading categories"));
          }
          
          final docs = snapshot.data?.docs.where((doc) => 
            doc.id != "Waste" && doc.id != "Ready Bags"
          ).toList() ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.engineering_outlined, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text("No labour categories found", style: TextStyle(color: Colors.grey)),
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
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final ds = docs[index];
              return _categoryCard(ds, context, theme);
            },
          );
        },
      ),
    );
  }

  Widget _categoryCard(DocumentSnapshot ds, BuildContext context, ThemeData theme) {
    final name = ds.id;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.05)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LabourPerson(category: ds),
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
                  Icons.handyman_outlined,
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
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 24),
              const Text("New Category", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Create a new type of labour work.", style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 24),
              TextField(
                controller: _addCategoryController,
                decoration: const InputDecoration(
                  labelText: "Category Name",
                  prefixIcon: Icon(Icons.engineering_outlined),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 32),
              AddButton(
                isLoading: _isLoading,
                text: "Create Category",
                fn: () => _addLabourCategory(_addCategoryController.text, context),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addLabourCategory(String text, BuildContext context) async {
    String categoryName = text.trim();
    if (categoryName.isEmpty) {
      _showSnack("Category name cannot be empty.");
      return;
    }

    setState(() => _isLoading = true);
    try {
      DocumentReference ref = FirebaseFirestore.instance.collection("Extras").doc(categoryName);
      DocumentSnapshot existing = await ref.get();

      if (existing.exists) {
        _showSnack("Category already exists.");
        if (mounted) Navigator.pop(context);
        return;
      }

      await ref.set({
        "name": categoryName,
        "Total Amount": 0,
        "Total Pieces": 0,
        "created_at": FieldValue.serverTimestamp(),
      });

      _addCategoryController.clear();
      if (mounted) Navigator.pop(context);
      _showSnack("Category added successfully!");
    } catch (e) {
      _showSnack("Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showDeleteDialog(String categoryId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete $categoryId?"),
        content: const Text("This will permanently remove this category. Existing labour records associated with this category will remain but may be inaccessible."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteLabourCategory(categoryId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteLabourCategory(String categoryId) async {
    try {
      await FirebaseFirestore.instance.collection("Extras").doc(categoryId).delete();
      _showSnack("Category deleted successfully");
    } catch (e) {
      _showSnack("Error: $e");
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
