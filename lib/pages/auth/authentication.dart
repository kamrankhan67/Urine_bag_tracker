
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
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient Element
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withOpacity(0.05),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    
                    // Logo Section
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/logo_png.png',
                          height: 100,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    Text(
                      'Welcome Back',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 28,
                        color: theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please authenticate to continue',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 48),

                    _textField(
                      hint: "Username",
                      icon: Icons.person_outline,
                      obscure: false,
                      controller: _nameController,
                      theme: theme,
                    ),

                    const SizedBox(height: 20),

                    _textField(
                      hint: "Password",
                      icon: Icons.lock_outline,
                      obscure: true,
                      controller: _passwordController,
                      theme: theme,
                    ),

                    const SizedBox(height: 40),

                    ElevatedButton(
                      onPressed: _login,
                      child: const Text("Continue"),
                    ),

                    const SizedBox(height: 40),
                    
                    Text(
                      "Munir & Sons Inventory System",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[400],
                        fontSize: 12,
                        letterSpacing: 1.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField({
    required String hint,
    required IconData icon,
    required bool obscure,
    required TextEditingController controller,
    required ThemeData theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            hint,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary.withOpacity(0.8),
            ),
          ),
        ),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: theme.colorScheme.primary.withOpacity(0.6)),
            hintText: "Enter your $hint",
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
        ),
      ],
    );
  }
}

