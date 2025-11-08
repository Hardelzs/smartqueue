import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _orgController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;

  Future<void> _handleSignup() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final firstName = _firstnameController.text.trim();
    final lastName = _lastnameController.text.trim();
    final organization = _orgController.text.trim();
    final password = _passwordController.text.trim();

    if ([username, email, firstName, lastName, password].any((field) => field.isEmpty)) {
      _showMessage("Please fill all required fields");
      return;
    }

    setState(() => _loading = true);

    try {
      final response = await ApiService.signup(
        username: username,
        email: email,
        firstName: firstName,
        lastName: lastName,
        organization: organization,
        password: password,
      );

      _showMessage("Signup successful! Welcome ${response['username'] ?? ''}");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } catch (error) {
      _showMessage("Signup failed: $error");
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _orgController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      cursorColor: Colors.black,
    );
  }

  Widget _buildSignupButton() {
    return Container(
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF191B1C), Color(0xFF444248)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: _loading ? null : _handleSignup,
        child: _loading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Sign Up", style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }

  Widget _buildLoginLink() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      },
      child: Text(
        "Already have an account? Login",
        style: GoogleFonts.poppins(
          color: Colors.blueAccent,
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 60),
              Text(
                "Create Account 🧾",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField("Username", _usernameController),
              const SizedBox(height: 17),
              _buildTextField("Email", _emailController),
              const SizedBox(height: 17),
              _buildTextField("First name", _firstnameController),
              const SizedBox(height: 17),
              _buildTextField("Last name", _lastnameController),
              const SizedBox(height: 17),
              _buildTextField("Organization", _orgController),
              const SizedBox(height: 17),
              _buildTextField("Password", _passwordController, obscure: true),
              const SizedBox(height: 25),
              _buildSignupButton(),
              const SizedBox(height: 18),
              _buildLoginLink(),
            ],
          ),
        ),
      ),
    );
  }
}