// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class InventoryDetail extends StatelessWidget {
//   const InventoryDetail({super.key, required this.item});
//   final DocumentSnapshot<Object?> item;

//   @override
//   Widget build(BuildContext context) {
//     Color getRowColor(String color) {
//       switch (color) {
//         case "Green":
//           return Colors.green;
//         case "Red":
//           return Colors.red;
//         default:
//           return Colors.grey;
//       }
//     }

//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(232, 226, 219, 1),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           child: Column(
//             children: [
//               Container(
//                 height: 70,
//                 padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   color: Color.fromRGBO(26, 50, 99, 1),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(10),
//                     bottomRight: Radius.circular(10),
//                   ),
//                 ),
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
//                         item.id,
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
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _inventoryDetailContainer(
//                     "Total Qty",
//                     item['total quantity'].toString(),
//                     Color.fromRGBO(26, 50, 99, 1),
//                     context,
//                   ),
//                   _inventoryDetailContainer(
//                     "Total Value",
//                     item["total value"].toString(),
//                     const Color.fromRGBO(84, 119, 146, 1),
//                     context,
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 30),
//                 margin: EdgeInsets.only(top: 10, right: 20, left: 20),
//                 width: double.infinity,
//                 height: 70,
//                 decoration: BoxDecoration(
//                   //color: const Color.fromARGB(255, 16, 70, 91),
//                   color: Colors.black,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Stock',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 22
//                       ),
//                     ),
//                     Spacer(),
//                     Text(
//                       item["quantity"].toString(),
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 22
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Container(
//               //   padding: EdgeInsets.symmetric(horizontal: 30),
//               //   margin: EdgeInsets.only(top: 10, right: 20, left: 20),
//               //   width: double.infinity,
//               //   height: 50,
//               //   decoration: BoxDecoration(
//               //     color: Colors.black,
//               //     borderRadius: BorderRadius.circular(10),
//               //   ),
//               //   child: Row(
//               //     mainAxisAlignment: MainAxisAlignment.center,
//               //     children: [
//               //       Text(
//               //         'Expected Carttons',
//               //         style: TextStyle(
//               //           color: Colors.white,
//               //           fontWeight: FontWeight.bold,
//               //         ),
//               //       ),
//               //       Spacer(),
//               //       Text(
//               //         item["expected cartton"].toString(),
//               //         style: TextStyle(
//               //           color: Colors.white,
//               //           fontWeight: FontWeight.bold,
//               //         ),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 child: Table(
//                   border: TableBorder.all(width: 1),
//                   children: [
//                     TableRow(
//                       decoration: BoxDecoration(color: Colors.grey),
//                       children: [
//                         Center(
//                           child: Text(
//                             'Date',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Center(
//                           child: Text(
//                             'Quantity',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Center(
//                           child: Text(
//                             'Description',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection("Inventory")
//                     .doc(item.id)
//                     .collection("Ledger")
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(
//                       child: CircularProgressIndicator(color: Colors.lightBlue),
//                     );
//                   }
//                   if (snapshot.hasError) {
//                     return const Center(child: Text("Error loading records"));
//                   }
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return const Center(child: Text("No Record found"));
//                   }

//                   return ListView.builder(
//                     physics: const NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: snapshot.data!.docs.length,
//                     itemBuilder: (context, index) {
//                       final ds = snapshot.data!.docs[index];
//                       final Color rowColor = getRowColor(ds["Color"]);

//                       return Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                         child: Table(
//                           border: TableBorder.all(width: 1),
//                           children: [
//                             TableRow(
//                               decoration: BoxDecoration(color: rowColor),
//                               children: [
//                                 Center(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(
//                                       "${ds["Date"]}",
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Center(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(
//                                       "${ds["Quantity"]}",
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Center(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(
//                                       "${ds["Description"]}",
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _inventoryDetailContainer(
//     String text,
//     String cartons,
//     Color color,
//     BuildContext context,
//   ) {
//     return Container(
//       decoration: BoxDecoration(
//         color: color,

//         borderRadius: BorderRadius.circular(15),
//       ),
//       width: MediaQuery.of(context).size.width / 2.3,
//       padding: EdgeInsets.all(20),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             text,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 10),
//           Text(
//             ' $cartons',
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InventoryDetail extends StatelessWidget {
  const InventoryDetail({super.key, required this.item});
  final DocumentSnapshot item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = item.data() as Map<String, dynamic>? ?? {};

    Color getStatusColor(String? color) {
      switch (color) {
        case "Green":
          return const Color(0xFF43A047);
        case "Red":
          return const Color(0xFFE53935);
        default:
          return Colors.grey[600]!;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(item.id),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            
            /// 🔹 KEY METRICS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _metricCard(
                      label: "Total Qty",
                      value: data['total quantity']?.toString() ?? "0",
                      icon: Icons.unarchive_outlined,
                      color: theme.colorScheme.primary,
                      theme: theme,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _metricCard(
                      label: "Total Value",
                      value: "Rs ${data['total value']?.toString() ?? "0"}",
                      icon: Icons.payments_outlined,
                      color: theme.colorScheme.secondary,
                      theme: theme,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// 🔹 CURRENT STOCK CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Current Stock",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data["quantity"]?.toString() ?? "0",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.inventory_rounded,
                      color: Colors.white.withOpacity(0.2),
                      size: 64,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            /// 🔹 LEDGER SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text("Inventory Ledger", style: theme.textTheme.titleLarge),
                  const Spacer(),
                  Icon(Icons.history_rounded, color: theme.colorScheme.primary),
                ],
              ),
            ),
            const SizedBox(height: 16),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Inventory")
                  .doc(item.id)
                  .collection("Ledger")
                  .orderBy("Timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(Icons.notes_rounded, size: 48, color: Colors.grey[300]),
                          const SizedBox(height: 12),
                          const Text("No transactions recorded", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final ds = snapshot.data!.docs[index];
                    final ledger = ds.data() as Map<String, dynamic>? ?? {};
                    final statusColor = getStatusColor(ledger["Color"]);

                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey[200]!),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            ledger["Color"] == "Red" ? Icons.remove_circle_outline : Icons.add_circle_outline,
                            color: statusColor,
                          ),
                        ),
                        title: Text(
                          ledger["Description"]?.toString() ?? "Transaction",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(ledger["Date"]?.toString() ?? ""),
                        trailing: Text(
                          "${ledger["Quantity"] > 0 ? '+' : ''}${ledger["Quantity"]}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _metricCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
