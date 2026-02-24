// import 'package:flutter/material.dart';

// class LabourPersonDetail extends StatefulWidget {
//   const LabourPersonDetail({super.key});

//   @override
//   State<LabourPersonDetail> createState() => _LabourPersonDetailState();
// }

// class _LabourPersonDetailState extends State<LabourPersonDetail> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(child:SingleChildScrollView(
//         child: Column(
//           children: [

//           ],
//         ),
//       )),
//     );
//   }

// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urine_bag/commons/addButton.dart';

class Labourpersondetail extends StatefulWidget {
  const Labourpersondetail({super.key, required this.personName, required this.category});
  final String personName;
  final String category;

  @override
  State<Labourpersondetail> createState() => _LabourpersondetailState();
}

class _LabourpersondetailState extends State<Labourpersondetail> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
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
                        "Add Labour",
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
                        controller: _amountController,
                        decoration: InputDecoration(
                          labelText: "Amount",
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
                              _amountController.text.isEmpty) {
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
                          final amount = int.tryParse(_amountController.text);

                          if (quantity == null || amount == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Enter valid numbers"),
                              ),
                            );
                            return;
                          }

                          _addLabourDetail(
                            widget.personName,
                            _dateController.text,
                            quantity,
                            _itemController.text,
                            amount,
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
                      .collection("Labour Person")
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
                          'Address : ${supplier['Address']}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Phone No : ${supplier['Phone']}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    );
                  },
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Labour Person")
                    .doc(widget.personName)
                    .collection("Ledger")
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
                                          ? (ds['amount'] / ds['quantity'])
                                                .toStringAsFixed(2)
                                          : "0",
                                    ),
                                  ],
                                ),
                                Text(
                                  'Amount: ${ds['amount']}',
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

  void _addLabourDetail(
    String person,
    String date,
    int quantity,
    String item,
    int amount,
    BuildContext context,
  ) async {
    await FirebaseFirestore.instance
        .collection("Labour Person")
        .doc(widget.personName)
        .collection("Ledger")
        .doc()
        .set({
          "date": date,
          "quantity": quantity,
          "item": item,
          "amount": amount,
          "createdAt": FieldValue.serverTimestamp(),
        });
    FirebaseFirestore.instance
        .collection("Extras")
        .doc(widget.category)
        .update({
          "Total Amount": FieldValue.increment(amount),
          "Total Pieces": FieldValue.increment(quantity),
        })
        .then((value) => Navigator.pop(context));
  }
}
