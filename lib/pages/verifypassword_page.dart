import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'reserpassword_page.dart';

const String API_BASE = 'https://queueless-7el4.onrender.com'; // adjust if needed

class ForgotPasswordRequestPage extends StatefulWidget {
  const ForgotPasswordRequestPage({super.key});

  @override
  State<ForgotPasswordRequestPage> createState() => _ForgotPasswordRequestPageState();
}

class _ForgotPasswordRequestPageState extends State<ForgotPasswordRequestPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendRequest() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Please enter your email');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await http.post(
        Uri.parse('$API_BASE/api/v1/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification code sent to your email')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPasswordPage(email: email),
          ),
        );
      } else {
        setState(() => _error = 'Failed to initiate reset. Check the email and try again.');
      }
    } catch (e) {
      setState(() => _error = 'Request failed: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF9F9F9),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter your email', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Text('We will send a verification code to reset your password', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 24),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  errorText: _error,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _sendRequest,
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: _loading ? const CircularProgressIndicator(color: Colors.white) : Text('Send code', style: GoogleFonts.poppins(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}