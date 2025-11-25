import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:smartqueue/pages/admin/admin_home.dart';
import 'package:smartqueue/pages/admin/admin_signup_page.dart';
import 'package:smartqueue/pages/auth/forgot_password_request_page.dart';

const String API_BASE =
    'https://queueless-7el4.onrender.com'; // adjust if needed

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  String? _emailError;
  String? _passwordError;
  String? _loginError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _emailError = email.isEmpty ? 'Please enter your email' : null;
      _passwordError = password.isEmpty ? 'Please enter your password' : null;
      _loginError = null;
    });
    if (_emailError != null || _passwordError != null) return;

    setState(() => _loading = true);

    try {
      final res = await http.post(
        Uri.parse('$API_BASE/api/v1/org/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        // you can store token from body['token'] here if backend returns it
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminHome()),
        );
      } else {
        String msg = 'Login failed';
        try {
          final body = jsonDecode(res.body);
          msg = body['message'] ?? body['error'] ?? msg;
        } catch (_) {}
        setState(() => _loginError = msg);
      }
    } catch (e) {
      setState(() => _loginError = 'Request failed: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String? errorText, {
    bool obscure = false,
    TextInputType? keyboard,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboard,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.grey),
            errorText: errorText,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : Colors.grey,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : Colors.grey,
              ),
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
            : const Text(
                "Login",
                style: TextStyle(fontSize: 16, color: Colors.white),
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
              "Admin Login",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Login to manage your organization",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
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
            _buildTextField(
              "Email",
              _emailController,
              _emailError,
              keyboard: TextInputType.emailAddress,
            ),
            const SizedBox(height: 17),
            _buildTextField(
              "Password",
              _passwordController,
              _passwordError,
              obscure: true,
            ),
            const SizedBox(height: 25),
            _buildLoginButton(),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SignupPage()),
              ),
              child: Text(
                "Don't have an account? Sign up",
                style: GoogleFonts.poppins(
                  color: Colors.blueAccent,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ForgotPasswordRequestPage(),
                ),
              ),
              child: Text(
                "Forgot password?",
                style: GoogleFonts.poppins(
                  color: Colors.blueAccent,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
