import 'package:flutter/material.dart';
import 'package:urine_bag/commons/addButton.dart';

class PackagerRecievedView extends StatelessWidget {
  const PackagerRecievedView({super.key});

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
                      icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
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
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 5),
              width: MediaQuery.of(context).size.width,
              //height: 100,
              decoration: BoxDecoration(color: Colors.grey),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 150,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,

                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: Center(
                      child: Text(
                        'Recieved',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Carton : 2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Boxes : 96',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Peices : 280',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Paid",
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
                                "Edit Recieved ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
            
                              const SizedBox(height: 16),
            
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
