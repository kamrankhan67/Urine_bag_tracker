import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urine_bag/commons/addButton.dart';

class SupplierPersonDetail extends StatefulWidget {
  const SupplierPersonDetail({super.key, required this.name});
  final String name;

  @override
  State<SupplierPersonDetail> createState() => _SupplierPersonDetailState();
}

class _SupplierPersonDetailState extends State<SupplierPersonDetail> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _balController = TextEditingController();
    final TextEditingController _itemController = TextEditingController();
    final TextEditingController _dateController = TextEditingController();
    final TextEditingController _quantityController = TextEditingController();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  height: MediaQuery.of(context).size.height * 0.7,
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
                        "Add Supply",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          labelText: "Date",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: _quantityController,
                        decoration: InputDecoration(
                          labelText: "Quantity",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),

                      TextField(
                        controller: _itemController,
                        decoration: InputDecoration(
                          labelText: "Item",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 12),

                      TextField(
                        controller: _balController,
                        decoration: InputDecoration(
                          labelText: "Balance",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),

                      const Spacer(),

                      AddButton(
                        fn: () => _addSupplyDetail(
                          _dateController.text,
                          _quantityController.text,
                          _itemController.text,
                          _balController.text,
                          context,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: const Color.fromRGBO(232, 226, 219, 1),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              //height: 70,
              padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color.fromRGBO(26, 50, 99, 1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  Center(
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
                          'Rasheed',
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
                  Text(
                    'Location : Lahore,Kot abdul malik',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Phone No : 03238967453',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.infinity,

              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Date : 12-02-2026',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(children: [Text('Quantity '), Spacer(), Text('300')]),
                  Row(children: [Text('Item '), Spacer(), Text('Foam')]),
                  Row(
                    children: [Text('Per Peice Price '), Spacer(), Text('5')],
                  ),
                  Text(
                    'Balance : 30,000',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addSupplyDetail(
    String date,
    String quantity,
    String item,
    String bal,
    BuildContext context,
  ) async {
    await FirebaseFirestore.instance
        .collection("Supplier")
        .doc("Foam")
        .collection(widget.name)
        .doc()
        .set({
          "date": date,
          "quantity": quantity,
          "item": item,
          "balance": bal,
        });
    Navigator.pop(context);
  }
}
