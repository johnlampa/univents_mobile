import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final supabase = Supabase.instance.client;
  String? userName;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      setState(() {
        userName = user.userMetadata?['full_name'] ?? user.email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'), 
        backgroundColor: Colors.blueAccent, 
        actions: [
          IconButton(
            icon: const Icon(Icons.logout), 
            onPressed: () async {
              try {
                await supabase.auth.signOut();

                final GoogleSignIn googleSignIn = GoogleSignIn();
                await googleSignIn.signOut();

                Get.offAllNamed('/login');
              } catch (e) {
                print('Error during logout: $e');
              }
            },
          ),
        ],
      ),
      body: Center(
        child: userName != null
            ? Text(
                'Welcome, $userName!', 
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            : const CircularProgressIndicator(), 
      ),
    );
  }
}