import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urine_bag/commons/addButton.dart';
import 'package:urine_bag/commons/home_button.dart';
import 'package:urine_bag/pages/auth/authentication.dart';
import 'package:urine_bag/pages/extras/extras.dart';
import 'package:urine_bag/pages/inventory/inventory.dart';
import 'package:urine_bag/pages/packager/packager.dart';
import 'package:urine_bag/pages/supplier/supplier.dart';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StreamSubscription<DocumentSnapshot>? _readyBagsSubscription;
  Map<String, TextEditingController> controllers = {};
  List<String> inventoryDocIds = [];
  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _recievedCartonController =
      TextEditingController();
  final TextEditingController _recievedDateController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  int readyBags = 0;
  int readyPieces = 0;
  String? selectedItem;
  String? receivedSelectedItem;
  List<String> packagerDocIds = [];

  List<String> PackagerList = []; // List to store document IDs

  @override
  void initState() {
    super.initState();
    _fetchInventoryDocs();
    _fetchPackagerDocs();
    _fetchReadyBags();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchInventoryDocs();
    _fetchPackagerDocs();
  }
Future<void> _fetchReadyBags() async {
  _readyBagsSubscription = FirebaseFirestore.instance
      .collection("Extras")
      .doc("Ready Bags")
      .snapshots()
      .listen((snapshot) {
    if (!mounted) return;

    if (snapshot.exists) {
      setState(() {
        readyBags = snapshot.get("Ready Cartons") ?? 0;
        readyPieces = snapshot.get("Ready Pieces") ?? 0;
      });
    }
  });
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

  Future<void> _fetchPackagerDocs() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Packaging')
          .get(); // Fetch all documents in the Inventory collection

      setState(() {
        // Store document IDs
        packagerDocIds = snapshot.docs.map((doc) => doc.id).toList();
        print(packagerDocIds);

        // Initialize controllers for each document
      });
    } catch (e) {
      print("Error fetching inventory documents: $e");
    }
  }

  Future<void> _sendData() async {
    if (selectedItem == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a packager")));
      return;
    }

    try {
      String randomId = DateTime.now().millisecondsSinceEpoch.toString();
      Map<String, dynamic> dataToSend = {};

      controllers.forEach((docId, controller) {
        int value = int.tryParse(controller.text.trim()) ?? 0;
        if (value < 0) value = 0; // prevent negative send
        dataToSend[docId] = value;
      });

      DocumentReference packagingRef = FirebaseFirestore.instance
          .collection('Packaging')
          .doc(selectedItem);

      // Save deliver record
      await packagingRef.collection("Deliver").doc().set({
        'Actual Date': DateTime.now(),
        'Date': _dateController.text.trim(),
        'Delivered Expected Carton': 0,
        "Inventory Ledger":randomId, 
        ...dataToSend,
      });

      // Update inventory using transactions
      for (var entry in dataToSend.entries) {
        if (entry.value > 0) {
          await FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentReference invRef = FirebaseFirestore.instance
                .collection("Inventory")
                .doc(entry.key);

            DocumentSnapshot snapshot = await transaction.get(invRef);

            if (!snapshot.exists) {
              throw Exception("Inventory item ${entry.key} does not exist.");
            }

            int currentQty = snapshot.get("quantity") ?? 0;

            if (currentQty < entry.value) {
              throw Exception(
                "Not enough stock for ${entry.key}. Available: $currentQty",
              );
            }

            transaction.update(invRef, {
              "quantity": FieldValue.increment(-entry.value),
            });

            DocumentReference ledgerRef = invRef.collection("Ledger").doc(randomId);

            transaction.set(ledgerRef, {
              "Date": _dateController.text.trim(),
              "Quantity": "-${entry.value}",
              "Color": "Red",
              "Description": selectedItem!,
              "Timestamp": FieldValue.serverTimestamp(),
            });
          });
        }
      }

      // Update packaging totals
      await packagingRef.update({
        ...dataToSend.map((key, value) {
          return MapEntry(key, FieldValue.increment(value));
        }),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Data sent successfully!")));

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  @override
void dispose() {
  _readyBagsSubscription?.cancel(); // VERY IMPORTANT

  controllers.forEach((key, controller) => controller.dispose());

  _dateController.dispose();
  _recievedCartonController.dispose();
  _recievedDateController.dispose();
  _statusController.dispose();

  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    
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
                  "Hi! Munir and Sons",
                   style: GoogleFonts.playfairDisplay(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
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
                    "Ready Bags",
                    '$readyBags',
                    '$readyPieces',
                    Color.fromRGBO(41, 99, 116, 1),
                    context,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Extras()),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(26, 50, 99, 1),
                        border: Border.all(
                          width: 1,
                          color: Color.fromRGBO(26, 50, 99, 1),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: MediaQuery.of(context).size.width / 2.1,
                      height: 130,
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Extras",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Icon(Icons.auto_awesome_motion_rounded,size: 28,color: Colors.white,)
                          ],
                        ),
                      ),
                    ),
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
                                    // packagerDocIds.isEmpty
                                    //     ? Center(
                                    //         child: Text("No Packager found"),
                                    //       )
                                    //     : DropdownButton<String>(
                                    //         value:
                                    //             packagerDocIds.contains(
                                    //               selectedItem,
                                    //             )
                                    //             ? selectedItem
                                    //             : null,
                                    //         hint: Text("Select Packager"),
                                    //         isExpanded: true,
                                    //         onChanged: (String? value) {
                                    //           setState(() {
                                    //             selectedItem = value;
                                    //           });
                                    //         },
                                    //         items: packagerDocIds
                                    //             .map(
                                    //               (element) =>
                                    //                   DropdownMenuItem<String>(
                                    //                     value: element,
                                    //                     child: Text(element),
                                    //                   ),
                                    //             )
                                    //             .toList(),
                                    //       ),
                                    packagerDocIds.isEmpty
                                        ? Center(
                                            child: Text("No Packager found"),
                                          )
                                        : DropdownButton<String>(
                                            value:
                                                selectedItem, // Pass selectedItem directly
                                            hint: Text("Select Packager"),
                                            isExpanded: true,
                                            onChanged: (String? value) {
                                              setState(() {
                                                selectedItem =
                                                    value; // update the selected value
                                              });
                                            },
                                            items: packagerDocIds
                                                .map(
                                                  (element) =>
                                                      DropdownMenuItem<String>(
                                                        value: element,
                                                        child: Text(element),
                                                      ),
                                                )
                                                .toList(),
                                          ),

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
                                        margin: EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
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
                                          Navigator.pop(context);
                                          return;
                                        }
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
                                    packagerDocIds.isEmpty
                                        ? Center(
                                            child: Text("No Packager found"),
                                          )
                                        : DropdownButton<String>(
                                            value:
                                                packagerDocIds.contains(
                                                  receivedSelectedItem,
                                                )
                                                ? receivedSelectedItem
                                                : null,
                                            hint: Text("Select Packager"),
                                            isExpanded: true,
                                            onChanged: (String? value) {
                                              setState(() {
                                                receivedSelectedItem = value;
                                              });
                                            },
                                            items: packagerDocIds
                                                .map(
                                                  (element) =>
                                                      DropdownMenuItem<String>(
                                                        value: element,
                                                        child: Text(element),
                                                      ),
                                                )
                                                .toList(),
                                          ),

                                    SizedBox(height: 15),
                                    TextField(
                                      controller: _recievedDateController,
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
                                          _recievedDateController.text =
                                              "${picked.day}/${picked.month}/${picked.year}";
                                        }
                                      },
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
                                        if (receivedSelectedItem == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Please select a packager",
                                              ),
                                            ),
                                          );
                                          Navigator.pop(context);
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

  Future<void> _recievedItem(
    String date,
    String name,
    int carton,
    String status,
    BuildContext context,
  ) async {
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid packager name")));
      return;
    }

    if (carton <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Carton must be greater than 0")),
      );
      return;
    }

    try {
      DocumentReference packagingRef = FirebaseFirestore.instance
          .collection("Packaging")
          .doc(name);

      await packagingRef.collection("Received").doc().set({
        "Date": date.trim(),
        "Received_carton": carton,
        "Received_pieces": carton * 144,
        "Received_box": carton * 48,
        "Status": status.trim(),
        "createdAt": FieldValue.serverTimestamp(),
      });

      await packagingRef.update({
        "Received Carton": FieldValue.increment(carton),
        "Pieces": FieldValue.increment(carton * 144),
        "Boxes": FieldValue.increment(carton * 48),
      });

      if (!mounted) return;

      final docRef = FirebaseFirestore.instance
    .collection("Extras")
    .doc("Ready Bags");

final doc = await docRef.get();

if (doc.exists) {
  await docRef.update({
    "Ready Cartons": FieldValue.increment(carton),
    "Ready Pieces": FieldValue.increment(carton * 144),
  });
} else {
  await docRef.set({
    "Ready Cartons": carton,
    "Ready Pieces": carton * 144,
  });
}

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Received item added successfully!")),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }
}
