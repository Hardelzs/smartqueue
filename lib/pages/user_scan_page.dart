import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class UserScanPage extends StatefulWidget {
  const UserScanPage({super.key});

  @override
  State<UserScanPage> createState() => _UserScanPageState();
}

class _UserScanPageState extends State<UserScanPage> {
  bool hasScanned = false;
  String? queueName;
  int assignedNumber = 0;

  void _onDetect(BarcodeCapture capture) {
    if (hasScanned) return;

    final barcode = capture.barcodes.first;
    final code = barcode.rawValue ?? "";

    if (code.isEmpty) return;

    setState(() {
      hasScanned = true;
      queueName = code;
      assignedNumber = DateTime.now().millisecond % 100 + 1; // mock number
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("You joined queue: $queueName"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Scan & Join Queue"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: hasScanned
          ? _buildResultView()
          : Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Align the QR code within the frame",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                Expanded(
                  flex: 4,
                  child: MobileScanner(
                    onDetect: _onDetect,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
    );
  }

  Widget _buildResultView() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.qr_code_2, size: 80, color: Colors.teal),
            const SizedBox(height: 10),
            Text(
              "You joined: $queueName",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Your queue number is",
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text(
              "#$assignedNumber",
              style: const TextStyle(
                fontSize: 48,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("Scan Again"),
              onPressed: () {
                setState(() {
                  hasScanned = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
