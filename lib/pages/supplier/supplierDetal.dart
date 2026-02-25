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
  @override
  Widget build(BuildContext context) {
    TextEditingController _supplierController = TextEditingController();
    TextEditingController _locationController = TextEditingController();
    TextEditingController _phoneNoController = TextEditingController();
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
                        "Add Supplier",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextField(
                        controller: _supplierController,
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
                        controller: _phoneNoController,
                        decoration: InputDecoration(
                          labelText: "Phone No",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),
                      const Spacer(),
                      AddButton(
                        fn: () => _addSupply(
                          _supplierController.text,
                          _locationController.text,
                          _phoneNoController.text,
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
      backgroundColor: const Color.fromRGBO(232, 226, 219, 1),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 70,
              padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
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
                      icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                    ),

                    Text(
                      '${widget.supplyItem} Supplier',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width / 6),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),

            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("SuplierDetail")
                  .where(
                    "item",
                    isEqualTo: widget.supplyItem,
                  ) 
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.lightBlue),
                  );
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Error loading Suppliers"));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No Supplier found"));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SupplierPersonDetail(personName: ds.id,supplyItem: widget.supplyItem,),
                          ),
                        );
                      },
                      child: _itemSupplier(ds.id,),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemSupplier(String text) {
    return Container(
      decoration: BoxDecoration(color: Colors.blueGrey),
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

 Future<void> _addSupply(
  String name,
  String loc,
  String ph,
  BuildContext context,
) async {
  String supplierName = name.trim();
  String location = loc.trim();
  String phone = ph.trim();

  if (supplierName.isEmpty) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Supplier name cannot be empty.")),
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
        .collection("SuplierDetail")
        .doc(supplierName);

    DocumentSnapshot existing = await ref.get();

    if (existing.exists) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Supplier already exists.")),
      );
      return;
    }

    await ref.set({
      "location": location,
      "phone": phone,
      "item": widget.supplyItem,
      "created_at": FieldValue.serverTimestamp(),
    });

    if (!mounted) return;

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Supplier added successfully!")),
    );
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${e.toString()}")),
    );
  }
}

}
