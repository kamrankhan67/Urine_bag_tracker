// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:urine_bag/commons/addButton.dart';
// import 'package:urine_bag/pages/supplier/supplierDetal.dart';

// class Supplier extends StatefulWidget {
//   const Supplier({super.key});

//   @override
//   State<Supplier> createState() => _SupplierState();
// }

// class _SupplierState extends State<Supplier> {
//   bool _isLoading = false;
//   Future<void> _performTask() async {
//     setState(() {
//       _isLoading = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController _addSupplierController =
//         TextEditingController();
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(232, 226, 219, 1),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 height: 70,
//                 padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   color: Color.fromRGBO(26, 50, 99, 1),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(10),
//                     bottomRight: Radius.circular(10),
//                   ),
//                 ),
//                 child: Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         icon: Icon(
//                           Icons.arrow_back_rounded,
//                           color: Colors.white,
//                         ),
//                       ),

//                       Text(
//                         'Supplier',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 23,
//                         ),
//                       ),
//                       SizedBox(width: MediaQuery.of(context).size.width / 6),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),

//               StreamBuilder(
//                 stream: FirebaseFirestore.instance
//                     .collection("Supplier")
//                     .snapshots(),
//                 builder: (context, AsyncSnapshot snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(
//                       child: CircularProgressIndicator(color: Colors.lightBlue),
//                     );
//                   } else if (snapshot.hasError) {
//                     print("Error in StreamBuilder: ${snapshot.error}");
//                     return const Center(child: Text("Error loading supplies"));
//                   } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return const Center(child: Text("No Supplies found"));
//                   }
//                   return ListView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: snapshot.data!.docs.length,
//                     itemBuilder: (context, index) {
//                       DocumentSnapshot ds = snapshot.data!.docs[index];
//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   SupplierDetail(supplyItem: ds["name"]),
//                             ),
//                           );
//                         },
//                         child: _supplierContainer(ds["name"], context),
//                       );
//                     },
//                   );
//                 },
//               ),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),

//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.black,
//         foregroundColor: Colors.white,
//         onPressed: () {
//           showModalBottomSheet(
//             context: context,
//             isScrollControlled: true,
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             builder: (context) {
//               return Padding(
//                 padding: EdgeInsets.only(
//                   bottom: MediaQuery.of(context).viewInsets.bottom,
//                 ),
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   margin: EdgeInsets.symmetric(horizontal: 20),
//                   height: MediaQuery.of(context).size.height * 0.4,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Center(
//                         child: Container(
//                           width: 40,
//                           height: 5,
//                           margin: const EdgeInsets.only(bottom: 16),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[400],
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),

//                       const Text(
//                         "Add Supplier",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),

//                       const SizedBox(height: 16),

//                       TextField(
//                         controller: _addSupplierController,
//                         decoration: InputDecoration(
//                           labelText: "Name",
//                           border: OutlineInputBorder(),
//                         ),
//                       ),

//                       const Spacer(),
//                       AddButton(
//                         isLoading: _isLoading,
//                         fn: () =>
//                             _addSupply(_addSupplierController.text, context),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   Widget _supplierContainer(String text, BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(84, 119, 146, 1),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       width: MediaQuery.of(context).size.width,
//       height: 50,
//       margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: Row(
//         children: [
//           Text(
//             text,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//               color: Colors.white,
//             ),
//           ),
//           Spacer(),
//           Icon(Icons.arrow_forward_outlined, color: Colors.white, size: 30),
//         ],
//       ),
//     );
//   }

//   Future<void> _addSupply(String text, BuildContext context) async {
//     String supplierName = text.trim();

//     if (supplierName.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Supplier name cannot be empty.")),
//       );
//       return;
//     }

//     try {
//       DocumentReference supplierRef = FirebaseFirestore.instance
//           .collection("Supplier")
//           .doc(supplierName);

//       DocumentSnapshot existingSupplier = await supplierRef.get();

//       if (existingSupplier.exists) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Supplier already exists.")),
//         );
//         return;
//       }

//       // Create Supplier
//       await supplierRef.set({
//         "name": supplierName,
//         "created_at": FieldValue.serverTimestamp(),
//       });

//       // Create Inventory entry
//       await FirebaseFirestore.instance
//           .collection("Inventory")
//           .doc(supplierName)
//           .set({
//             "name": supplierName,
//             "quantity": 0,
//             "expected_carton": 0,
//             "value": 0,
//             "total_value": 0,
//             "total_quantity": 0,
//             "created_at": FieldValue.serverTimestamp(),
//           });

//       if (!mounted) return;

//       Navigator.pop(context);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Supplier added successfully!")),
//       );
//     } catch (e) {
//       if (!mounted) return;

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
//     }
//   }
// }

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
  bool _isLoading = false;

  // Function to simulate adding a supplier
  Future<void> _performTask() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate a delay or network operation (e.g., Firestore operation)
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isLoading = false;
    });
  }

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
                      const Text(
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
              const SizedBox(height: 10),
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
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index];
                      return GestureDetector(
                        onLongPress: () {
                          _showEditDeleteDialog(ds["name"], ds["name"]);
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SupplierDetail(supplyItem: ds["name"]),
                            ),
                          );
                        },
                        child: _supplierContainer(ds["name"], context),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
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
                  margin: const EdgeInsets.symmetric(horizontal: 20),
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
                        decoration: const InputDecoration(
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

  Future<void> _addSupply(String text, BuildContext context) async {
    String supplierName = text.trim();

    if (supplierName.isEmpty) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Supplier name cannot be empty.")),
      );
      return;
    }

    try {
      setState(() {
        _isLoading = true; // Start loading
      });

      DocumentReference supplierRef = FirebaseFirestore.instance
          .collection("Supplier")
          .doc(supplierName);

      DocumentSnapshot existingSupplier = await supplierRef.get();

      if (existingSupplier.exists) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Supplier already exists.")),
        );
        return;
      }

      // Create Supplier
      await supplierRef.set({
        "name": supplierName,
        "created_at": FieldValue.serverTimestamp(),
      });

      // Create Inventory entry
      await FirebaseFirestore.instance
          .collection("Inventory")
          .doc(supplierName)
          .set({
            "name": supplierName,
            "quantity": 0,
            "total value": 0,
            "total quantity": 0,
            "created_at": FieldValue.serverTimestamp(),
          });

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Supplier added successfully!")),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      setState(() {
        _isLoading = false; // End loading
      });
    }
  }

  void _showEditDeleteDialog(String item, String categoryId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titleTextStyle: TextStyle(color: Colors.white),
          title: Text("Do you want to delete $item ?"),
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

  Future<void> _deleteLabourCategory(String item) async {
    try {
      // 1) Delete all related docs in "Suplier Detail" where item == item
      final querySnap = await FirebaseFirestore.instance
          .collection("SuplierDetail")
          .where("item", isEqualTo: item)
          .get();

      for (final doc in querySnap.docs) {
        await doc.reference.delete();
      }

      // 2) Delete main docs
      await FirebaseFirestore.instance
          .collection("Supplier")
          .doc(item)
          .delete();
      QuerySnapshot ledgerDocs = await FirebaseFirestore.instance
          .collection("Inventory")
          .doc(item)
          .collection("Ledger")
          .get();
      for (var doc in ledgerDocs.docs) {
        if (doc.exists) {
          FirebaseFirestore.instance
              .collection("Inventory")
              .doc(item)
              .collection("Ledger")
              .doc(doc.id)
              .delete();
        }
      }
      await FirebaseFirestore.instance
          .collection("Inventory")
          .doc(item)
          .delete();

      if (!mounted) return;
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Category deleted successfully")),
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
