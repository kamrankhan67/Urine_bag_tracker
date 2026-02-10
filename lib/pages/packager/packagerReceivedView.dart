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
                    .doc(widget.packagerName) // Ensure this is properly initialized
                    .collection("Recieved")
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
                            decoration: BoxDecoration(color: Colors.grey),
                            child: Column(
                              children: [
                                // Container(
                                //   margin: EdgeInsets.only(left: 20),
                                //   width: 150,
                                //   height: 40,
                                //   decoration: BoxDecoration(
                                //     color: Colors.blueGrey,
                                //     borderRadius: BorderRadius.circular(35),
                                //   ),
                                //   child: Center(
                                //     child: Text(
                                //       'Received',
                                //       style: TextStyle(
                                //         color: Colors.white,
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 17,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                Text(
                                  'Date : ${ds["Date"]}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Carton : ${ds["Received_carton"]}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Boxes : ${ds["Received_box"]}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Pieces : ${ds["Received_peices"]}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${ds["Status"]}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: const Color.fromARGB(255, 255, 0, 0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              _editReceived(context, ds.id);
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

  void _editReceived(BuildContext context, String id) async {
    
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("Packaging")
        .doc(widget.packagerName)
        .collection("Received")
        .doc(id)
        .get();

        TextEditingController dateController = TextEditingController(text: ds["Date"]);
  TextEditingController cartonController = TextEditingController(text: ds["Received_carton"].toString());
  TextEditingController statusController = TextEditingController(text: ds["Status"]);
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
              height: MediaQuery.of(context).size.height * 0.65,
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
                    "Edit Received",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: "Date",

                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: cartonController,
                    decoration: InputDecoration(
                      labelText: "Cartons",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: statusController,
                    decoration: InputDecoration(
                      labelText: "Status",
                      hintText: "Paid / UnPaid",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 16),
                  const Spacer(),
                  AddButton(fn: (){
                    FirebaseFirestore.instance.collection("Packaging").doc(widget.packagerName).collection("Recieved").doc(id).update({
                      "Date": dateController.text,
                      "Received_carton": int.parse(cartonController.text),
                      "Received_box": int.parse(cartonController.text)*48,
                      "Received_peices": int.parse(cartonController.text)*144,
                      "Status": statusController.text,
                    }).then((value) {
                      Navigator.pop(context);
                    });
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
