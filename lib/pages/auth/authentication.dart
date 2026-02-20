// import 'package:flutter/material.dart';
// import 'package:urine_bag/pages/notebook/notebook.dart';

// class Authentication extends StatelessWidget {
//   const Authentication({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final String _authName = 'admin';
//     final String _authPass = '11223344';
//     final TextEditingController _nameController = TextEditingController();
//     final TextEditingController _passwordController = TextEditingController();
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(232, 226, 219, 1),
//       body: SingleChildScrollView(
//         physics: BouncingScrollPhysics(),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Column(
//             children: [
//               SizedBox(height: 50),
//               Container(child: Image.asset('assets/images/logo_png.png')),
//               //SizedBox(height: 100),
//               Text(
//                 'Authentication',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 25,
//                   color: Colors.black,
//                 ),
//               ),
//               SizedBox(height: 20),
//               _textField(
//                 "",
//                 "Name",
//                 Icon(Icons.person, size: 30),
//                 false,
//                 _nameController,
//               ),
//               SizedBox(height: 10),
//               _textField(
//                 "",
//                 "Password",
//                 Icon(Icons.no_encryption_outlined, size: 30),
//                 true,
//                 _passwordController,
                
//               ),
//               SizedBox(height: 10),
//               GestureDetector(
//                 onTap: () {
//                   if ((_authName == _nameController.text||_nameController.text=="Admin") &&
//                       (_authPass == _passwordController.text)) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => Notebook()),
//                     );
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text("Welcome Back !"),
//                         backgroundColor: const Color.fromARGB(255, 14, 114, 8),
//                       ),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text("Invalid Credentials Try Again"),
//                         backgroundColor: const Color.fromARGB(255, 179, 59, 50),
//                       ),
//                     );
//                   }
//                 },
//                 child: _continueButton(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _textField(
//     String text,
//     String hint,
//     Icon icon,
//     bool obscure,
//     TextEditingController controller,
//   ) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: TextField(
//         controller: controller,
//         obscureText: obscure,
//         decoration: InputDecoration(
//           icon: icon,

//           labelText: hint,

//           labelStyle: TextStyle(color: Colors.black),
//           border: InputBorder.none,
//         ),
//       ),
//     );
//   }

//   Widget _continueButton() {
//     return Container(
//       width: double.infinity,
//       height: 50,
//       margin: EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(84, 119, 146, 1),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Center(
//         child: Text(
//           "Continue",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 17,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:urine_bag/pages/notebook/notebook.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {

  final String _authName = 'admin';
  final String _authPass = '11223344';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final enteredName = _nameController.text.trim().toLowerCase();
    final enteredPass = _passwordController.text.trim();

    if (enteredName == _authName && enteredPass == _authPass) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Welcome Back!"),
          backgroundColor: Color.fromARGB(255, 14, 114, 8),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Notebook()),
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid Credentials. Try Again."),
          backgroundColor: Color.fromARGB(255, 179, 59, 50),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(232, 226, 219, 1),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 60),

              Image.asset('assets/images/logo_png.png'),

              const SizedBox(height: 20),

              const Text(
                'Authentication',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 30),

              _textField(
                hint: "Name",
                icon: const Icon(Icons.person, size: 28),
                obscure: false,
                controller: _nameController,
              ),

              const SizedBox(height: 15),

              _textField(
                hint: "Password",
                icon: const Icon(Icons.lock_outline, size: 28),
                obscure: true,
                controller: _passwordController,
              ),

              const SizedBox(height: 25),

              GestureDetector(
                onTap: _login,
                child: _continueButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required String hint,
    required Icon icon,
    required bool obscure,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          icon: icon,
          labelText: hint,
          labelStyle: const TextStyle(color: Colors.black),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _continueButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(84, 119, 146, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
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

