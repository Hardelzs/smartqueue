import 'package:flutter/material.dart';
import 'pages/welcome_page.dart';

void main() {
  runApp(const QueueEaseApp());
}

class QueueEaseApp extends StatelessWidget {
  const QueueEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartQueue',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.deepPurpleAccent,
        useMaterial3: true,
      ),
      home: const WelcomePage(),
    );
  }
}

