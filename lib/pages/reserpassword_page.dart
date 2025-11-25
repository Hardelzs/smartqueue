import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'reset_password_change_page.dart';

const String API_BASE = 'https://queueless-7el4.onrender.com';

class ResetPasswordVerifyPage extends StatefulWidget {
  final String email;
  const ResetPasswordVerifyPage({required this.email, super.key});

  @override
  State<ResetPasswordVerifyPage> createState() => _ResetPasswordVerifyPageState();
}

class _ResetPasswordVerifyPageState extends State<ResetPasswordVerifyPage>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  void _triggerErrorFeedback(String message) {
    setState(() {
      _hasError = true;
      _errorMessage = message;
    });
    _shakeController.forward(from: 0);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _hasError = false;
          _errorMessage = null;
        });
      }
    });

    for (final controller in _controllers) {
      controller.clear();
    }

    Future.delayed(_shakeController.duration!, () {
      if (mounted) _shakeController.reset();
    });
  }

  Future<void> _verifyCode() async {
    final code = _controllers.map((c) => c.text).join();

    if (code.length != 6 || code.contains(RegExp(r'\D'))) {
      _triggerErrorFeedback("Please enter a valid 6-digit code.");
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('$API_BASE/api/v1/verify-reset-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": widget.email,
          "code": code,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _errorMessage = "✅ Code verified successfully";
        });

        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ResetPasswordChangePage(
                email: widget.email,
                code: code,
              ),
            ),
          );
        }
      } else {
        _triggerErrorFeedback("The code you entered is incorrect.");
      }
    } catch (e) {
      _triggerErrorFeedback("Verification failed: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildCodeInput() {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) => _buildDigitBox(index)),
          ),
        );
      },
    );
  }

  Widget _buildDigitBox(int index) {
    return Container(
      width: 54,
      height: 54,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: _hasError ? Colors.red : Colors.grey,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
        color: _hasError ? Colors.red.withOpacity(0.08) : Colors.transparent,
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Reset Code"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                Text(
                  "Enter Verification Code",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "We sent a 6-digit code to your email",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 28),
                _buildCodeInput(),
                const SizedBox(height: 20),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      _errorMessage!,
                      style: GoogleFonts.poppins(
                        color: _hasError ? Colors.red : Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 28),
                SizedBox(
                  width: 300,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _verifyCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Verify Code",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}