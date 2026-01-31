import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 200),
          Center(child: Image.asset('assets/images/logo_png.png')),
          Text(
            "Munir And Son's",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 250),
          Text("Developed by Kamran Shahid", style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
