import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'), // Title of the AppBar
        backgroundColor: Colors.blueAccent, // Background color of the AppBar
      ),
      body: const Placeholder(), // Body of the Scaffold
    );
  }
}