import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// Mock API service - replace with your actual API service import
class ApiService {
  Future<dynamic> post(String endpoint, {required Map<String, dynamic> body}) async {
    // Implement your API call here
    return {};
  }
}

final apiService = ApiService();

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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  flex: 4,
                  child: MobileScanner(onDetect: _onDetect, fit: BoxFit.cover),
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QueueDashboardPage extends StatefulWidget {
  const QueueDashboardPage({super.key});

  @override
  State<QueueDashboardPage> createState() => _QueueDashboardPageState();
}

class _QueueDashboardPageState extends State<QueueDashboardPage> {
  int currentPage = 1;
  int perPage = 10;
  bool isLoading = false;
  List<QueueItem> queues = [];
  int? joinedQueueId;
  int userPosition = 0;

  @override
  void initState() {
    super.initState();
    _fetchQueues();
  }

  Future<void> _fetchQueues() async {
    setState(() => isLoading = true);
    try {
      await apiService.post(
        'https://queueless-7el4.onrender.com/api/v1/org/queue',
        body: {
          'orgId': 1,
          'perPage': perPage,
          'page': currentPage,
        },
      );

      // Mock data for demonstration
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        queues = [
          QueueItem(
            id: 1,
            name: "ATM Queue",
            status: "open",
            userCount: 12,
            estimatedWaitTime: 24,
          ),
          QueueItem(
            id: 2,
            name: "Customer Service",
            status: "open",
            userCount: 5,
            estimatedWaitTime: 10,
          ),
          QueueItem(
            id: 3,
            name: "Deposits",
            status: "closed",
            userCount: 0,
            estimatedWaitTime: 0,
          ),
        ];
      });
    } catch (e) {
      _showErrorSnackBar("Failed to fetch queues: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _joinQueue(QueueItem queue) async {
    setState(() => isLoading = true);
    try {
      await apiService.post(
        'https://queueless-7el4.onrender.com/api/v1/users/queue/join',
        body: {
          'queueId': queue.id,
        },
      );

      // Mock response
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        joinedQueueId = queue.id;
        userPosition = (queue.userCount % 20) + 1;
      });

      _showSuccessDialog(queue);
    } catch (e) {
      _showErrorSnackBar("Failed to join queue: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _leaveQueue() {
    setState(() {
      joinedQueueId = null;
      userPosition = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("You left the queue"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessDialog(QueueItem queue) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Queue Joined Successfully"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 60, color: Colors.teal),
            const SizedBox(height: 16),
            Text(
              "You joined: ${queue.name}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              "Your position in queue",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              "#$userPosition",
              style: const TextStyle(
                fontSize: 40,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Continue Shopping"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showQueueStatusBottomSheet(queue);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text("View Status"),
          ),
        ],
      ),
    );
  }

  void _showQueueStatusBottomSheet(QueueItem queue) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              queue.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatusRow("Your Position", "#$userPosition", Colors.teal),
            _buildStatusRow(
              "People Ahead",
              "${userPosition - 1}",
              Colors.orange,
            ),
            _buildStatusRow(
              "Est. Wait Time",
              "${((userPosition - 1) * (queue.estimatedWaitTime ~/ queue.userCount)).toStringAsFixed(0)} min",
              Colors.blue,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _leaveQueue,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Leave Queue"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text("Close"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    setState(() => currentPage++);
    _fetchQueues();
  }

  void _previousPage() {
    if (currentPage > 1) {
      setState(() => currentPage--);
      _fetchQueues();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Available Queues"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (joinedQueueId != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.teal[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.teal),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info, color: Colors.teal),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "You are in a queue. Your position: #$userPosition",
                                    style: const TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: queues.length,
                          itemBuilder: (context, index) =>
                              _buildQueueCard(queues[index]),
                        ),
                      ],
                    ),
                  ),
                  // Pagination
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: currentPage > 1 ? _previousPage : null,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text("Previous"),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          "Page $currentPage",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _nextPage,
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text("Next"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildQueueCard(QueueItem queue) {
    final isJoined = joinedQueueId == queue.id;
    final isDisabled = queue.status == "closed" || isJoined;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    queue.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(queue.status.toUpperCase()),
                  backgroundColor: queue.status == "open"
                      ? Colors.green[100]
                      : Colors.red[100],
                  labelStyle: TextStyle(
                    color: queue.status == "open" ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn("Users in Queue", queue.userCount.toString()),
                _buildStatColumn(
                  "Est. Wait Time",
                  "${queue.estimatedWaitTime} min",
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isDisabled ? null : () => _joinQueue(queue),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isJoined ? Colors.grey : Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: Text(
                  isJoined
                      ? "Joined"
                      : queue.status == "closed"
                      ? "Queue Closed"
                      : "Join Queue",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class QueueItem {
  final int id;
  final String name;
  final String status;
  final int userCount;
  final int estimatedWaitTime;

  QueueItem({
    required this.id,
    required this.name,
    required this.status,
    required this.userCount,
    required this.estimatedWaitTime,
  });
}
