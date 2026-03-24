import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urine_bag/pages/packager/PackagerDetail.dart';

class Packager extends StatefulWidget {
  const Packager({super.key});

  @override
  State<Packager> createState() => _PackagerState();
}

class _PackagerState extends State<Packager> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Packaging Partners')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSheet,
        label: const Text("Add Partner"),
        icon: const Icon(Icons.person_add_alt_1_outlined),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Packaging")
            .orderBy(FieldPath.documentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading records"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "No packaging partners found",
                    style: TextStyle(color: Colors.grey),
                  ),
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
              childAspectRatio: 1.1,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final ds = snapshot.data!.docs[index];
              return _packagerCard(ds, context, theme);
            },
          );
        },
      ),
    );
  }

  Widget _packagerCard(
    DocumentSnapshot ds,
    BuildContext context,
    ThemeData theme,
  ) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.05)),
      ),
      child: InkWell(
        onLongPress: () => _showDeleteDialog(ds.id),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PackagerDetail(packagerData: ds)),
          );
        },
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
                  Icons.person_outline_rounded,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                ds.id,
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
                "Add Partner",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Partner Name",
                  prefixIcon: Icon(Icons.person_outline),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _addPackager(_nameController.text),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Register Partner",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(String item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete $item?"),
        content: const Text(
          "This will permanently remove this category and all its records. This action cannot be undone.",
        ),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCategory(String item) async {
    try {
      QuerySnapshot personDeliverData = await FirebaseFirestore.instance
          .collection("Packaging")
          .doc(item)
          .collection("Deliver")
          .get();

      for (var deliverDoc in personDeliverData.docs) {
        await deliverDoc.reference.delete();
      }
      QuerySnapshot personReceivedData = await FirebaseFirestore.instance
          .collection("Packaging")
          .doc(item)
          .collection("Received")
          .get();

      for (var receivedDoc in personReceivedData.docs) {
        await receivedDoc.reference.delete();
      }


      // 2) Delete Supplier Category doc
      await FirebaseFirestore.instance
          .collection("Packaging")
          .doc(item)
          .delete();

      _showSnack("Category deleted successfully");
    } catch (e) {
      _showSnack("Error deleting category: $e");
    }
  }

  Future<void> _addPackager(String name) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      _showSnack("Name cannot be empty");
      return;
    }

    setState(() => _isLoading = true);
    try {
      final docRef = FirebaseFirestore.instance
          .collection("Packaging")
          .doc(trimmedName);
      final doc = await docRef.get();

      if (doc.exists) {
        _showSnack("Packager already exists");
        setState(() => _isLoading = false);
        return;
      }

      await docRef.set({
        "Received Carton": 0,
        "Boxes": 0,
        "Pieces": 0,
        "Expected Carton": 0,
        "createdAt": FieldValue.serverTimestamp(),
      });

      _nameController.clear();
      if (mounted) Navigator.pop(context);
      _showSnack("Partner added successfully");
    } catch (e) {
      _showSnack("Something went wrong");
    }
    if (mounted) setState(() => _isLoading = false);
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
