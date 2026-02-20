import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urine_bag/commons/addButton.dart';

class SupplierPersonDetail extends StatefulWidget {
  const SupplierPersonDetail({
    super.key,
    required this.personName,
    required this.supplyItem,
  });
  final String personName;
  final String supplyItem;

  @override
  State<SupplierPersonDetail> createState() => _SupplierPersonDetailState();
}

class _SupplierPersonDetailState extends State<SupplierPersonDetail> {
  final TextEditingController _balController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void dispose() {
    _balController.dispose();
    _itemController.dispose();
    _dateController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      // TextField(
                      //   controller: _dateController,
                      //   decoration: InputDecoration(
                      //     labelText: "Date",
                      //     border: OutlineInputBorder(),
                      //   ),
                      //   keyboardType: TextInputType.datetime,
                      // ),
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
                        fn: () {
                          if (_dateController.text.isEmpty ||
                              _quantityController.text.isEmpty ||
                              _itemController.text.isEmpty ||
                              _balController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill all fields"),
                              ),
                            );
                            return;
                          }

                          final quantity = int.tryParse(
                            _quantityController.text,
                          );
                          final balance = int.tryParse(_balController.text);

                          if (quantity == null || balance == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Enter valid numbers"),
                              ),
                            );
                            return;
                          }

                          _addSupplyDetail(
                            widget.personName,
                            _dateController.text,
                            quantity,
                            _itemController.text,
                            balance,
                            context,
                          );
                        },
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
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("SuplierDetail")
                      .doc(widget.personName)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error loading supplier info"),
                      );
                    } else if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Center(child: Text("Supplier not found"));
                    }

                    var supplier = snapshot.data!;
                    return Column(
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
                                supplier.id,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 6,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Location : ${supplier['location']}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Phone No : ${supplier['phone']}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    );
                  },
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("SuplierDetail")
                    .doc(widget.personName)
                    .collection("Bills")
                    .snapshots(),
                builder:
                    (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blueAccent,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text("Error loading Supplier Detail"),
                        );
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("No Purchase found"));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data!.docs[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  'Date : ${ds['date']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text('Quantity '),
                                    Spacer(),
                                    Text(ds['quantity'].toString()),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Item '),
                                    Spacer(),
                                    Text(ds['item']),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Per Piece Price '),
                                    Spacer(),
                                    Text(
                                      ds['quantity'] != 0
                                          ? (ds['balance'] / ds['quantity'])
                                                .toStringAsFixed(2)
                                          : "0",
                                    ),
                                  ],
                                ),
                                Text(
                                  'Balance: ${ds['balance']}',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
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

  void _addSupplyDetail(
    String person,
    String date,
    int quantity,
    String item,
    int bal,
    BuildContext context,
  ) async {
    await FirebaseFirestore.instance
        .collection("SuplierDetail")
        .doc(widget.personName)
        .collection("Bills")
        .doc()
        .set({
          "date": date,
          "quantity": quantity,
          "item": item,
          "balance": bal,
        });

    await FirebaseFirestore.instance
        .collection("Inventory")
        .doc(widget.supplyItem)
        .collection("Ledger")
        .doc()
        .set({
          "Date": date,
          "Quantity": "+$quantity",
          "Color": "Green",
          "Description": person,
        });
    await FirebaseFirestore.instance
        .collection("Inventory")
        .doc(widget.supplyItem)
        .update({
          "quantity": FieldValue.increment(quantity),
          "total quantity": FieldValue.increment(quantity),
          "total value": FieldValue.increment(bal),
        })
        .then((value) => Navigator.pop(context));
  }
}
