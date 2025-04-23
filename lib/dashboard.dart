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
  final supabase = Supabase.instance.client; // Access Supabase client

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'), // Title of the AppBar
        backgroundColor: Colors.blueAccent, // Background color of the AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.logout), // Logout icon
            onPressed: () async {
              try {
                // Sign out from Supabase
                await supabase.auth.signOut();

                // Sign out from GoogleSignIn
                final GoogleSignIn googleSignIn = GoogleSignIn();
                await googleSignIn.signOut();

                // Navigate back to the login page
                Get.offAllNamed('/login'); // Use GetX to navigate to the login page
              } catch (e) {
                print('Error during logout: $e');
              }
            },
          ),
        ],
      ),
      body: const Placeholder(), // Body of the Scaffold
    );
  }
}