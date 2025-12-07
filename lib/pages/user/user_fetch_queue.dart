import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class QueueDashboardPage extends StatefulWidget {
  @override
  _QueueDashboardPageState createState() => _QueueDashboardPageState();
}

class _QueueDashboardPageState extends State<QueueDashboardPage> {
  List<dynamic> queues = [];
  int currentPage = 1;
  int perPage = 10;
  int? _orgId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadOrgId();
  }

  Future<void> _loadOrgId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _orgId = prefs.getInt('org_id');
      setState(() {});
      if (_orgId != null) {
        fetchQueues();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Organization ID not found. Please login first.')),
        );
      }
    } catch (e) {
      print('Error loading orgId: $e');
    }
  }

  Future<void> fetchQueues() async {
    if (_orgId == null) return;

    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('https://queueless-7el4.onrender.com/api/v1/org/queue'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'orgId': _orgId, 'perPage': perPage, 'page': currentPage}),
      );

      if (response.statusCode == 200) {
        setState(() {
          queues = json.decode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void joinQueue(String queueId) async {
    final response = await http.post(
      Uri.parse('https://queueless-7el4.onrender.com/api/v1/org/queue/join'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'queueId': queueId}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully joined queue!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error joining queue: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Queue Dashboard')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: queues.isEmpty
                      ? const Center(child: Text('No queues available'))
                      : ListView.builder(
                          itemCount: queues.length,
                          itemBuilder: (context, index) {
                            final queue = queues[index];
                            return Card(
                              child: ListTile(
                                title: Text(queue['name']),
                                subtitle: Text('Status: ${queue['status']}'),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Users: ${queue['userCount'] ?? 0}'),
                                    Text('Wait Time: ${queue['waitTime'] ?? 0} mins'),
                                    ElevatedButton(
                                      onPressed: () => joinQueue(queue['id']),
                                      child: const Text('Join'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: currentPage > 1
                            ? () {
                                setState(() {
                                  currentPage--;
                                  fetchQueues();
                                });
                              }
                            : null,
                        child: const Text('Previous'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentPage++;
                            fetchQueues();
                          });
                        },
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
