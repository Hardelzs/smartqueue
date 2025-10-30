import 'package:flutter/material.dart';

class UserQueueInfoPage extends StatelessWidget {
  final String queueName;
  final String branchName;
  final int totalPeople;
  final int userPosition;
  final Duration estimatedWait;

  const UserQueueInfoPage({
    super.key,
    this.queueName = "Cafe Delight Queue",
    this.branchName = "Downtown Branch",
    this.totalPeople = 15,
    this.userPosition = 5, required this.estimatedWait,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Queue Details"),
        backgroundColor: Colors.indigoAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              queueName,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Branch: $branchName",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.indigo[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your Position", style: TextStyle(color: Colors.grey[700])),
                  Text(
                    "#$userPosition",
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                  const SizedBox(height: 10),
                  Text("Total People in Line: $totalPeople"),
                  const SizedBox(height: 5),
                  Text("Estimated Wait: ${estimatedWait.inMinutes} mins"),
                  const SizedBox(height: 5),
                  Text("Joined: ${DateTime.now().toLocal().toString().split('.')[0]}"),
                ],
              ),
            ),

            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.exit_to_app),
                label: Text("Leave Queue"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
