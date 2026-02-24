import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:urine_bag/commons/addButton.dart';

class Waste extends StatefulWidget {
  const Waste({super.key});

  @override
  State<Waste> createState() => _WasteState();
}

class _WasteState extends State<Waste> {
  @override
  initState() {
    super.initState();
    _fetchInventoryDocs(); // Fetch inventory documents when the widget is initialized
  }

  Map<String, TextEditingController> controllers = {};
  List<String> inventoryDocIds = [];
  final TextEditingController _dateController = TextEditingController();

  Future<void> _fetchInventoryDocs() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Inventory')
          .get(); // Fetch all documents in the Inventory collection

      setState(() {
        // Store document IDs
        inventoryDocIds = snapshot.docs.map((doc) => doc.id).toList();

        // Initialize controllers for each document
        for (var docId in inventoryDocIds) {
          if (!controllers.containsKey(docId)) {
            controllers[docId] = TextEditingController();
          }
        }
      });
    } catch (e) {
      print("Error fetching inventory documents: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),

                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: MediaQuery.of(context).size.height * 1.40,
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
                          "Add Waste Items",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        SizedBox(height: 15),
                        TextField(
                          controller: _dateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Date",
                            border: OutlineInputBorder(),
                          ),
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );

                            if (picked != null) {
                              _dateController.text =
                                  "${picked.day}/${picked.month}/${picked.year}";
                            }
                          },
                        ),
                        ...inventoryDocIds.map((docId) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: TextField(
                              controller: controllers[docId],
                              decoration: InputDecoration(
                                labelText: docId,
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          );
                        }),

                        AddButton(
                          fn: () {
                            _sendData();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
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
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Waste Detail",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ),
                      ),
                      const SizedBox(width: 50),
                    ],
                  ),
                ),
              ),

              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Extras")
                    .doc("Waste")
                    .collection("Detail")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error fetching waste data: ${snapshot.error}");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Text("No waste data available.");
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      var data = doc.data() as Map<String, dynamic>;
                      data.remove("createdAt"); // Remove Timestamp from display
                      data.remove(
                        "Date",
                      ); // Remove Date from display since it's shown in the title
                      data.remove("LedgerDocId"); // Remove LedgerDocId from display
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
                                    'Date : ${doc["Date"] ?? 0}',
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
                                          "$key : ${data[key] ?? 0}",
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

                                SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () {
                                    _deleteData(doc.id);
                                  },
                                  child: Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        255,
                                        60,
                                        1,
                                      ),
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

  // Future<void> _deleteData(String docId) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection("Extras")
  //         .doc("Waste")
  //         .collection("Detail")
  //         .doc(docId)
  //         .get()
  //         .then((value) {
  //           if (value.exists) {
  //             var data = value.data() as Map<String, dynamic>;
  //             data.remove("Timestamp"); // Remove Timestamp from processing
  //             data.remove("Date"); // Remove Date from processing
  //             data.remove("LedgerDocId"); // Remove LedgerDocId from processing
  //             for (var entry in data.entries) {
  //               if (entry.value > 0) {
  //                 FirebaseFirestore.instance
  //                     .collection("Inventory")
  //                     .doc(entry.key)
  //                     .update({"quantity": FieldValue.increment(entry.value)});
  //               }
  //             }
  //           }
  //         });

  //     await FirebaseFirestore.instance
  //         .collection("Extras")
  //         .doc("Waste")
  //         .collection("Detail")
  //         .doc(docId)
  //         .delete();

  //     await FirebaseFirestore.instance
  //         .collection("Extras")
  //         .doc("Waste")
  //         .collection("Detail")
  //         .doc(docId)
  //         .get()
  //         .then((value) {
  //           if(value.exists){
  //             value["LedgerDocId"] != null ? FirebaseFirestore.instance
  //                 .collection("Inventory")
  //                 .doc("Inventory")
  //                 .collection("Ledger")
  //                 .doc(value["LedgerDocId"])
  //                 .delete() : null;
  //           }
  //         });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Waste data deleted successfully!")),
  //     );
  //   } catch (e) {
  //     print("Error deleting data: $e");
  //   }
  // }

  Future<void> _sendData() async {
    try {
      String randomDocId = DateTime.now().millisecondsSinceEpoch.toString();
      Map<String, dynamic> dataToSend = {};

      // Collect the data to send
      controllers.forEach((docId, controller) {
        int value = int.tryParse(controller.text.trim()) ?? 0;
        if (value < 0) value = 0; // prevent negative send
        dataToSend[docId] = value;
      });

      // Add the waste data to Firestore
      await FirebaseFirestore.instance
          .collection('Extras')
          .doc("Waste")
          .collection("Detail")
          .doc()
          .set({
            "LedgerDocId": randomDocId,
            "Date": _dateController.text,
            ...dataToSend,
            "createdAt": FieldValue.serverTimestamp(),
          });

      // Use a forEach to update the inventory and await each update
      for (var entry in dataToSend.entries) {
        if (entry.value > 0) {
          // Ensure value is positive before updating inventory
          await FirebaseFirestore.instance
              .collection("Inventory")
              .doc(entry.key)
              .update({"quantity": FieldValue.increment(-entry.value)});
          await FirebaseFirestore.instance
              .collection("Inventory")
              .doc(entry.key)
              .collection("Ledger")
              .doc(randomDocId)
              .set({
                "Quantity": -entry.value,
                "Description": "Waste",
                "Color": "Red",
                "Date": _dateController.text,
                "createdAt": FieldValue.serverTimestamp(),
              });
        }
      }

      // Close the bottom sheet after successful operation
      Navigator.pop(context); // Close the bottom sheet after adding data
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Waste data added successfully!")));
    } catch (e) {
      print("Error adding waste data: $e");

      // Optionally, show an error message to the user
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error adding waste data: $e")));
    }
  }
  Future<void> _deleteData(String docId) async {
  try {
    await FirebaseFirestore.instance
        .collection("Extras")
        .doc("Waste")
        .collection("Detail")
        .doc(docId)
        .get()
        .then((value) {
          if (value.exists) {
            var data = value.data() as Map<String, dynamic>;

            // Example of handling a Timestamp field comparison
            Timestamp createdAt = data["createdAt"];
            if (createdAt != null && createdAt.toDate().isBefore(DateTime.now())) {
              // Proceed if createdAt is before the current time
              data.remove("createdAt"); // Remove Timestamp from processing
              data.remove("Date"); // Remove Date from processing
              data.remove("LedgerDocId"); // Remove LedgerDocId from processing

              // Handle updating inventory based on the data entries
              for (var entry in data.entries) {
                if (entry.value > 0) {
                  FirebaseFirestore.instance
                      .collection("Inventory")
                      .doc(entry.key)
                      .update({"quantity": FieldValue.increment(entry.value)});
                }
              }
            }
          }
        });

    // Deleting the document from Firestore
    await FirebaseFirestore.instance
        .collection("Extras")
        .doc("Waste")
        .collection("Detail")
        .doc(docId)
        .delete();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Waste data deleted successfully!")),
    );
  } catch (e) {
    print("Error deleting data: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error deleting data: $e")),
    );
  }
}

}
