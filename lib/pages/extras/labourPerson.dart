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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const Text(
                        "Add Labour Person",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.name,
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: "Location",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.streetAddress,
                      ),
                      const SizedBox(height: 12),

                      TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: "Phone No",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),
                      const Spacer(),
                      AddButton(
                        fn: () => _addLabourPerson(
                          _nameController.text,
                          _locationController.text,
                          _phoneController.text,
                          context,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 70,
                padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(26, 50, 99, 1),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.category.id,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 6),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _inventoryDetailContainer(
                    "Total Pcs",
                    widget.category['Total Pieces']?.toString() ?? "0",
                    const Color.fromRGBO(26, 50, 99, 1),
                    context,
                  ),
                  _inventoryDetailContainer(
                    "Total Value",
                    widget.category['Total Amount']?.toString() ?? "0",
                    const Color.fromRGBO(84, 119, 146, 1),
                    context,
                  ),
                ],
              ),
              SizedBox(height: 20,),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Labour Person")
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.lightBlue),
                    );
                  } else if (snapshot.hasError) {
                    print("Error in StreamBuilder: ${snapshot.error}");
                    return const Center(child: Text("Error loading supplies"));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No Supplies found"));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index];
                      if (ds["Work Type"] != widget.category.id) {
                        return Container();
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Labourpersondetail(personName: ds.id,category:widget.category.id),
                            ),
                          );
                        },
                        child: _labourContainer(ds.id, context),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _labourContainer(String text, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(84, 119, 146, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_outlined,
            color: Colors.white,
            size: 30,
          ),
        ],
      ),
    );
  }

  Future<void> _addLabourPerson(
    String name,
    String loc,
    String ph,
    BuildContext context,
  ) async {
    String supplierName = name.trim();
    String location = loc.trim();
    String phone = ph.trim();

    if (supplierName.isEmpty) {
      Navigator.pop(context); // Close the bottom sheet before showing error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Labour Person name cannot be empty.")),
      );
      return;
    }

    if (location.isEmpty) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location cannot be empty.")),
      );
      return;
    }

    if (phone.isEmpty) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phone number cannot be empty.")),
      );
      return;
    }

    // Basic phone validation (digits only, 7–15 length)
    if (!RegExp(r'^[0-9]{7,15}$').hasMatch(phone)) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid phone number.")),
      );
      return;
    }

    try {
      DocumentReference ref = FirebaseFirestore.instance
          .collection("Labour Person")
          .doc(supplierName);

      DocumentSnapshot existing = await ref.get();

      if (existing.exists) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Labour Person already exists.")),
        );
        return;
      }

      await ref.set({
        "Address": location,
        "Phone": phone,
        "Work Type": widget.category.id,
        "created_at": FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Labour Person added successfully!")),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }


  Widget _inventoryDetailContainer(
    String text,
    String value,
    Color color,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      width: MediaQuery.of(context).size.width / 2.3,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
