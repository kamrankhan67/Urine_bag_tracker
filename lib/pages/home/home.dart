import 'package:flutter/material.dart';
import 'package:urine_bag/commons/addButton.dart';
import 'package:urine_bag/commons/home_button.dart';
import 'package:urine_bag/pages/auth/authentication.dart';
import 'package:urine_bag/pages/inventory/inventory.dart';
import 'package:urine_bag/pages/packager/packager.dart';
import 'package:urine_bag/pages/supplier/supplier.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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

                child: Image.asset('assets/images/logo_png.png',fit: BoxFit.fill,),
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
                                    MediaQuery.of(context).size.height * 1.21,
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
                                    DropdownMenu(
                                      width: double.infinity,
                                      hintText: "Select Packager",
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      dropdownMenuEntries: [
                                        DropdownMenuEntry(
                                          value: 1,
                                          label: "Zahid",
                                        ),
                                        DropdownMenuEntry(
                                          value: 2,
                                          label: "Kashif",
                                        ),
                                        DropdownMenuEntry(
                                          value: 3,
                                          label: "Ayyan",
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    TextField(
                                      decoration: InputDecoration(
                                        labelText: "Bags",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    TextField(
                                      decoration: InputDecoration(
                                        labelText: "Sm Box",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    TextField(
                                      decoration: InputDecoration(
                                        labelText: "Sap Paper",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    TextField(
                                      decoration: InputDecoration(
                                        labelText: "Seal",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    TextField(
                                      decoration: InputDecoration(
                                        labelText: "Tissue",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    TextField(
                                      decoration: InputDecoration(
                                        labelText: "GLoves",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    TextField(
                                      decoration: InputDecoration(
                                        labelText: "Cartton",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    TextField(
                                      decoration: InputDecoration(
                                        labelText: "Bopp Pouch",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    TextField(
                                      decoration: InputDecoration(
                                        labelText: "Sticker",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    const Spacer(),
                                    AddButton(fn: () => Navigator.pop(context)),
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
                                    DropdownMenu(
                                      width: double.infinity,
                                      hintText: "Select Packager",
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      dropdownMenuEntries: [
                                        DropdownMenuEntry(
                                          value: 1,
                                          label: "Zahid",
                                        ),
                                        DropdownMenuEntry(
                                          value: 2,
                                          label: "Kashif",
                                        ),
                                        DropdownMenuEntry(
                                          value: 3,
                                          label: "Ayyan",
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    TextField(
                                      decoration: InputDecoration(
                                        labelText: "Date",
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.datetime,
                                    ),
                                    const SizedBox(height: 16),

                                    TextField(
                                      decoration: InputDecoration(
                                        labelText: "Carttons",
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
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
                                    AddButton(fn: () => Navigator.pop(context)),
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
}
