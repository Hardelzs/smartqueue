import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VerifyEmailPage extends StatefulWidget {
  final String email;

  const VerifyEmailPage({required this.email, Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _verifyCode() async {
    final code = _codeController.text.trim();

    if (code.length != 6) {
      setState(() {
        _errorMessage = "Please enter a valid 6-digit code.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('https://queueless-7el4.onrender.com/verify-email'),
        body: {
          'email': widget.email,
          'code': code,
        },
      );

      if (response.statusCode == 200) {
        // ✅ Success
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Success"),
            content: Text("Your email has been verified!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: Text("Continue"),
              ),
            ],
          ),
        );
      } else {
        // ❌ Failure
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Invalid Code"),
            content: Text("The code you entered is incorrect."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/signup');
                },
                child: Text("Back to Signup"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      _showMessage("Verification failed: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify Your Email")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "A 6-digit code has been sent to ${widget.email}.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: "Enter Verification Code",
                border: OutlineInputBorder(),
                errorText: _errorMessage,
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _verifyCode,
                    child: Text("Verify"),
                  ),
          ],
        ),
      ),
    );
  }
}