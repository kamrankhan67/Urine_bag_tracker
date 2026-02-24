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
//                       // StreamBuilder<QuerySnapshot>(
//                       //   stream: FirebaseFirestore.instance
//                       //       .collection("Note")
//                       //       .snapshots(),
//                       //   builder: (context, snapshot) {
//                       //     if (snapshot.connectionState == ConnectionState.waiting) {
//                       //       return Center(
//                       //           child: CircularProgressIndicator(color: Colors.lightBlue));
//                       //     } else if (snapshot.hasError) {
//                       //       return Center(child: Text("Error loading notes"));
//                       //     } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       //       return Center(child: Text("No Notes found"));
//                       //     }

//                       //     // Here we map the Firestore data into TableRows dynamically
//                       //     return Column(
//                       //       children: snapshot.data!.docs.map((doc) {
//                       //         return TableRow(
//                       //           children: [
//                       //             Center(child: Text(doc['Date'] ?? '')),
//                       //             Center(child: Text(doc['Name'] ?? '')),
//                       //             Center(child: Text(doc['Item'] ?? '')),
//                       //             Center(child: Text(doc['Amount'].toString() ?? '')),
//                       //             Center(child: Text(doc['Description'] ?? '')),
//                       //           ],
//                       //         );
//                       //       }).toList(),
//                       //     );
//                       //   },
//                       // ),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urine_bag/commons/addButton.dart';

class Notebook extends StatefulWidget {
  const Notebook({super.key});

  @override
  State<Notebook> createState() => _NotebookState();
}

class _NotebookState extends State<Notebook> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _nameController.dispose();
    _itemController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addNote() async {
    if (_dateController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _itemController.text.isEmpty ||
        _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection("Note")
          .add({
            "Date": _dateController.text,
            "Name": _nameController.text,
            "Item": _itemController.text,
            "Amount": int.tryParse(_amountController.text) ?? 0,
            "Description": _descriptionController.text,
            "Timestamp": FieldValue.serverTimestamp(),
          })
          .then((e) => Navigator.pop(context));

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Note added successfully")));

      // Clear the controllers
      _dateController.clear();
      _nameController.clear();
      _itemController.clear();
      _amountController.clear();
      _descriptionController.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(232, 226, 219, 1),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromRGBO(26, 50, 99, 1),
        title: const Text(
          'Daily Notebook',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () => _showAddNoteSheet(),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Note")
              .orderBy("Timestamp", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Error loading notes"));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No notes found"));
            }

            final notes = snapshot.data!.docs;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: MediaQuery.of(context).size.width + 150,
                padding: const EdgeInsets.all(12),
                child: Table(
                  border: TableBorder.all(color: Colors.black, width: 1),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Center(
                            child: Text(
                              "Date",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Center(
                            child: Text(
                              "Name",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Center(
                            child: Text(
                              "Item",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Center(
                            child: Text(
                              "Amount",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Center(
                            child: Text(
                              "Description",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...notes.map((doc) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text(doc['Date'] ?? '')),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text(doc['Name'] ?? '')),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text(doc['Item'] ?? '')),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(doc['Amount'].toString()),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(doc['Description'] ?? ''),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddNoteSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Add Note",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Date",
                      border: OutlineInputBorder(),
                    ),
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(
                      labelText: "Item",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Amount",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AddButton(fn: _addNote),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
