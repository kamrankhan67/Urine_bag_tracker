import 'package:flutter/material.dart';
import 'package:urine_bag/commons/addButton.dart';

class PackagerDetailView extends StatelessWidget {
  const PackagerDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(232, 226, 219, 1),
      body: SafeArea(
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
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 5),
              width: MediaQuery.of(context).size.width,
              //height: 100,
              decoration: BoxDecoration(color: Colors.grey),
              child: Column(
                children: [
                  Text(
                    "Date : 12-01-2026",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bags : 20',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Gloves : 20',
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sm Box : 20',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'carton : 20',
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sap Paper : 20',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Bopp pouch : 20',
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Seal : 20',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Sticker : 20',
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'tissue : 20',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Text(
                    'Expected Cartons : 3',
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
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          height: MediaQuery.of(context).size.height * 1.21,
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
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 16),

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
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width ,
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
        ),
      ),
    );
  }
}
