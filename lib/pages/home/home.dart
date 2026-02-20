import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urine_bag/commons/addButton.dart';
import 'package:urine_bag/commons/home_button.dart';
import 'package:urine_bag/pages/auth/authentication.dart';
import 'package:urine_bag/pages/home/home.dart';
import 'package:urine_bag/pages/inventory/inventory.dart';
import 'package:urine_bag/pages/packager/packager.dart';
import 'package:urine_bag/pages/supplier/supplier.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static  int readyBags=0 ;
  Map<String, TextEditingController> controllers = {};
  List<String> inventoryDocIds = [];
  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _recievedCartonController =
      TextEditingController();
  final TextEditingController _recievedDateController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  String? selectedItem;
  String? receivedSelectedItem;
  List<String> packagerDocIds = [];

  List<String> PackagerList = []; // List to store document IDs

  @override
  void initState() {
    super.initState();
    _fetchInventoryDocs();
    _fetchPackagerDocs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

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
    try {
      Map<String, dynamic> dataToSend = {};
      print("Data to send$dataToSend");

      // Loop through all controllers and prepare the data
      controllers.forEach((docId, controller) {
        print("Controller for $docId: ${controller.text}");
        int value =
            int.tryParse(controller.text) ?? 0; // Default to 0 if invalid
        dataToSend[docId] = value;
        print("docId: $docId, value: $value");
      });

      // Save data to Firebase under the selected packager
      await FirebaseFirestore.instance
          .collection('Packaging')
          .doc(selectedItem)
          .collection("Deliver")
          .doc()
          .set({
            'Actual Date': DateTime.now(),
            'Date': _dateController.text,
            'Delivered Expected Carton': 0,
            ...dataToSend, // Add all document data as key-value pairs
          });

      for (var entry in dataToSend.entries) {
        if (entry.value > 0) {
          await FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentReference invRef = FirebaseFirestore.instance
                .collection("Inventory")
                .doc(entry.key);

            DocumentSnapshot snapshot = await transaction.get(invRef);

            if (!snapshot.exists) return;

            // Update inventory atomically
            transaction.update(invRef, {
              "quantity": FieldValue.increment(-entry.value),
            });

            // Add ledger entry
            DocumentReference ledgerRef = invRef.collection("Ledger").doc();

            transaction.set(ledgerRef, {
              "Date": _dateController.text,
              "Quantity": "-${entry.value}",
              "Color": "Red",
              "Description": selectedItem!,
            });
          });
        }
      }

      await FirebaseFirestore.instance
          .collection('Packaging')
          .doc(selectedItem)
          .update({
            ...dataToSend.map((key, value) {
              return MapEntry(key, FieldValue.increment(value));
            }),
          });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Data sent successfully!")));
    } catch (e) {
      print("Error sending data: $e");
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    // Dispose of all controllers to avoid memory leaks
    controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
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
                  "Hi ! Munir and Sons",
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
                    "Extra",
                    '34',
                    '100',
                    Color.fromRGBO(12, 44, 85, 1),
                    context,
                  ),
                  _homeContainer(
                    "Ready Bags",
                    '$readyBags',
                    '${readyBags*48}',
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
                                    packagerDocIds.isEmpty
                                        ? Center(
                                            child: Text("No Packager found"),
                                          )
                                        : DropdownButton<String>(
                                            value:
                                                packagerDocIds.contains(
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
                                      decoration: InputDecoration(
                                        labelText: "Date",
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.datetime,
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
          "Received_pieces": carton * 144,
          "Received_box": carton * 48,
          "Status": status,
        });
   setState(() {
      readyBags += carton;
   });

    await FirebaseFirestore.instance
        .collection("Packaging")
        .doc(name)
        .update({
          "Received Carton": FieldValue.increment(carton),
          "Pieces": FieldValue.increment(carton * 144),
          "Boxes": FieldValue.increment(carton * 48),
        })
        .then((value) => Navigator.pop(context));
  }
}
