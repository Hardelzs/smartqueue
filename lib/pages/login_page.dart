import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartqueue/pages/role_selection_page.dart';
import '../services/api_service.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  String? _usernameError;
  String? _passwordError;
  String? _loginError;

  Future<void> _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _usernameError = username.isEmpty ? "Please enter your username" : null;
      _passwordError = password.isEmpty ? "Please enter your password" : null;
      _loginError = null;
    });

    if (_usernameError != null || _passwordError != null) return;

    setState(() => _loading = true);

    try {
      final response = await ApiService.login(username, password);

      _showMessage("Welcome back, ${response['username'] ?? 'User'}!");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RoleSelectionPage()),
      );
    } catch (error) {
      setState(() {
        _loginError = "Username or password is incorrect";
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildTextField(String label, TextEditingController controller, String? errorText, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.grey),
            errorText: errorText,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: errorText != null ? Colors.red : Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: errorText != null ? Colors.red : Colors.grey),
            ),
          ),
          cursorColor: Colors.black,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildLoginButton() {
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
        onPressed: _loading ? null : _handleLogin,
        child: _loading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Login", style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }

  Widget _buildSignupLink() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SignupPage()),
        );
      },
      child: Text(
        "Don't have an account? Sign up",
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome Back 👋",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Login to continue",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            if (_loginError != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _loginError!,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 30),
            _buildTextField("Username", _usernameController, _usernameError),
            const SizedBox(height: 17),
            _buildTextField("Password", _passwordController, _passwordError, obscure: true),
            const SizedBox(height: 25),
            _buildLoginButton(),
            const SizedBox(height: 18),
            _buildSignupLink(),
          ],
        ),
      ),
    );
  }
}