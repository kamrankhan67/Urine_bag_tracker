// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:urine_bag/commons/addButton.dart';

// // // class Notebook extends StatelessWidget {
// // //   const Notebook({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     TextEditingController _dateController = TextEditingController();
// // //     TextEditingController _nameController = TextEditingController();
// // //     TextEditingController _itemController = TextEditingController();
// // //     TextEditingController _amountController = TextEditingController();
// // //     TextEditingController _descriptionController = TextEditingController();
// // //     return Scaffold(
// // //       floatingActionButton: FloatingActionButton(
// // //         backgroundColor: Colors.black,
// // //         foregroundColor: Colors.white,
// // //         onPressed: () {
// // //           showModalBottomSheet(
// // //             context: context,
// // //             isScrollControlled: true,
// // //             shape: const RoundedRectangleBorder(
// // //               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// // //             ),
// // //             builder: (context) {
// // //               return SingleChildScrollView(
// // //                 child: Padding(
// // //                   padding: EdgeInsets.only(
// // //                     bottom: MediaQuery.of(context).viewInsets.bottom,
// // //                   ),
// // //                   child: Container(
// // //                     padding: const EdgeInsets.all(16),
// // //                     margin: EdgeInsets.symmetric(horizontal: 20),
// // //                     height: MediaQuery.of(context).size.height * 0.8,
// // //                     child: Column(
// // //                       crossAxisAlignment: CrossAxisAlignment.center,
// // //                       children: [
// // //                         Center(
// // //                           child: Container(
// // //                             width: 40,
// // //                             height: 5,
// // //                             margin: const EdgeInsets.only(bottom: 16),
// // //                             decoration: BoxDecoration(
// // //                               color: Colors.grey[400],
// // //                               borderRadius: BorderRadius.circular(10),
// // //                             ),
// // //                           ),
// // //                         ),

// // //                         const Text(
// // //                           "Add Note",
// // //                           style: TextStyle(
// // //                             fontSize: 18,
// // //                             fontWeight: FontWeight.bold,
// // //                           ),
// // //                         ),

// // //                         const SizedBox(height: 16),

// // //                         TextField(
// // //                           controller: _dateController,
// // //                           decoration: InputDecoration(
// // //                             labelText: "Date",

// // //                             border: OutlineInputBorder(),
// // //                           ),
// // //                         ),

// // //                         const SizedBox(height: 12),

// // //                         TextField(
// // //                           controller: _nameController,
// // //                           decoration: InputDecoration(
// // //                             labelText: "Name",
// // //                             border: OutlineInputBorder(),
// // //                           ),
// // //                           keyboardType: TextInputType.number,
// // //                         ),
// // //                         const SizedBox(height: 12),

// // //                         TextField(
// // //                           controller: _itemController,
// // //                           decoration: InputDecoration(
// // //                             labelText: "Item",
// // //                             border: OutlineInputBorder(),
// // //                           ),
// // //                           keyboardType: TextInputType.number,
// // //                         ),
// // //                         const SizedBox(height: 12),

// // //                         TextField(
// // //                           controller: _amountController,
// // //                           decoration: InputDecoration(
// // //                             labelText: "Amount",
// // //                             border: OutlineInputBorder(),
// // //                           ),
// // //                           keyboardType: TextInputType.number,
// // //                         ),
// // //                         const SizedBox(height: 12),

// // //                         TextField(
// // //                           controller: _descriptionController,
// // //                           decoration: InputDecoration(
// // //                             labelText: "Description",
// // //                             border: OutlineInputBorder(),
// // //                           ),
// // //                           keyboardType: TextInputType.number,
// // //                         ),
// // //                         const SizedBox(height: 12),

// // //                         const Spacer(),

// // //                         AddButton(fn: () => _addNote(_dateController.text,_nameController.text,_itemController.text,_amountController.text,_descriptionController.text)),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ),
// // //               );
// // //             },
// // //           );
// // //         },
// // //         child: const Icon(Icons.add),
// // //       ),
// // //       //floatingActionButton: FloatingActionButton(backgroundColor: Color.fromRGBO(41, 99, 116, 1),onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => AddNoteContainer(),));},child: Icon(Icons.add,color: Colors.white,),),
// // //       backgroundColor: const Color.fromRGBO(232, 226, 219, 1),
// // //       body: SafeArea(
// // //         child: SingleChildScrollView(
// // //           scrollDirection: Axis.vertical,
// // //           physics: BouncingScrollPhysics(),
// // //           child: Column(
// // //             children: [
// // //               Container(
// // //                 padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
// // //                 width: MediaQuery.of(context).size.width,
// // //                 decoration: BoxDecoration(color: Color.fromRGBO(26, 50, 99, 1)),
// // //                 child: Center(
// // //                   child: Row(
// // //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                     children: [
// // //                       IconButton(
// // //                         onPressed: () {
// // //                           Navigator.pop(context);
// // //                         },
// // //                         icon: Icon(
// // //                           Icons.arrow_back_rounded,
// // //                           color: Colors.white,
// // //                         ),
// // //                       ),

// // //                       Text(
// // //                         'Daily NoteBook',
// // //                         style: TextStyle(
// // //                           color: Colors.white,
// // //                           fontWeight: FontWeight.bold,
// // //                           fontSize: 23,
// // //                         ),
// // //                       ),
// // //                       SizedBox(width: MediaQuery.of(context).size.width / 6),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ),
// // //               SingleChildScrollView(
// // //                 scrollDirection: Axis.horizontal,
// // //                 child: Container(
// // //                   width: MediaQuery.of(context).size.width + 100,
// // //                   decoration: BoxDecoration(),
// // //                   child: Table(
// // //                     border: TableBorder.all(color: Colors.black, width: 1),
// // //                     children: [
// // //                       TableRow(
// // //                         children: [
// // //                           Center(
// // //                             child: Text(
// // //                               "Date",
// // //                               style: TextStyle(
// // //                                 fontWeight: FontWeight.bold,
// // //                                 color: const Color.fromARGB(255, 0, 0, 0),
// // //                               ),
// // //                             ),
// // //                           ),
// // //                           Center(
// // //                             child: Text(
// // //                               "Name",
// // //                               style: TextStyle(
// // //                                 fontWeight: FontWeight.bold,
// // //                                 color: const Color.fromARGB(255, 0, 0, 0),
// // //                               ),
// // //                             ),
// // //                           ),
// // //                           Center(
// // //                             child: Text(
// // //                               "Item",
// // //                               style: TextStyle(
// // //                                 fontWeight: FontWeight.bold,
// // //                                 color: const Color.fromARGB(255, 0, 0, 0),
// // //                               ),
// // //                             ),
// // //                           ),
// // //                           Center(
// // //                             child: Text(
// // //                               "Amount",
// // //                               style: TextStyle(
// // //                                 fontWeight: FontWeight.bold,
// // //                                 color: const Color.fromARGB(255, 0, 0, 0),
// // //                               ),
// // //                             ),
// // //                           ),
// // //                           Center(
// // //                             child: Text(
// // //                               "Description",
// // //                               style: TextStyle(
// // //                                 fontWeight: FontWeight.bold,
// // //                                 color: const Color.fromARGB(255, 0, 0, 0),
// // //                               ),
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),]

                      
// // //                       StreamBuilder(stream: FirebaseFirestore.instance.collection("Note").snapshots(), builder: (){
// // //                         if (snapshot.connectionState == ConnectionState.waiting) {
// // //             return Center(child: CircularProgressIndicator(color: Colors.lightBlue));
// // //           } else if (snapshot.hasError) {
// // //             return Center(child: Text("Error loading Inventories"));
// // //           } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
// // //             return Center(child: Text("No Inventory found"));
// // //           }
// // //           return TableRow(
// // //                         children: [
// // //                           Center(
// // //                             child: Text(
// // //                               "12-01-2026",
// // //                               style: TextStyle(
// // //                                 color: const Color.fromARGB(255, 0, 0, 0),
// // //                               ),
// // //                             ),
// // //                           ),
// // //                           Center(
// // //                             child: Text(
// // //                               "Abubakar",
// // //                               style: TextStyle(
// // //                                 color: const Color.fromARGB(255, 0, 0, 0),
// // //                               ),
// // //                             ),
// // //                           ),
// // //                           Center(
// // //                             child: Text(
// // //                               "Roti",
// // //                               style: TextStyle(
// // //                                 color: const Color.fromARGB(255, 0, 0, 0),
// // //                               ),
// // //                             ),
// // //                           ),
// // //                           Center(
// // //                             child: Text(
// // //                               "300",
// // //                               style: TextStyle(
// // //                                 color: const Color.fromARGB(255, 0, 0, 0),
// // //                               ),
// // //                             ),
// // //                           ),
// // //                           Center(
// // //                             child: Text(
// // //                               "manzoor ko roti k paise diye",
// // //                               style: TextStyle(
// // //                                 color: const Color.fromARGB(255, 0, 0, 0),
// // //                               ),
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                       })
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   void _addNote(String name,String date,String item,String amount,String des) async {
// // //    await FirebaseFirestore.instance.collection("Note").doc().set({
// // //       "Date":date,
// // //       "Name":name,
// // //       "Item":item,
// // //       "Amount":amount,
// // //       "Description":des,
// // //     });
// // //   }
// // // }

// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:urine_bag/commons/addButton.dart';

// // class Notebook extends StatelessWidget {
// //   const Notebook({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     TextEditingController _dateController = TextEditingController();
// //     TextEditingController _nameController = TextEditingController();
// //     TextEditingController _itemController = TextEditingController();
// //     TextEditingController _amountController = TextEditingController();
// //     TextEditingController _descriptionController = TextEditingController();

// //     return Scaffold(
// //       floatingActionButton: FloatingActionButton(
// //         backgroundColor: Colors.black,
// //         foregroundColor: Colors.white,
// //         onPressed: () {
// //           showModalBottomSheet(
// //             context: context,
// //             isScrollControlled: true,
// //             shape: const RoundedRectangleBorder(
// //               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// //             ),
// //             builder: (context) {
// //               return SingleChildScrollView(
// //                 child: Padding(
// //                   padding: EdgeInsets.only(
// //                     bottom: MediaQuery.of(context).viewInsets.bottom,
// //                   ),
// //                   child: Container(
// //                     padding: const EdgeInsets.all(16),
// //                     margin: EdgeInsets.symmetric(horizontal: 20),
// //                     height: MediaQuery.of(context).size.height * 0.8,
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.center,
// //                       children: [
// //                         Center(
// //                           child: Container(
// //                             width: 40,
// //                             height: 5,
// //                             margin: const EdgeInsets.only(bottom: 16),
// //                             decoration: BoxDecoration(
// //                               color: Colors.grey[400],
// //                               borderRadius: BorderRadius.circular(10),
// //                             ),
// //                           ),
// //                         ),
// //                         const Text(
// //                           "Add Note",
// //                           style: TextStyle(
// //                             fontSize: 18,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 16),
// //                         TextField(
// //                           controller: _dateController,
// //                           decoration: InputDecoration(
// //                             labelText: "Date",
// //                             border: OutlineInputBorder(),
// //                           ),
// //                         ),
// //                         const SizedBox(height: 12),
// //                         TextField(
// //                           controller: _nameController,
// //                           decoration: InputDecoration(
// //                             labelText: "Name",
// //                             border: OutlineInputBorder(),
// //                           ),
// //                           keyboardType: TextInputType.text,
// //                         ),
// //                         const SizedBox(height: 12),
// //                         TextField(
// //                           controller: _itemController,
// //                           decoration: InputDecoration(
// //                             labelText: "Item",
// //                             border: OutlineInputBorder(),
// //                           ),
// //                           keyboardType: TextInputType.text,
// //                         ),
// //                         const SizedBox(height: 12),
// //                         TextField(
// //                           controller: _amountController,
// //                           decoration: InputDecoration(
// //                             labelText: "Amount",
// //                             border: OutlineInputBorder(),
// //                           ),
// //                           keyboardType: TextInputType.number,
// //                         ),
// //                         const SizedBox(height: 12),
// //                         TextField(
// //                           controller: _descriptionController,
// //                           decoration: InputDecoration(
// //                             labelText: "Description",
// //                             border: OutlineInputBorder(),
// //                           ),
// //                           keyboardType: TextInputType.text,
// //                         ),
// //                         const SizedBox(height: 12),
// //                         const Spacer(),
// //                         AddButton(
// //                           fn: () {
// //                             _addNote(
// //                               _dateController.text,
// //                               _nameController.text,
// //                               _itemController.text,
// //                               _amountController.text,
// //                               _descriptionController.text,
// //                             );
// //                             Navigator.pop(context);  // Close the modal after adding note
// //                           },
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               );
// //             },
// //           );
// //         },
// //         child: const Icon(Icons.add),
// //       ),
// //       backgroundColor: const Color.fromRGBO(232, 226, 219, 1),
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           scrollDirection: Axis.vertical,
// //           physics: BouncingScrollPhysics(),
// //           child: Column(
// //             children: [
// //               Container(
// //                 padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
// //                 width: MediaQuery.of(context).size.width,
// //                 decoration: BoxDecoration(color: Color.fromRGBO(26, 50, 99, 1)),
// //                 child: Center(
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       IconButton(
// //                         onPressed: () {
// //                           Navigator.pop(context);
// //                         },
// //                         icon: Icon(
// //                           Icons.arrow_back_rounded,
// //                           color: Colors.white,
// //                         ),
// //                       ),
// //                       Text(
// //                         'Daily NoteBook',
// //                         style: TextStyle(
// //                           color: Colors.white,
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 23,
// //                         ),
// //                       ),
// //                       SizedBox(width: MediaQuery.of(context).size.width / 6),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               SingleChildScrollView(
// //                 scrollDirection: Axis.horizontal,
// //                 child: Container(
// //                   width: MediaQuery.of(context).size.width + 100,
// //                   decoration: BoxDecoration(),
// //                   child: Table(
// //                     border: TableBorder.all(color: Colors.black, width: 1),
// //                     children: [
// //                       TableRow(
// //                         children: [
// //                           Center(
// //                             child: Text(
// //                               "Date",
// //                               style: TextStyle(
// //                                 fontWeight: FontWeight.bold,
// //                                 color: Colors.black,
// //                               ),
// //                             ),
// //                           ),
// //                           Center(
// //                             child: Text(
// //                               "Name",
// //                               style: TextStyle(
// //                                 fontWeight: FontWeight.bold,
// //                                 color: Colors.black,
// //                               ),
// //                             ),
// //                           ),
// //                           Center(
// //                             child: Text(
// //                               "Item",
// //                               style: TextStyle(
// //                                 fontWeight: FontWeight.bold,
// //                                 color: Colors.black,
// //                               ),
// //                             ),
// //                           ),
// //                           Center(
// //                             child: Text(
// //                               "Amount",
// //                               style: TextStyle(
// //                                 fontWeight: FontWeight.bold,
// //                                 color: Colors.black,
// //                               ),
// //                             ),
// //                           ),
// //                           Center(
// //                             child: Text(
// //                               "Description",
// //                               style: TextStyle(
// //                                 fontWeight: FontWeight.bold,
// //                                 color: Colors.black,
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       StreamBuilder<QuerySnapshot>(
// //                         stream: FirebaseFirestore.instance
// //                             .collection("Note")
// //                             .snapshots(),
// //                         builder: (context, snapshot) {
// //                           if (snapshot.connectionState == ConnectionState.waiting) {
// //                             return Center(
// //                                 child: CircularProgressIndicator(color: Colors.lightBlue));
// //                           } else if (snapshot.hasError) {
// //                             return Center(child: Text("Error loading notes"));
// //                           } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
// //                             return Center(child: Text("No Notes found"));
// //                           }
// //                           return Column(
// //                             children: snapshot.data!.docs.map((doc) {
// //                               return TableRow(
// //                                 children: [
// //                                   Center(child: Text(doc['Date'])),
// //                                   Center(child: Text(doc['Name'])),
// //                                   Center(child: Text(doc['Item'])),
// //                                   Center(child: Text(doc['Amount'].toString())),
// //                                   Center(child: Text(doc['Description'])),
// //                                 ],
// //                               );
// //                             }).toList(),
// //                           );
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   void _addNote(String date, String name, String item, String amount, String description) async {
// //     await FirebaseFirestore.instance.collection("Note").add({
// //       "Date": date,
// //       "Name": name,
// //       "Item": item,
// //       "Amount": amount,
// //       "Description": description,
// //     });
// //   }
// // }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:urine_bag/commons/addButton.dart';

// class Notebook extends StatelessWidget {
//   const Notebook({super.key});

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController _dateController = TextEditingController();
//     TextEditingController _nameController = TextEditingController();
//     TextEditingController _itemController = TextEditingController();
//     TextEditingController _amountController = TextEditingController();
//     TextEditingController _descriptionController = TextEditingController();

//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.black,
//         foregroundColor: Colors.white,
//         onPressed: () {
//           showModalBottomSheet(
//             context: context,
//             isScrollControlled: true,
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             builder: (context) {
//               return SingleChildScrollView(
//                 child: Padding(
//                   padding: EdgeInsets.only(
//                     bottom: MediaQuery.of(context).viewInsets.bottom,
//                   ),
//                   child: Container(
//                     padding: const EdgeInsets.all(16),
//                     margin: EdgeInsets.symmetric(horizontal: 20),
//                     height: MediaQuery.of(context).size.height * 0.8,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Center(
//                           child: Container(
//                             width: 40,
//                             height: 5,
//                             margin: const EdgeInsets.only(bottom: 16),
//                             decoration: BoxDecoration(
//                               color: Colors.grey[400],
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                         const Text(
//                           "Add Note",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         TextField(
//                           controller: _dateController,
//                           decoration: InputDecoration(
//                             labelText: "Date",
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         TextField(
//                           controller: _nameController,
//                           decoration: InputDecoration(
//                             labelText: "Name",
//                             border: OutlineInputBorder(),
//                           ),
//                           keyboardType: TextInputType.text,
//                         ),
//                         const SizedBox(height: 12),
//                         TextField(
//                           controller: _itemController,
//                           decoration: InputDecoration(
//                             labelText: "Item",
//                             border: OutlineInputBorder(),
//                           ),
//                           keyboardType: TextInputType.text,
//                         ),
//                         const SizedBox(height: 12),
//                         TextField(
//                           controller: _amountController,
//                           decoration: InputDecoration(
//                             labelText: "Amount",
//                             border: OutlineInputBorder(),
//                           ),
//                           keyboardType: TextInputType.number,
//                         ),
//                         const SizedBox(height: 12),
//                         TextField(
//                           controller: _descriptionController,
//                           decoration: InputDecoration(
//                             labelText: "Description",
//                             border: OutlineInputBorder(),
//                           ),
//                           keyboardType: TextInputType.text,
//                         ),
//                         const SizedBox(height: 12),
//                         const Spacer(),
//                         AddButton(
//                           fn: () {
//                             _addNote(
//                               _dateController.text,
//                               _nameController.text,
//                               _itemController.text,
//                               _amountController.text,
//                               _descriptionController.text,
//                             );
//                             Navigator.pop(context);  // Close the modal after adding note
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//       backgroundColor: const Color.fromRGBO(232, 226, 219, 1),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           physics: BouncingScrollPhysics(),
//           child: Column(
//             children: [
//               Container(
//                 padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(color: Color.fromRGBO(26, 50, 99, 1)),
//                 child: Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         icon: Icon(
//                           Icons.arrow_back_rounded,
//                           color: Colors.white,
//                         ),
//                       ),
//                       Text(
//                         'Daily NoteBook',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 23,
//                         ),
//                       ),
//                       SizedBox(width: MediaQuery.of(context).size.width / 6),
//                     ],
//                   ),
//                 ),
//               ),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Container(
//                   width: MediaQuery.of(context).size.width + 100,
//                   decoration: BoxDecoration(),
//                   child: Table(
//                     border: TableBorder.all(color: Colors.black, width: 1),
//                     children: [
//                       TableRow(
//                         children: [
//                           Center(
//                             child: Text(
//                               "Date",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                           Center(
//                             child: Text(
//                               "Name",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                           Center(
//                             child: Text(
//                               "Item",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                           Center(
//                             child: Text(
//                               "Amount",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                           Center(
//                             child: Text(
//                               "Description",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       StreamBuilder<QuerySnapshot>(
//                         stream: FirebaseFirestore.instance
//                             .collection("Note")
//                             .snapshots(),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState == ConnectionState.waiting) {
//                             return Center(
//                                 child: CircularProgressIndicator(color: Colors.lightBlue));
//                           } else if (snapshot.hasError) {
//                             return Center(child: Text("Error loading notes"));
//                           } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                             return Center(child: Text("No Notes found"));
//                           }

//                           // Here we map the Firestore data into TableRows dynamically
//                           return Column(
//                             children: snapshot.data!.docs.map((doc) {
//                               return TableRow(
//                                 children: [
//                                   Center(child: Text(doc['Date'] ?? '')),
//                                   Center(child: Text(doc['Name'] ?? '')),
//                                   Center(child: Text(doc['Item'] ?? '')),
//                                   Center(child: Text(doc['Amount'].toString() ?? '')),
//                                   Center(child: Text(doc['Description'] ?? '')),
//                                 ],
//                               );
//                             }).toList(),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _addNote(String date, String name, String item, String amount, String description) async {
//     await FirebaseFirestore.instance.collection("Note").add({
//       "Date": date,
//       "Name": name,
//       "Item": item,
//       "Amount": amount,
//       "Description": description,
//     });
//   }
// }


