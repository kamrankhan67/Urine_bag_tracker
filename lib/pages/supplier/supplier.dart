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
  @override
  Widget build(BuildContext context) {
    final TextEditingController _addSupplierController =
        TextEditingController();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(232, 226, 219, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          
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
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                      ),

                      Text(
                        'Supplier',
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
              SizedBox(height: 10),

              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Supplier")
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
                    physics:NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SupplierDetail(supplyItem: ds["name"],),
                            ),
                          );
                        },
                        child: _supplierContainer(ds["name"], context),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),

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
                  height: MediaQuery.of(context).size.height * 0.4,
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
                        controller: _addSupplierController,
                        decoration: InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const Spacer(),
                      AddButton(
                        fn: () =>
                            _addSupply(_addSupplierController.text, context),
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
    );
  }

  Widget _supplierContainer(String text, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(84, 119, 146, 1),
        borderRadius: BorderRadius.circular(15),
      ),
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          Spacer(),
          Icon(Icons.arrow_forward_outlined, color: Colors.white, size: 30),
        ],
      ),
    );
  }

  void _addSupply(String text, BuildContext context) async {
    if (text.isNotEmpty) {
      await FirebaseFirestore.instance.collection("Supplier").doc(text).set({
        "name": text,
      });
       await FirebaseFirestore.instance.collection("Inventory").doc(text).set({
        "name": text,
        "quantity":0,
        "expected cartton":0,
        "value":0,
        
      });
      Navigator.pop(context);
    } else {
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Supplier name cannot be empty."),
      ));
    }
  }
}



