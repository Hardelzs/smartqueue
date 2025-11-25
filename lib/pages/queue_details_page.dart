import 'package:flutter/material.dart';

class QueueDetailsPage extends StatefulWidget {
  final String serviceTitle;
  final String branchName;

  const QueueDetailsPage({
    super.key,
    required this.serviceTitle,
    required this.branchName,
  });

  @override
  State<QueueDetailsPage> createState() => _QueueDetailsPageState();
}

class _QueueDetailsPageState extends State<QueueDetailsPage> {
  // Mock data for people in the queue
  List<Map<String, dynamic>> people = [
    {"name": "John Doe", "position": 1, "notified": false},
    {"name": "Sarah James", "position": 2, "notified": false},
    {"name": "Michael Smith", "position": 3, "notified": false},
    {"name": "Esther Chika", "position": 4, "notified": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.serviceTitle),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.branchName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text("👥 People in queue: ${people.length}"),
            const Divider(height: 30),

            // List of people in the queue
            Expanded(
              child: ListView.builder(
                itemCount: people.length,
                itemBuilder: (context, index) {
                  final person = people[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left side: name + position
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              person["name"],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Position: ${person["position"]}",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),

                        // Right side: actions
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.notifications_active,
                                color: person["notified"]
                                    ? Colors.orange
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  person["notified"] = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Notified ${person["name"]} to get ready."),
                                    duration:
                                        const Duration(milliseconds: 1200),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  people.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "${person["name"]} removed from queue."),
                                    duration:
                                        const Duration(milliseconds: 1200),
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),

            // Admin controls
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.notifications),
                    label: const Text("Notify All"),
                    onPressed: () {
                      setState(() {
                        for (var p in people) {
                          p["notified"] = true;
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("All customers notified!"),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.cancel),
                    label: const Text("End Queue"),
                    onPressed: () {
                      setState(() {
                        people.clear();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Queue has been ended."),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

