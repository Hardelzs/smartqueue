import 'package:flutter/material.dart';
import 'package:smartqueue/pages/admin_navbar.dart';

// import './queue_details_page.dart';

class AdminMonitorPage extends StatefulWidget {
  const AdminMonitorPage({super.key});

  @override
  State<AdminMonitorPage> createState() => _AdminMonitorPageState();
}

class _AdminMonitorPageState extends State<AdminMonitorPage> {
  final TextEditingController _searchController = TextEditingController();

  // Sample queue data
  final List<Map<String, dynamic>> _queues = [
    {
      "branch": "National Bank Zomba Branch",
      "services": [
        {
          "title": "Customer Service",
          "desc": "For account inquiries, card replacements, and general help.",
          "available": true
        },
        {
          "title": "Loan Desk",
          "desc": "Loan inquiries and processing support.",
          "available": false
        },
      ]
    },
    {
      "branch": "National Bank Lilongwe Branch",
      "services": [
        {
          "title": "Teller Queue",
          "desc": "For cash deposits, withdrawals, and other transactions.",
          "available": true
        }
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Monitor Queues",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // 🔍 Search bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search queues...",
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () => _searchController.clear(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🧾 List of queues
              Expanded(
                child: ListView.builder(
                  itemCount: _queues.length,
                  itemBuilder: (context, branchIndex) {
                    final branch = _queues[branchIndex];
                    return _buildBranchCard(branch);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBranchCard(Map<String, dynamic> branch) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            branch["branch"],
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(branch["services"].length, (index) {
            final service = branch["services"][index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 20),
                Text(
                  service["title"],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Text(
                  service["desc"],
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminNavBar(
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 10),
                      ),
                      child: const Text("View More"),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      service["available"]
                          ? Icons.circle
                          : Icons.circle_outlined,
                      color:
                          service["available"] ? Colors.green : Colors.grey[400],
                      size: 12,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      service["available"] ? "Available" : "Closed",
                      style: TextStyle(
                        fontSize: 12,
                        color: service["available"]
                            ? Colors.green
                            : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
