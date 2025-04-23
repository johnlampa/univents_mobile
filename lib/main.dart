import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:univents_mobile/login.dart'; // Import the LoginPage

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://abjnclqznfxeccdjmwkg.supabase.co', // Your Supabase project URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiam5jbHF6bmZ4ZWNjZGptd2tnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ2MTEyNTIsImV4cCI6MjA2MDE4NzI1Mn0.8vAOC7Vb_-WLMd1dnqR9aWpAzCiZRI_zaVv-yWzr5Jc', // Your Supabase anon key
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client; // Global Supabase client instance

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniVents',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(), // Set LoginPage as the home widget
    );
  }
}