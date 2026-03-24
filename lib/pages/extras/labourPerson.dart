import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urine_bag/commons/addButton.dart';
import 'package:urine_bag/pages/extras/labourpersondetail.dart';

class LabourPerson extends StatefulWidget {
  const LabourPerson({super.key, required this.category});
  final DocumentSnapshot category;

  @override
  State<LabourPerson> createState() => _LabourPersonState();
}

class _LabourPersonState extends State<LabourPerson> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.id)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSheet,
        label: const Text("Add Person"),
        icon: const Icon(Icons.person_add_alt_outlined),
      ),
      body: Column(
        children: [
          /// 📊 Metrics Header
          _buildMetricsHeader(theme),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Labour Person")
                  .where("Work Type", isEqualTo: widget.category.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading personnel"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "No personnel found for this category",
                          style: TextStyle(color: Colors.grey),
                        ),
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
                    return InkWell(
                      onLongPress: () => _showDeleteDialog(ds.id),
                      child: _personCard(ds, theme),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsHeader(ThemeData theme) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Extras")
          .doc(widget.category.id)
          .snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data() as Map<String, dynamic>?;
        final totalPcs = data?['Total Pieces']?.toString() ?? "0";
        final totalAmount = data?['Total Amount']?.toString() ?? "0";

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.05),
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.primary.withOpacity(0.1),
              ),
            ),
          ),
          child: Row(
            children: [
              _metricItem(
                "Total Pieces",
                totalPcs,
                Icons.inventory_2_outlined,
                theme.colorScheme.primary,
              ),
              const SizedBox(width: 24),
              _metricItem(
                "Total Value",
                "PKR $totalAmount",
                Icons.payments_outlined,
                Colors.green,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _metricItem(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _personCard(DocumentSnapshot ds, ThemeData theme) {
    final name = ds.id;
    final address = ds["Address"] ?? "N/A";
    final phone = ds["Phone"] ?? "N/A";

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
                const Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(address, style: const TextStyle(fontSize: 12)),
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
              builder: (context) => Labourpersondetail(
                personName: name,
                category: widget.category.id,
              ),
            ),
          );
        },
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
                "Register Personnel",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  prefixIcon: Icon(Icons.person_outline),
                ),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: "Address",
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                keyboardType: TextInputType.streetAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),
              AddButton(
                isLoading: _isLoading,
                text: "Register Person",
                fn: () => _addLabourPerson(
                  _nameController.text,
                  _locationController.text,
                  _phoneController.text,
                  context,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addLabourPerson(
    String name,
    String loc,
    String ph,
    BuildContext context,
  ) async {
    String pName = name.trim();
    String location = loc.trim();
    String phone = ph.trim();

    if (pName.isEmpty || location.isEmpty || phone.isEmpty) {
      _showSnack("Please fill all fields.");
      return;
    }

    if (!RegExp(r'^[0-9]{7,15}$').hasMatch(phone)) {
      _showSnack("Enter a valid phone number.");
      return;
    }

    setState(() => _isLoading = true);
    try {
      DocumentReference ref = FirebaseFirestore.instance
          .collection("Labour Person")
          .doc(pName);
      DocumentSnapshot existing = await ref.get();

      if (existing.exists) {
        _showSnack("Person already exists.");
        if (mounted) Navigator.pop(context);
        return;
      }

      await ref.set({
        "Address": location,
        "Phone": phone,
        "Work Type": widget.category.id,
        "created_at": FieldValue.serverTimestamp(),
      });

      _nameController.clear();
      _locationController.clear();
      _phoneController.clear();
      if (mounted) Navigator.pop(context);
      _showSnack("Person registered successfully!");
    } catch (e) {
      _showSnack("Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
      QuerySnapshot persons = await FirebaseFirestore.instance
          .collection("Labour Person")
          .doc(item)
          .collection("Ledger")
          .get();

      for (var labourPerson in persons.docs) {
        await labourPerson.reference.delete();
      }

      // 2) Delete Supplier Category doc
      await FirebaseFirestore.instance
          .collection("Labour Person")
          .doc(item)
          .delete();

      _showSnack("Category deleted successfully");
    } catch (e) {
      _showSnack("Error deleting category: $e");
    }
  }
}
