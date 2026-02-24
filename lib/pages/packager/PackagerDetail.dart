

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:urine_bag/pages/packager/packagerDeliverView.dart';
// import 'package:urine_bag/pages/packager/packagerReceivedView.dart';

// class PackagerDetail extends StatefulWidget {
//   const PackagerDetail({super.key, required this.packagerData});
//   final DocumentSnapshot packagerData;

//   @override
//   State<PackagerDetail> createState() => _PackagerDetailState();
// }

// class _PackagerDetailState extends State<PackagerDetail> {
//   @override
//   Widget build(BuildContext context) {
//     Map<String, dynamic> data =
//         widget.packagerData.data() as Map<String, dynamic>;

//     // ✅ Create filtered copy (DO NOT modify original map)
//     Map<String, dynamic> filteredData = Map.from(data);
//     filteredData.remove("Expected Carton");
    
//     filteredData.remove("Received Carton");
//     filteredData.remove("Boxes");
//     filteredData.remove("Pieces");

//     List<String> keys = filteredData.keys.toList();

//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(232, 226, 219, 1),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             children: [
//               /// 🔵 HEADER
//               Container(
//                 height: 70,
//                 padding: const EdgeInsets.only(left: 10),
//                 width: MediaQuery.of(context).size.width,
//                 decoration: const BoxDecoration(
//                   color: Color.fromRGBO(26, 50, 99, 1),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(10),
//                     bottomRight: Radius.circular(10),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       onPressed: () => Navigator.pop(context),
//                       icon: const Icon(
//                         Icons.arrow_back_rounded,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Text(
//                       widget.packagerData.id,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 23,
//                       ),
//                     ),
//                     const SizedBox(width: 50),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 20),

//               /// 🟢 DELIVERED CONTAINER
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 margin: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 10,
//                 ),
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 0, 0, 0),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   children: [
//                     /// Title
//                     const Center(
//                       child: Text(
//                         'Delivered',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 17,
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 15),

//                     /// 🔥 GRID VIEW
//                     GridView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             childAspectRatio: 3.2,
//                             mainAxisSpacing: 8,
//                             crossAxisSpacing: 8,
//                           ),
//                       itemCount: keys.length,
//                       itemBuilder: (context, index) {
//                         String key = keys[index];
//                         String formattedKey = key.replaceAll("_", " ");

//                         return Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                             color: Colors.blueGrey.shade700,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Center(
//                             child: Text(
//                               "$formattedKey : ${filteredData[key] ?? 0}",
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),

//                     const SizedBox(height: 15),

//                     /// ✅ Expected Carton (Shown Once)
//                     Text(
//                       "Expected Cartons : ${data["Expected Carton"] ?? 0}",
//                       style: const TextStyle(
//                         color: Color.fromARGB(255, 255, 255, 255),
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 20,),
//                      GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => PackagerDetailView(packagerName: widget.packagerData.id,)
//                           ),
//                         );
//                       },
//                       child: Container(
//                         height: 45,
//                         decoration: BoxDecoration(
//                           color: Colors.green,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: const Center(
//                           child: Text(
//                             "View Delivered",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 5),

//               /// 🔘 DELIVER VIEW BUTTON
              

//               const SizedBox(height: 15),

//               Container(
//                 padding: const EdgeInsets.all(12),
//                 margin: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 10,
//                 ),
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 0, 0, 0),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   children: [
//                     /// 🔵 Title
//                     const Center(
//                       child: Text(
//                         'Received',
//                         style: TextStyle(
//                           color: Color.fromARGB(255, 255, 255, 255),
//                           fontWeight: FontWeight.bold,
//                           fontSize: 17,
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 15),
//                     widget.packagerData.exists                        ?
                        
//                     // 🔥 STATIC RECEIVED DATA
//                     Builder(
//                       builder: (context) {
//                         Map<String, dynamic> receivedData = {
//                           "Carton": widget.packagerData["Received Carton"] ?? 0,
//                           "Boxes": widget.packagerData["Boxes"] ?? 0,
//                           "Pieces": widget.packagerData["Pieces"] ?? 0,
//                         };

//                         List<String> keys = receivedData.keys.toList();

//                         return GridView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           gridDelegate:
//                               const SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 2,
//                                 childAspectRatio: 3.2,
//                                 mainAxisSpacing: 8,
//                                 crossAxisSpacing: 8,
//                               ),
//                           itemCount: keys.length,
//                           itemBuilder: (context, index) {
//                             String key = keys[index];

//                             return Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.blueGrey.shade700,
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   "$key : ${receivedData[key]}",
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ): const Text(
//                             "No Received Data",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),

//                     const SizedBox(height: 15),

//                     /// 🔘 VIEW BUTTON
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => PackagerRecievedView(
//                               packagerName: widget.packagerData.id,
//                             ),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         height: 45,
//                         decoration: BoxDecoration(
//                           color: Colors.green,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: const Center(
//                           child: Text(
//                             "View Received",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               /// 🔘 RECEIVED VIEW BUTTON
              
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urine_bag/pages/packager/packagerDeliverView.dart';
import 'package:urine_bag/pages/packager/packagerReceivedView.dart';

class PackagerDetail extends StatelessWidget {
  const PackagerDetail({super.key, required this.packagerData});
  final DocumentSnapshot packagerData;

  @override
  Widget build(BuildContext context) {
    final data =
        packagerData.data() as Map<String, dynamic>? ?? {};

    /// 🔹 Create filtered delivered data
    final deliveredData = Map<String, dynamic>.from(data)
      ..remove("Expected Carton")
      ..remove("Received Carton")
      ..remove("Boxes")
      ..remove("Pieces")
      ..remove("createdAt");

    final receivedData = {
      "Carton": data["Received Carton"] ?? 0,
      "Boxes": data["Boxes"] ?? 0,
      "Pieces": data["Pieces"] ?? 0,
    };

    return Scaffold(
      backgroundColor: const Color.fromRGBO(232, 226, 219, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              /// 🔵 HEADER
              _buildHeader(context),

              const SizedBox(height: 20),

              /// 🟢 DELIVERED SECTION
              _buildSectionContainer(
                title: "Delivered",
                child: Column(
                  children: [
                    _buildGrid(deliveredData),
                    const SizedBox(height: 15),
                    Text(
                      "Expected Cartons : ${data["Expected Carton"] ?? 0}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildButton(
                      text: "View Delivered",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PackagerDetailView(
                              packagerName: packagerData.id,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              /// 🔵 RECEIVED SECTION
              _buildSectionContainer(
                title: "Received",
                child: Column(
                  children: [
                    _buildGrid(receivedData),
                    const SizedBox(height: 15),
                    _buildButton(
                      text: "View Received",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PackagerRecievedView(
                              packagerName: packagerData.id,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 HEADER
  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.only(left: 10),
      width: MediaQuery.of(context).size.width,
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
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            ),
          ),
          Text(
            packagerData.id,
            style: const TextStyle(
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

  /// 🔹 SECTION CONTAINER
  Widget _buildSectionContainer({
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  /// 🔹 GRID BUILDER (Reusable)
  Widget _buildGrid(Map<String, dynamic> mapData) {
    final keys = mapData.keys.toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final key = keys[index];
        final formattedKey = key.replaceAll("_", " ");

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade700,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              "$formattedKey : ${mapData[key] ?? 0}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  /// 🔹 BUTTON BUILDER
  Widget _buildButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
