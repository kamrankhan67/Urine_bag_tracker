import 'package:flutter/material.dart';
import 'package:urine_bag/pages/notebook/notebook.dart';

class Authentication extends StatelessWidget {
  const Authentication({super.key});

  @override
  Widget build(BuildContext context) {
    final String _authName = 'admin';
    final String _authPass = '11223344';
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(232, 226, 219, 1),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 50),
              Container(child: Image.asset('assets/images/logo_png.png')),
              //SizedBox(height: 100),
              Text(
                'Authentication',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              _textField(
                "",
                "Name",
                Icon(Icons.person, size: 30),
                false,
                _nameController,
              ),
              SizedBox(height: 10),
              _textField(
                "",
                "Password",
                Icon(Icons.no_encryption_outlined, size: 30),
                true,
                _passwordController,
                
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  if ((_authName == _nameController.text||_nameController.text=="Admin") &&
                      (_authPass == _passwordController.text)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Notebook()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Welcome Back !"),
                        backgroundColor: const Color.fromARGB(255, 14, 114, 8),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Invalid Credentials Try Again"),
                        backgroundColor: const Color.fromARGB(255, 179, 59, 50),
                      ),
                    );
                  }
                },
                child: _continueButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(
    String text,
    String hint,
    Icon icon,
    bool obscure,
    TextEditingController controller,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          icon: icon,

          labelText: hint,

          labelStyle: TextStyle(color: Colors.black),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _continueButton() {
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(84, 119, 146, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          "Continue",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
