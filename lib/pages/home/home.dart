import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urine_bag/commons/addButton.dart';
import 'package:urine_bag/commons/home_button.dart';
import 'package:urine_bag/pages/auth/authentication.dart';
import 'package:urine_bag/pages/inventory/inventory.dart';
import 'package:urine_bag/pages/packager/PackagerDetail.dart';
import 'package:urine_bag/pages/packager/packager.dart';
import 'package:urine_bag/pages/supplier/supplier.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _bagController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _glovesController = TextEditingController();
  final TextEditingController _smBoxController = TextEditingController();
  final TextEditingController _sapPaperController = TextEditingController();
  final TextEditingController _sealController = TextEditingController();
  final TextEditingController _tissueController = TextEditingController();
  final TextEditingController _cartonController = TextEditingController();
  final TextEditingController _boppPouchController = TextEditingController();
  final TextEditingController _stickerController = TextEditingController();
  final TextEditingController _tapeController = TextEditingController();
  final TextEditingController _recievedCartonController =
      TextEditingController();
  final TextEditingController _recievedDateController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  QuerySnapshot<Map<String, dynamic>>? PackagerListQuery;
  // List<DocumentSnapshot<Map<String, dynamic>>> PackagerList = [];
  String? selectedItem;
  String? receivedSelectedItem;

  // Fetch packager data from Firebase
  // void _getPackager() async {
  //   PackagerListQuery = await FirebaseFirestore.instance
  //       .collection("Packaging")
  //       .get();

  //   setState(() {
  //     PackagerList = PackagerListQuery!.docs;
  //     if (PackagerList.isNotEmpty) {
  //       // Set default selected item to the first packager
  //       selectedItem = PackagerList[0].id;
  //     } else {
  //       selectedItem = "No Packager found";
  //     }
  //   });
  List<String> PackagerList = []; // List to store document IDs

  @override
  void initState() {
    super.initState();
    getDocumentIds();
  }

  Future<void> getDocumentIds() async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference collectionRef = FirebaseFirestore.instance.collection(
        'Packaging',
      );

      // Get all documents from the collection
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Extract document IDs and add them to the list
      List<String> packagerIds = [];
      for (var doc in querySnapshot.docs) {
        packagerIds.add(doc.id); // Add each document ID to the list
      }

      setState(() {
        PackagerList = packagerIds; // Set the packager list
        if (PackagerList.isNotEmpty && selectedItem == null) {
          selectedItem = PackagerList.first;
        }
      });
    } catch (e) {
      print("Error getting document IDs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("RecievedSelectedItem$receivedSelectedItem");
    print("Selected item $selectedItem");

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Authentication()),
          );
        },
        child: Icon(Icons.menu_book, color: Colors.white),
      ),
      backgroundColor: const Color.fromRGBO(232, 226, 219, 1),

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
                child: Text(
                  'Hi, Munir and Sons',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 200,

                child: Image.asset(
                  'assets/images/logo_png.png',
                  fit: BoxFit.fill,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  _homeContainer(
                    "Total Bags",
                    '34',
                    '100',
                    Color.fromRGBO(12, 44, 85, 1),
                    context,
                  ),
                  _homeContainer(
                    "Ready Bags",
                    '34',
                    '100',
                    Color.fromRGBO(41, 99, 116, 1),
                    context,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) {
                          return SingleChildScrollView(
                            physics: BouncingScrollPhysics(),

                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(
                                  context,
                                ).viewInsets.bottom,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height:
                                    MediaQuery.of(context).size.height * 1.40,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Container(
                                        width: 40,
                                        height: 5,
                                        margin: const EdgeInsets.only(
                                          bottom: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[400],
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const Text(
                                      "Deliver Item",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 16),
                                    PackagerList.isEmpty
                                        ? Center(
                                            child: Text("No Packager found"),
                                          )
                                        : DropdownButton<String>(
                                            value:
                                                PackagerList.contains(
                                                  selectedItem,
                                                )
                                                ? selectedItem
                                                : null,
                                            hint: Text("Select Packager"),
                                            isExpanded: true,
                                            onChanged: (String? value) {
                                              setState(() {
                                                selectedItem = value;
                                              });
                                            },
                                            items: PackagerList.map(
                                              (element) =>
                                                  DropdownMenuItem<String>(
                                                    value: element,
                                                    child: Text(element),
                                                  ),
                                            ).toList(),
                                          ),
                                    SizedBox(height: 15),
                                    TextField(
                                      controller: _dateController,
                                      decoration: InputDecoration(
                                        labelText: "Date",
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.datetime,
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: _bagController,
                                      decoration: InputDecoration(
                                        labelText: "Bags",
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                    const SizedBox(height: 16),

                                    TextField(
                                      controller: _smBoxController,
                                      decoration: InputDecoration(
                                        labelText: "Sm Box",
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                    const SizedBox(height: 16),

                                    TextField(
                                      controller: _sapPaperController,
                                      decoration: InputDecoration(
                                        labelText: "Sap Paper",
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                    const SizedBox(height: 16),

                                    TextField(
                                      controller: _sealController,
                                      decoration: InputDecoration(
                                        labelText: "Seal",
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                    const SizedBox(height: 16),

                                    TextField(
                                      controller: _tissueController,
                                      decoration: InputDecoration(
                                        labelText: "Tissue",
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                    const SizedBox(height: 16),

                                    TextField(
                                      controller: _glovesController,
                                      decoration: InputDecoration(
                                        labelText: "GLoves",
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                    const SizedBox(height: 16),

                                    TextField(
                                      controller: _cartonController,
                                      decoration: InputDecoration(
                                        labelText: "Cartton",
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                    const SizedBox(height: 16),

                                    TextField(
                                      controller: _boppPouchController,
                                      decoration: InputDecoration(
                                        labelText: "Bopp Pouch",
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                    const SizedBox(height: 16),

                                    TextField(
                                      controller: _stickerController,
                                      decoration: InputDecoration(
                                        labelText: "Sticker",
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: _tapeController,
                                      decoration: InputDecoration(
                                        labelText: "Tape",
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                    const SizedBox(height: 16),

                                    const Spacer(),
                                    AddButton(
                                      fn: () {
                                        if (selectedItem == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Please select a packager",
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        _sendItem(
                                          _dateController.text,
                                          selectedItem!,
                                          int.tryParse(
                                                _glovesController.text,
                                              ) ??
                                              0,
                                          int.tryParse(_bagController.text) ??
                                              0,
                                          int.tryParse(_smBoxController.text) ??
                                              0,
                                          int.tryParse(
                                                _sapPaperController.text,
                                              ) ??
                                              0,
                                          int.tryParse(_sealController.text) ??
                                              0,
                                          int.tryParse(
                                                _tissueController.text,
                                              ) ??
                                              0,
                                          int.tryParse(_tapeController.text) ??
                                              0,
                                          int.tryParse(
                                                _cartonController.text,
                                              ) ??
                                              0,
                                          int.tryParse(
                                                _boppPouchController.text,
                                              ) ??
                                              0,
                                          int.tryParse(
                                                _stickerController.text,
                                              ) ??
                                              0,
                                          context,
                                        );
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
                    child: Container(
                      width: 150,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrangeAccent,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send_sharp, color: Colors.white, size: 32),
                          Text("Send", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) {
                          return SingleChildScrollView(
                            physics: BouncingScrollPhysics(),

                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(
                                  context,
                                ).viewInsets.bottom,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height:
                                    MediaQuery.of(context).size.height * 0.65,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Container(
                                        width: 40,
                                        height: 5,
                                        margin: const EdgeInsets.only(
                                          bottom: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[400],
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const Text(
                                      "Recieved Item",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 16),
                                    PackagerList.isEmpty
                                        ? Center(
                                            child: Text("No Packager found"),
                                          )
                                        : DropdownButton<String>(
                                            value: selectedItem,
                                            hint: Text("Select Packager"),
                                            isExpanded: true,
                                            onChanged: (String? value) {
                                              setState(() {
                                                receivedSelectedItem = value;
                                              });
                                            },
                                            items: PackagerList.map(
                                              (element) =>
                                                  DropdownMenuItem<String>(
                                                    value: element,
                                                    child: Text(element),
                                                  ),
                                            ).toList(),
                                          ),

                                    SizedBox(height: 15),
                                    TextField(
                                      controller: _recievedDateController,
                                      decoration: InputDecoration(
                                        labelText: "Date",
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.datetime,
                                    ),
                                    const SizedBox(height: 16),

                                    TextField(
                                      controller: _recievedCartonController,
                                      decoration: InputDecoration(
                                        labelText: "Cartons",
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: _statusController,
                                      decoration: InputDecoration(
                                        labelText: "Status",
                                        hintText: "Paid / UnPaid",
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.text,
                                    ),
                                    const SizedBox(height: 16),

                                    const SizedBox(height: 16),

                                    const Spacer(),
                                    AddButton(
                                      fn: () {
                                        if (selectedItem == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Please select a packager",
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        _recievedItem(
                                          _recievedDateController.text,
                                          receivedSelectedItem!,
                                          int.tryParse(
                                                _recievedCartonController.text,
                                              ) ??
                                              0,
                                          _statusController.text,
                                          context,
                                        );
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
                    child: Container(
                      width: 150,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(255, 39, 114, 32),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.call_received_outlined,
                            color: Colors.white,
                            size: 32,
                          ),
                          Text(
                            "Recieved",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10,
                ),
                child: HomeButton(
                  text: 'Inventory',
                  fn: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Inventory()),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10,
                ),
                child: HomeButton(
                  text: 'Supplier',
                  fn: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Supplier()),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10,
                ),
                child: HomeButton(
                  text: 'Packaging',
                  fn: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Packager()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _homeContainer(
    String text,
    String cartons,
    String peices,
    Color color,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(width: 1, color: color),
        borderRadius: BorderRadius.circular(15),
      ),
      width: MediaQuery.of(context).size.width / 2.1,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text('Cartons: $cartons', style: TextStyle(color: Colors.white)),
          Text('Peices:  $peices', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  void _sendItem(
    String date,
    String name,

    int gloves,
    int bags,
    int sm_box,
    int sap_paper,
    int seal,
    int tissue,
    int tape,
    int carton,
    int bopp_pouch,
    int sticker,
    BuildContext context,
  ) async {
    await FirebaseFirestore.instance
        .collection("Packaging")
        .doc(name)
        .collection("Deliver")
        .doc()
        .set({
          "Date": date,
          "Gloves": gloves,
          "Bags": bags,
          "Sm_Box": sm_box,
          "Sap_Paper": sap_paper,
          "Seal": seal,
          "Tissue": tissue,
          "Tape": tape,
          "Carton": carton,
          "Bopp_Pouch": bopp_pouch,
          "Sticker": sticker,
          "Delivered_Expected_carton": 0,
        });
    await FirebaseFirestore.instance.collection("Packaging").doc(name).update({
      "Gloves": FieldValue.increment(gloves),
      "Bags": FieldValue.increment(bags),
      "Sm_Box": FieldValue.increment(sm_box),
      "Sap_Paper": FieldValue.increment(sap_paper),
      "Seal": FieldValue.increment(seal),
      "Tissue": FieldValue.increment(tissue),
      "Tape": FieldValue.increment(tape),
      "Carton": FieldValue.increment(carton),
      "Bopp_Pouch": FieldValue.increment(bopp_pouch),
      "Sticker": FieldValue.increment(sticker),
      "Delivered_Expected_carton": 0,
    });
    await FirebaseFirestore.instance
        .collection("Inventory")
        .doc("Seal")
        .update({"quantity": FieldValue.increment(-seal)});
    await FirebaseFirestore.instance
        .collection("Inventory")
        .doc("Seal")
        .collection("Ledger")
        .doc()
        .set({
          "Date": date,
          "Quantity": "+$seal",
          "Color": "Red",
          "Description": name,
        });
    await FirebaseFirestore.instance
        .collection("Inventory")
        .doc("Sticker")
        .update({"quantity": FieldValue.increment(-sticker)});
    await FirebaseFirestore.instance.collection("Inventory").doc("Bags").update(
      {"quantity": FieldValue.increment(-bags)},
    );
    await FirebaseFirestore.instance
        .collection("Inventory")
        .doc("Sm_Box")
        .update({"quantity": FieldValue.increment(-sm_box)});
    await FirebaseFirestore.instance
        .collection("Inventory")
        .doc("Sap_Paper")
        .update({"quantity": FieldValue.increment(-sap_paper)});
    await FirebaseFirestore.instance.collection("Inventory").doc("Seal").update(
      {"quantity": FieldValue.increment(-seal)},
    );
    await FirebaseFirestore.instance
        .collection("Inventory")
        .doc("Tissue")
        .update({"quantity": FieldValue.increment(-tissue)});
    await FirebaseFirestore.instance
        .collection("Inventory")
        .doc("Bopp_Pouch")
        .update({"quantity": FieldValue.increment(-bopp_pouch)});

    await FirebaseFirestore.instance.collection("Inventory").doc("Tape").update(
      {"quantity": FieldValue.increment(-tape)},
    );
    await FirebaseFirestore.instance
        .collection("Inventory")
        .doc("Tissue")
        .update({"quantity": FieldValue.increment(-tissue)});
    Navigator.pop(context);
  }

  void _recievedItem(
    String date,
    String name,

    int carton,

    String status,

    BuildContext context,
  ) async {
    await FirebaseFirestore.instance
        .collection("Packaging")
        .doc(name)
        .collection("Received")
        .doc()
        .set({
          "Date": date,
          "Received_carton": carton,
          "Received_peices": carton * 144,
          "Received_box": carton * 48,
          "Status": status,
        });
    await FirebaseFirestore.instance
        .collection("Packaging")
        .doc(name)
        .update({
          "Received_carton": FieldValue.increment(carton),
          "Received_peices": FieldValue.increment(carton * 144),
          "Received_box": FieldValue.increment(carton * 48),
        })
        .then((value) => Navigator.pop(context));
  }
}
