import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urine_bag/commons/addButton.dart';

class PackagerDetailView extends StatefulWidget {
  const PackagerDetailView({super.key, required this.packagerName});
  final String packagerName;

  @override
  State<PackagerDetailView> createState() => _PackagerDetailViewState();
}

class _PackagerDetailViewState extends State<PackagerDetailView> {
  Map<String, TextEditingController> controllers = {};
  List<String> inventoryDocIds = [];

  @override
  void initState() {
    super.initState();
    _fetchInventoryDocs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch data each time the widget is inserted or returned to the tree
    _fetchInventoryDocs();
  }

  Future<void> _fetchInventoryDocs() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Inventory')
          .get(); // Fetch all documents in the Inventory collection

      setState(() {
        // Store document IDs
        inventoryDocIds = snapshot.docs.map((doc) => doc.id).toList();

        // Initialize controllers for each document
      });
    } catch (e) {
      print("Error fetching inventory documents: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(232, 226, 219, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
                        'Delivered Detail',
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

              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Packaging")
                    .doc(widget.packagerName)
                    .collection("Deliver")
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
                      Map<String, dynamic> data =
                          ds.data() as Map<String, dynamic>;
                      data.remove("Actual Date");
                      data.remove("Date");
                      data.remove("Inventory Ledger");
                      data.remove("Delivered Expected Carton");
                      data.remove("createdAt");

                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 11, 20, 52),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                /// Title
                                Center(
                                  child: Text(
                                    'Date : ${ds["Date"] ?? 0}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 15),

                                /// 🔥 GRID VIEW
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 3.2,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                      ),
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    List<String> keys = data.keys.toList();
                                    String key = keys[index];

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade700,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "$key : ${ds[key] ?? 0}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 15),

                                /// ✅ Expected Carton (Shown Once)
                                Text(
                                  "Expected Cartons : ${ds["Delivered Expected Carton"] ?? 0}",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () {
                                    _deliveredEdit(context, ds.id);
                                  },
                                  child: Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Edit",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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

  //   void _deliveredEdit(BuildContext context, String id) async {
  //     DocumentSnapshot ds = await FirebaseFirestore.instance
  //         .collection("Packaging")
  //         .doc(widget.packagerName)
  //         .collection("Deliver")
  //         .doc(id)
  //         .get();
  //         Map<String, dynamic> deliverData =
  //     ds.data() as Map<String, dynamic>;

  //     setState(() {
  //       for (var docId in inventoryDocIds) {

  // controllers[docId] = TextEditingController(
  //   text: (deliverData[docId] ?? 0).toString(),
  // );

  //       }

  //     });
  //     final TextEditingController _dateController = TextEditingController(
  //         text: ds["Date"],
  //       );

  //     showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //       ),
  //       builder: (context) {
  //         return SingleChildScrollView(
  //           physics: BouncingScrollPhysics(),

  //           child: Padding(
  //             padding: EdgeInsets.only(
  //               bottom: MediaQuery.of(context).viewInsets.bottom,
  //             ),
  //             child: Container(
  //               padding: const EdgeInsets.all(16),
  //               margin: EdgeInsets.symmetric(horizontal: 20),
  //               height: MediaQuery.of(context).size.height * 1.33,
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Center(
  //                     child: Container(
  //                       width: 40,
  //                       height: 5,
  //                       margin: const EdgeInsets.only(bottom: 16),
  //                       decoration: BoxDecoration(
  //                         color: Colors.grey[400],
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                     ),
  //                   ),

  //                   const Text(
  //                     "Edit Deliver ",
  //                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //                   ),

  //                   const SizedBox(height: 16),

  //                   SizedBox(height: 15),
  //                   TextField(
  //                     controller: _dateController,
  //                     decoration: InputDecoration(
  //                       labelText: "Date",
  //                       border: OutlineInputBorder(),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 16),

  //                   ...inventoryDocIds.map((e) {
  //                     return Column(
  //                       children: [
  //                         TextField(
  //                           controller: controllers[e],
  //                           decoration: InputDecoration(
  //                             labelText: e,
  //                             border: OutlineInputBorder(),
  //                           ),
  //                         ),
  //                         SizedBox(height: 10,),
  //                       ],
  //                     );
  //                   },),

  //                   const Spacer(),
  //                   AddButton(
  //                     fn: () async {
  //                       // Update the individual document first
  //                       await FirebaseFirestore.instance
  //                           .collection("Packaging")
  //                           .doc(widget.packagerName)
  //                           .collection("Deliver")
  //                           .doc(id)
  //                           .update({
  //                             ...inventoryDocIds.asMap().map((index, docId) {
  //                               return MapEntry(
  //                                 docId,
  //                                 int.tryParse(controllers[docId]?.text ?? "0") ?? 0,
  //                               );

  //                             }),
  //                             "Date":_dateController.text,
  //                           });

  //                       // Update the parent document (Packaging)
  //                       await FirebaseFirestore.instance
  //                           .collection("Packaging")
  //                           .doc(widget.packagerName)
  //                           .update({
  //                             ...inventoryDocIds.asMap().map((key, value) {
  //                               String docId = value;
  //                               int newValue = int.tryParse(controllers[docId]?.text ?? "0") ?? 0;
  //                               int oldValue = deliverData[docId] ?? 0;

  //                               return MapEntry(
  //                                 docId,
  //                                 FieldValue.increment(newValue - oldValue),
  //                               );
  //                             },),

  //                             // You can set this to whatever value you want
  //                           });
  //                       Navigator.pop(context);
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //   }
  void _deliveredEdit(BuildContext context, String id) async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("Packaging")
        .doc(widget.packagerName)
        .collection("Deliver")
        .doc(id)
        .get();

    if (!ds.exists) return;

    Map<String, dynamic> deliverData = ds.data() as Map<String, dynamic>;

    // Initialize controllers
    setState(() {
      for (var docId in inventoryDocIds) {
        controllers[docId] = TextEditingController(
          text: (deliverData[docId] ?? 0).toString(),
        );
      }
    });

    final TextEditingController _dateController = TextEditingController(
      text: ds["Date"] ?? "",
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: StatefulBuilder(
              builder: (context, setModalState) {
                bool isLoading = false;
                return Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "Edit Deliver",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _dateController,
                        decoration: const InputDecoration(
                          labelText: "Date",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      ...inventoryDocIds.map((e) {
                        return Column(
                          children: [
                            TextField(
                              controller: controllers[e],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: e,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      }).toList(),

                      const SizedBox(height: 16),

                      isLoading
                          ? const CircularProgressIndicator()
                          : AddButton(
                              fn: () async {
                                setModalState(() => isLoading = true);

                                try {
                                  // Prepare updated values
                                  Map<String, dynamic> updatedFields = {};
                                  Map<String, dynamic> incrementFields = {};

                                  for (var docId in inventoryDocIds) {
                                    int newValue =
                                        int.tryParse(
                                          controllers[docId]?.text ?? "0",
                                        ) ??
                                        0;
                                    int oldValue = deliverData[docId] ?? 0;
                                    updatedFields[docId] = newValue;
                                    incrementFields[docId] =
                                        FieldValue.increment(
                                          newValue - oldValue,
                                        );
                                  }

                                  updatedFields["Date"] = _dateController.text;

                                  // Update Deliver subcollection
                                  await FirebaseFirestore.instance
                                      .collection("Packaging")
                                      .doc(widget.packagerName)
                                      .collection("Deliver")
                                      .doc(id)
                                      .update(updatedFields);

                                  // Update parent Packaging document
                                  await FirebaseFirestore.instance
                                      .collection("Packaging")
                                      .doc(widget.packagerName)
                                      .update(incrementFields);

                                  // await FirebaseFirestore.instance.collection("Inventroy").doc()
                                  for (var e in inventoryDocIds) {
                                    int newValue =
                                        int.tryParse(
                                          controllers[e]?.text ?? "0",
                                        ) ??
                                        0;
                                    int oldValue = deliverData[e] ?? 0;

                                    int difference = newValue - oldValue;

                                    if (difference != 0) {
                                      await FirebaseFirestore.instance
                                          .collection("Inventory")
                                          .doc(e)
                                          .update({
                                            "quantity": FieldValue.increment(
                                              -difference,
                                            ),
                                          });
                                          await FirebaseFirestore.instance.collection("Inventory").doc(e).collection("Ledger").doc(ds["Inventory Ledger"]).update({
                                            "Quantity": newValue,
                                          });
                                    }
                                  }

                                  Navigator.pop(context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Error updating deliver: $e",
                                      ),
                                    ),
                                  );
                                }

                                setModalState(() => isLoading = false);
                              },
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    ).whenComplete(() {
      // Dispose controllers when bottom sheet closes
      for (var c in controllers.values) {
        c.dispose();
      }
      controllers.clear();
    });
  }
}
