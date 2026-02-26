import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urine_bag/commons/addButton.dart';

class Notebook extends StatefulWidget {
  const Notebook({super.key});

  @override
  State<Notebook> createState() => _NotebookState();
}

class _NotebookState extends State<Notebook> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _nameController.dispose();
    _itemController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addNote() async {
    if (_dateController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _itemController.text.isEmpty ||
        _amountController.text.isEmpty) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection("Note")
          .add({
            "Date": _dateController.text,
            "Name": _nameController.text,
            "Item": _itemController.text,
            "Amount": int.tryParse(_amountController.text) ?? 0,
            "Description": _descriptionController.text,
            "Timestamp": FieldValue.serverTimestamp(),
          })
          .then((e) => Navigator.pop(context));

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Note added successfully")));

      _dateController.clear();
      _nameController.clear();
      _itemController.clear();
      _amountController.clear();
      _descriptionController.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(232, 226, 219, 1),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromRGBO(26, 50, 99, 1),
        title: const Text(
          'Daily Notebook',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () => _showAddNoteSheet(),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Note")
              .orderBy("Timestamp", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Error loading notes"));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No notes found"));
            }

            final notes = snapshot.data!.docs;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: MediaQuery.of(context).size.width + 150,
                padding: const EdgeInsets.all(12),
                child: Table(
                  border: TableBorder.all(color: Colors.black, width: 1),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Center(
                            child: Text(
                              "Date",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Center(
                            child: Text(
                              "Name",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Center(
                            child: Text(
                              "Item",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Center(
                            child: Text(
                              "Amount",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Center(
                            child: Text(
                              "Description",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...notes.map((doc) {
                      return TableRow(
                        children: [
                          GestureDetector(
                            onLongPress: () {
                              _showEditDeleteDialog(doc.id);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(doc['Date'] ?? '')),
                            ),
                          ),
                          GestureDetector(
                            onLongPress: () {
                              _showEditDeleteDialog(doc.id);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(doc['Name'] ?? '')),
                            ),
                          ),
                          GestureDetector(
                            onLongPress: () {
                              _showEditDeleteDialog(doc.id);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(doc['Item'] ?? '')),
                            ),
                          ),
                          GestureDetector(
                            onLongPress: () {
                              _showEditDeleteDialog(doc.id);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(doc['Amount'].toString()),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onLongPress: () {
                              _showEditDeleteDialog(doc.id);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(doc['Description'] ?? ''),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddNoteSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Add Note",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Date",
                      border: OutlineInputBorder(),
                    ),
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(
                      labelText: "Item",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Amount",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AddButton(fn: _addNote),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditDeleteDialog(String categoryId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titleTextStyle: TextStyle(color: Colors.white),
          title: const Text("Do you want to Delete it?"),
          backgroundColor: Colors.black,
          content: GestureDetector(
            onTap: () => _deleteLabourCategory(categoryId),
            child: Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 60, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteLabourCategory(String id) async {
    try {
      // 2) Delete main docs
      await FirebaseFirestore.instance.collection("Note").doc(id).delete();

      if (!mounted) return;
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Note deleted successfully")),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }
}
