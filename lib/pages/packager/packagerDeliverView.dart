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
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(
                              right: 20,
                              left: 20,
                              top: 20,
                              bottom: 5,
                            ),
                            width: MediaQuery.of(context).size.width,
                            //height: 100,
                            decoration: BoxDecoration(color: Colors.grey),
                            child: Column(
                              children: [
                                Text(
                                  "Date : ${ds["Date"]}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Bags : ${ds["Bags"]}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Gloves : ${ds["Gloves"]}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Sm Box : ${ds["Sm_Box"]}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Carton : ${ds["Carton"]}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Sap Paper : ${ds["Sap_Paper"]}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Bopp pouch : ${ds["Bopp_Pouch"]}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Seal : ${ds["Seal"]}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Sticker : ${ds["Sticker"]}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'tissue : ${ds["Tissue"]}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                Text(
                                  'Expected Cartons : ${ds["Delivered_Expected_carton"]}',
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _deliveredEdit(context, ds.id);
                            },
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 195, 211, 16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.edit, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    "Edit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
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

  void _deliveredEdit(BuildContext context, String id) async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("Packaging")
        .doc(widget.packagerName)
        .collection("Deliver")
        .doc(id)
        .get();
    TextEditingController cartonEditController = TextEditingController(
      text: ds["Carton"].toString(),
    );
    TextEditingController glovesEditController = TextEditingController(
      text: ds["Gloves"].toString(),
    );
    TextEditingController bagEditController = TextEditingController(
      text: ds["Bags"].toString(),
    );
    TextEditingController smBoxEditController = TextEditingController(
      text: ds["Sm_Box"].toString(),
    );
    TextEditingController sapPaperEditController = TextEditingController(
      text: ds["Sap_Paper"].toString(),
    );
    TextEditingController sealEditController = TextEditingController(
      text: ds["Seal"].toString(),
    );
    TextEditingController tissueEditController = TextEditingController(
      text: ds["Tissue"].toString(),
    );
    TextEditingController boppPouchEditController = TextEditingController(
      text: ds["Bopp_Pouch"].toString(),
    );
    TextEditingController stickerEditController = TextEditingController(
      text: ds["Sticker"].toString(),
    );
    TextEditingController dateEditController = TextEditingController(
      text: ds["Date"].toString(),
    );
    TextEditingController tapeEditController = TextEditingController(
      text: ds["Tape"].toString(),
    );

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
              height: MediaQuery.of(context).size.height * 1.33,
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
                    "Edit Deliver ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(height: 15),
                  TextField(
                    controller: dateEditController,
                    decoration: InputDecoration(
                      labelText: "Date",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: bagEditController,
                    decoration: InputDecoration(
                      labelText: "Bags",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: smBoxEditController,
                    decoration: InputDecoration(
                      labelText: "Sm Box",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: sapPaperEditController,
                    decoration: InputDecoration(
                      labelText: "Sap Paper",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: sealEditController,
                    decoration: InputDecoration(
                      labelText: "Seal",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: tissueEditController,
                    decoration: InputDecoration(
                      labelText: "Tissue",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: glovesEditController,
                    decoration: InputDecoration(
                      labelText: "GLoves",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: cartonEditController,
                    decoration: InputDecoration(
                      labelText: "Cartton",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: boppPouchEditController,
                    decoration: InputDecoration(
                      labelText: "Bopp Pouch",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: stickerEditController,
                    decoration: InputDecoration(
                      labelText: "Sticker",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: tapeEditController,
                    decoration: InputDecoration(
                      labelText: "Tape",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Spacer(),
                  AddButton(
                    fn: () async {
                      // Update the individual document first
                      await FirebaseFirestore.instance
                          .collection("Packaging")
                          .doc(widget.packagerName)
                          .collection("Deliver")
                          .doc(id)
                          .update({
                            "Date": dateEditController.text,
                            "Bags": int.tryParse(bagEditController.text) ?? 0,
                            "Sm_Box":
                                int.tryParse(smBoxEditController.text) ?? 0,
                            "Sap_Paper":
                                int.tryParse(sapPaperEditController.text) ?? 0,
                            "Seal": int.tryParse(sealEditController.text) ?? 0,
                            "Tissue":
                                int.tryParse(tissueEditController.text) ?? 0,
                            "Gloves":
                                int.tryParse(glovesEditController.text) ?? 0,
                            "Carton":
                                int.tryParse(cartonEditController.text) ?? 0,
                            "Bopp_Pouch":
                                int.tryParse(boppPouchEditController.text) ?? 0,
                            "Sticker":
                                int.tryParse(stickerEditController.text) ?? 0,
                            "Tape": int.tryParse(tapeEditController.text) ?? 0,
                          });

                      // Update the parent document (Packaging)
                      await FirebaseFirestore.instance
                          .collection("Packaging")
                          .doc(widget.packagerName)
                          .update({
                            "Gloves": FieldValue.increment(
                              (int.tryParse(glovesEditController.text) ?? 0) -
                                  (ds["Gloves"] ?? 0),
                            ),
                            "Bags": FieldValue.increment(
                              (int.tryParse(bagEditController.text) ?? 0) -
                                  (ds["Bags"] ?? 0),
                            ),
                            "Sm_Box": FieldValue.increment(
                              (int.tryParse(smBoxEditController.text) ?? 0) -
                                  (ds["Sm_Box"] ?? 0),
                            ),
                            "Sap_Paper": FieldValue.increment(
                              (int.tryParse(sapPaperEditController.text) ?? 0) -
                                  (ds["Sap_Paper"] ?? 0),
                            ),
                            "Seal": FieldValue.increment(
                              (int.tryParse(sealEditController.text) ?? 0) -
                                  (ds["Seal"] ?? 0),
                            ),
                            "Tissue": FieldValue.increment(
                              (int.tryParse(tissueEditController.text) ?? 0) -
                                  (ds["Tissue"] ?? 0),
                            ),
                            "Tape": FieldValue.increment(
                              (int.tryParse(tapeEditController.text) ?? 0) -
                                  (ds["Tape"] ?? 0),
                            ),
                            "Carton": FieldValue.increment(
                              (int.tryParse(cartonEditController.text) ?? 0) -
                                  (ds["Carton"] ?? 0),
                            ),
                            "Bopp_Pouch": FieldValue.increment(
                              (int.tryParse(boppPouchEditController.text) ??
                                      0) -
                                  (ds["Bopp_Pouch"] ?? 0),
                            ),
                            "Sticker": FieldValue.increment(
                              (int.tryParse(stickerEditController.text) ?? 0) -
                                  (ds["Sticker"] ?? 0),
                            ),
                            "Delivered_Expected_carton":
                                0, // You can set this to whatever value you want
                          });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
