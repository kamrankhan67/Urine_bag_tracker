// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:urine_bag/commons/addButton.dart';
// import 'package:urine_bag/pages/packager/PackagerDetail.dart';

// class Packager extends StatefulWidget {
//   const Packager({super.key});

//   @override
//   State<Packager> createState() => _PackagerState();
// }

// class _PackagerState extends State<Packager> {
//   TextEditingController _nameController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(232, 226, 219, 1),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Container(
//               height: 70,
//               padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 color: Color.fromRGBO(26, 50, 99, 1),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(10),
//                   bottomRight: Radius.circular(10),
//                 ),
//               ),
//               child: Center(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
//                     ),

//                     Text(
//                       'Packaging',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 23,
//                       ),
//                     ),
//                     SizedBox(width: MediaQuery.of(context).size.width / 6),
//                   ],
//                 ),
//               ),
//             ),

//             StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection("Packaging")
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(
//                     child: CircularProgressIndicator(color: Colors.lightBlue),
//                   );
//                 }
//                 if (snapshot.hasError) {
//                   return const Center(child: Text("Error loading records"));
//                 }
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text("No Record found"));
//                 }

//                 return ListView.builder(
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) {
//                     final ds = snapshot.data!.docs[index];

//                     return Padding(
//                       padding: EdgeInsetsGeometry.symmetric(
//                         horizontal: 20,
//                         vertical: 10,
//                       ),
//                       child: _PackagingContainer(context, ds.id, () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 PackagerDetail(packagerData: ds),
//                           ),
//                         );
//                       }),
//                     );
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
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
//               return Padding(
//                 padding: EdgeInsets.only(
//                   bottom: MediaQuery.of(context).viewInsets.bottom,
//                 ),
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   margin: EdgeInsets.symmetric(horizontal: 20),
//                   height: MediaQuery.of(context).size.height * 0.4,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Center(
//                         child: Container(
//                           width: 40,
//                           height: 5,
//                           margin: const EdgeInsets.only(bottom: 16),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[400],
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),

//                       const Text(
//                         "Add Packager",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),

//                       const SizedBox(height: 16),

//                       TextField(
//                         controller: _nameController,
//                         decoration: InputDecoration(
//                           labelText: "Name",
//                           border: OutlineInputBorder(),
//                         ),
//                       ),

//                       const Spacer(),
//                       AddButton(fn: () => _addpackager(_nameController.text)),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   Widget _PackagingContainer(
//     BuildContext context,
//     String text,
//     VoidCallback onTap,
//   ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: const Color.fromRGBO(84, 119, 146, 1),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         height: 60,
//         width: MediaQuery.of(context).size.width,
//         child: Center(
//           child: Text(
//             text,
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 23,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _addpackager(String name) async {
//     await FirebaseFirestore.instance.collection("Packaging").doc(name).set({
//       "Received Carton":0,
//       "Boxes":0,
//       "Pieces":0,
//       "Expected Carton":0,
//     });
//     Navigator.pop(context);
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urine_bag/commons/addButton.dart';
import 'package:urine_bag/pages/packager/PackagerDetail.dart';

class Packager extends StatefulWidget {
  const Packager({super.key});

  @override
  State<Packager> createState() => _PackagerState();
}

class _PackagerState extends State<Packager> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(232, 226, 219, 1),
      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 HEADER
            _buildHeader(),

            /// 🔹 LIST
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Packaging")
                    .orderBy(FieldPath.documentId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.lightBlue,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                        child: Text("Error loading records"));
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text("No Record found"));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final ds = snapshot.data!.docs[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: _packagingContainer(
                          context,
                          ds.id,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PackagerDetail(
                                  packagerData: ds,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      /// 🔹 ADD BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: _showAddSheet,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// 🔹 HEADER
  Widget _buildHeader() {
    return Container(
      height: 70,
      padding: const EdgeInsets.only(left: 20),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(26, 50, 99, 1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded,
                color: Colors.white),
          ),
          const Text(
            'Packaging',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 23,
            ),
          ),
          const SizedBox(width: 50),
        ],
      ),
    );
  }

  /// 🔹 PACKAGER TILE
  Widget _packagingContainer(
    BuildContext context,
    String text,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(84, 119, 146, 1),
          borderRadius: BorderRadius.circular(20),
        ),
        height: 60,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 23,
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 SHOW BOTTOM SHEET
  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            margin:
                const EdgeInsets.symmetric(horizontal: 20),
            height:
                MediaQuery.of(context).size.height * 0.4,
            child: Column(
              children: [
                const Text(
                  "Add Packager",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const Spacer(),
                _isLoading
                    ? const CircularProgressIndicator()
                    : AddButton(
                        fn: () =>
                            _addPackager(_nameController.text),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 🔹 SECURE ADD METHOD
  Future<void> _addPackager(String name) async {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      _showSnack("Name cannot be empty");
      return;
    }

    if (trimmedName.length < 3) {
      _showSnack("Name too short");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final docRef = FirebaseFirestore.instance
          .collection("Packaging")
          .doc(trimmedName);

      final doc = await docRef.get();

      if (doc.exists) {
        _showSnack("Packager already exists");
        setState(() => _isLoading = false);
        return;
      }

      await docRef.set({
        "Received Carton": 0,
        "Boxes": 0,
        "Pieces": 0,
        "Expected Carton": 0,
        "createdAt": FieldValue.serverTimestamp(),
      });

      _nameController.clear();
      Navigator.pop(context);
      _showSnack("Packager added successfully");
    } catch (e) {
      _showSnack("Something went wrong");
    }

    setState(() => _isLoading = false);
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

