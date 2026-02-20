import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urine_bag/commons/addButton.dart';

class PackagerRecievedView extends StatefulWidget {
  const PackagerRecievedView({super.key, required this.packagerName});
  final String packagerName;

  @override
  State<PackagerRecievedView> createState() => _PackagerRecievedViewState();
}

class _PackagerRecievedViewState extends State<PackagerRecievedView> {
  @override
  Widget build(BuildContext context) {
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
                        'Received Detail',
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
                    .doc(
                      widget.packagerName,
                    ) // Ensure this is properly initialized
                    .collection("Received")
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
                                SizedBox(height: 15),

                                GridView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 3.2,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                      ),
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade700,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Carton : ${ds["Received_carton"] ?? 0}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade700,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Boxes : ${ds["Received_box"] ?? 0}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade700,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Pieces : ${ds["Received_pieces"] ?? 0}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade700,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Status : ${ds["Status"] ?? 0}",
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              239,
                                              133,
                                              133,
                                            ),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () {
                                    _editReceived(context, ds.id);
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

  // void _editReceived(BuildContext context, String id) async {
  //   DocumentSnapshot ds = await FirebaseFirestore.instance
  //       .collection("Packaging")
  //       .doc(widget.packagerName)
  //       .collection("Received")
  //       .doc(id)
  //       .get();

  //   TextEditingController dateController = TextEditingController(
  //     text: ds["Date"],
  //   );
  //   TextEditingController cartonController = TextEditingController(
  //     text: ds["Received_carton"].toString(),
  //   );
  //   TextEditingController statusController = TextEditingController(
  //     text: ds["Status"],
  //   );
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return SingleChildScrollView(
  //         physics: BouncingScrollPhysics(),
  //         child: Padding(
  //           padding: EdgeInsets.only(
  //             bottom: MediaQuery.of(context).viewInsets.bottom,
  //           ),
  //           child: Container(
  //             padding: const EdgeInsets.all(16),
  //             margin: EdgeInsets.symmetric(horizontal: 20),
  //             height: MediaQuery.of(context).size.height * 0.65,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Center(
  //                   child: Container(
  //                     width: 40,
  //                     height: 5,
  //                     margin: const EdgeInsets.only(bottom: 16),
  //                     decoration: BoxDecoration(
  //                       color: Colors.grey[400],
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                   ),
  //                 ),
  //                 const Text(
  //                   "Edit Received",
  //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //                 ),
  //                 const SizedBox(height: 16),
  //                 TextField(
  //                   controller: dateController,
  //                   decoration: InputDecoration(
  //                     labelText: "Date",

  //                     border: OutlineInputBorder(),
  //                   ),
  //                   keyboardType: TextInputType.datetime,
  //                 ),
  //                 const SizedBox(height: 16),
  //                 TextField(
  //                   controller: cartonController,
  //                   decoration: InputDecoration(
  //                     labelText: "Cartons",
  //                     border: OutlineInputBorder(),
  //                   ),
  //                   keyboardType: TextInputType.number,
  //                 ),
  //                 const SizedBox(height: 16),
  //                 TextField(
  //                   controller: statusController,
  //                   decoration: InputDecoration(
  //                     labelText: "Status",
  //                     hintText: "Paid / UnPaid",
  //                     border: OutlineInputBorder(),
  //                   ),
  //                   keyboardType: TextInputType.text,
  //                 ),
  //                 const SizedBox(height: 16),
  //                 const Spacer(),
  //                 AddButton(
  //                   fn: () async {
  //                     await FirebaseFirestore.instance
  //                         .collection("Packaging")
  //                         .doc(widget.packagerName)
  //                         .collection("Received")
  //                         .doc(id)
  //                         .update({
  //                           "Date": dateController.text,
  //                           "Received_carton": int.parse(cartonController.text),
  //                           "Received_box":
  //                               int.parse(cartonController.text) * 48,
  //                           "Received_pieces":
  //                               int.parse(cartonController.text) * 144,
  //                           "Status": statusController.text,
  //                         });
  //                     await FirebaseFirestore.instance
  //                         .collection("Packaging")
  //                         .doc(widget.packagerName)
  //                         .update({
  //                           "Received Carton": FieldValue.increment(
  //                             int.parse(cartonController.text) -
  //                                 ds["Received_carton"],
  //                           ),
  //                           "Boxes": FieldValue.increment(
  //                             (int.parse(cartonController.text) * 48) -
  //                                 ds["Received_box"],
  //                           ),
  //                           "Pieces": FieldValue.increment(
  //                             (int.parse(cartonController.text) * 144) -
  //                                 ds["Received_pieces"],
  //                           ),
  //                         })
  //                         .then((value) => Navigator.pop(context));
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  void _editReceived(BuildContext context, String id) async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("Packaging")
        .doc(widget.packagerName)
        .collection("Received")
        .doc(id)
        .get();

    if (!ds.exists) return;

    final TextEditingController dateController = TextEditingController(
      text: ds["Date"] ?? "",
    );
    final TextEditingController cartonController = TextEditingController(
      text: ds["Received_carton"].toString(),
    );
    final TextEditingController statusController = TextEditingController(
      text: ds["Status"] ?? "",
    );

    const int BOX_MULTIPLIER = 48;
    const int PIECE_MULTIPLIER = 144;

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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "Edit Received",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          labelText: "Date",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: cartonController,
                        decoration: const InputDecoration(
                          labelText: "Cartons",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: statusController,
                        decoration: const InputDecoration(
                          labelText: "Status",
                          hintText: "Paid / UnPaid",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      isLoading
                          ? const CircularProgressIndicator()
                          : AddButton(
                              fn: () async {
                                setModalState(() => isLoading = true);

                                try {
                                  int newCartons =
                                      int.tryParse(cartonController.text) ?? 0;
                                  int oldCartons = ds["Received_carton"] ?? 0;
                                  int newBoxes = newCartons * BOX_MULTIPLIER;
                                  int oldBoxes = ds["Received_box"] ?? 0;
                                  int newPieces = newCartons * PIECE_MULTIPLIER;
                                  int oldPieces = ds["Received_pieces"] ?? 0;

                                  // Update subcollection document
                                  await FirebaseFirestore.instance
                                      .collection("Packaging")
                                      .doc(widget.packagerName)
                                      .collection("Received")
                                      .doc(id)
                                      .update({
                                        "Date": dateController.text,
                                        "Received_carton": newCartons,
                                        "Received_box": newBoxes,
                                        "Received_pieces": newPieces,
                                        "Status": statusController.text,
                                      });

                                  // Update parent document safely
                                  await FirebaseFirestore.instance
                                      .collection("Packaging")
                                      .doc(widget.packagerName)
                                      .update({
                                        "Received Carton": FieldValue.increment(
                                          newCartons - oldCartons,
                                        ),
                                        "Boxes": FieldValue.increment(
                                          newBoxes - oldBoxes,
                                        ),
                                        "Pieces": FieldValue.increment(
                                          newPieces - oldPieces,
                                        ),
                                      });

                                  Navigator.pop(context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Error updating data: $e"),
                                    ),
                                  );
                                }

                                setModalState(() => isLoading = false);
                              },
                            ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    ).whenComplete(() {
      // Dispose controllers to prevent memory leaks
      dateController.dispose();
      cartonController.dispose();
      statusController.dispose();
    });
  }
}
