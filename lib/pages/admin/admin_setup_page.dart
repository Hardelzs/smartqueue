import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminSetupPage extends StatefulWidget {
  const AdminSetupPage({super.key});

  @override
  State<AdminSetupPage> createState() => _AdminSetupPageState();
}

class _AdminSetupPageState extends State<AdminSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _orgController = TextEditingController();
  final _durationController = TextEditingController();
  bool _isLoading = false;

  String? _generatedCode;
  String? _authToken;
  int? _orgId; // Add this

  @override
  void initState() {
    super.initState();
    _loadAuthToken();
    _loadOrgId(); // Add this
  }

  // Load stored auth token from SharedPreferences
  Future<void> _loadAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _authToken = prefs.getString('auth_token');
      setState(() {});
      if (_authToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No token found. Please login first.')),
        );
      }
    } catch (e) {
      print('Error loading token: $e');
    }
  }

  // Load stored orgId from SharedPreferences
  Future<void> _loadOrgId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _orgId = prefs.getInt('org_id');
      setState(() {});
      if (_orgId == null) {
        print('Warning: No orgId found');
      }
    } catch (e) {
      print('Error loading orgId: $e');
    }
  }

  void _generateQR() {
    if (_formKey.currentState!.validate()) {
      final orgName = _orgController.text.trim();
      final duration = _durationController.text.trim();

      _createQueue(orgName, duration);
    }
  }

  static const String apiBase = 'https://queueless-7el4.onrender.com';

  Future<void> _createQueue(String name, String durationHours) async {
    if (_authToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No authentication token found. Please login first.'),
        ),
      );
      return;
    }

    if (_orgId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Organization ID not found. Please login again.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final estimatedInterval = (int.tryParse(durationHours) ?? 0) * 60;
      final body = {
        "name": name,
        "estimatedInterval": estimatedInterval,
        "orgId": _orgId, // Use the loaded orgId
      };

      final uri = Uri.parse('$apiBase/api/v1/queue');
      final res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: jsonEncode(body),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        String code;
        try {
          final map = jsonDecode(res.body);
          code =
              map['code']?.toString() ??
              map['data']?['code']?.toString() ??
              "$name-${DateTime.now().millisecondsSinceEpoch}";
        } catch (_) {
          code = "$name-${DateTime.now().millisecondsSinceEpoch}";
        }
        setState(() => _generatedCode = code);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Queue created successfully')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to create queue (${res.statusCode}): ${res.body}',
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _orgController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Create Queue",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Organization Info",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),

                // Organization Name Field
                TextFormField(
                  controller: _orgController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Organization Name",
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    isDense: true, // optional: reduces vertical padding
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                  cursorColor: Colors.black,
                  validator: (value) => value!.isEmpty
                      ? "Please enter an organization name"
                      : null,
                ),

                const SizedBox(height: 20),

                // Duration Field
                TextFormField(
                  controller: _durationController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Duration (hours)",
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    isDense: true, // optional: reduces vertical padding
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter duration in hours";
                    }
                    if (int.tryParse(value) == null) {
                      return "Please enter a valid number";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 40),

                // Generate Button
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                  ), // moves it down a little
                  child: Container(
                    width: double.infinity,
                    height: 65,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
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
                      onPressed: _isLoading ? null : _generateQR,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "Generate QR Code",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Generated QR Section
                if (_generatedCode != null) ...[
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Your Queue QR Code",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: QrImageView(
                            data: _generatedCode!,
                            version: QrVersions.auto,
                            size: 200,
                            foregroundColor: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Code: $_generatedCode",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                // Add printing logic here
                                print('Print QR Code');
                              },
                              icon: const Icon(
                                Icons.print,
                                color: Colors.white,
                              ),
                              label: Text(
                                'Print',
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                Share.share('Queue Code: $_generatedCode');
                              },
                              icon: const Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                              label: Text(
                                'Share',
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: const AdminNavBar(),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38),
      filled: true,
      fillColor: Colors.white10,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.deepPurpleAccent),
      ),
    );
  }
}
