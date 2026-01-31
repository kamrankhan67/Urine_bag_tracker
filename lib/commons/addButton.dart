import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key,required this.fn});
  final VoidCallback ? fn;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fn,
      child: Container(
        width: double.infinity,
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(84, 119, 146, 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            "Add",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}