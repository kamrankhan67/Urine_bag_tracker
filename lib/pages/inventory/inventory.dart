import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urine_bag/pages/inventory/inventoryDetail.dart';

class Inventory extends StatelessWidget {
  const Inventory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(232, 226, 219, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(26, 50, 99, 1),
        title: Text('          Inventory', style: TextStyle(color: Colors.white,fontSize: 23, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,color: Colors.white,),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Inventory").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.lightBlue));
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading Inventories"));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No Inventory found"));
          }
    
          return GridView.builder(
            padding: EdgeInsets.all(10),
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data!.docs[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InventoryDetail(item:ds), // Pass necessary data if needed
                    ),
                  );
                },
                child: _inventoryContainer(ds.id, context), // Use field name
              );
            },
          );
        },
      ),
      
    );
  }


  Widget _inventoryContainer(String text, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(84, 119, 146, 1),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
