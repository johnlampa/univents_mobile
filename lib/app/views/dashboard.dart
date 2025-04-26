import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'package:univents_mobile/config/config.dart';
import 'package:univents_mobile/app/widgets/bottomnav.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final supabase = Supabase.instance.client;
  String? userName;
  int _selectedIndex = 0;

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
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child: Image.network(adduLogo, fit: BoxFit.contain),
            ),
            const SizedBox(width: 10),
            userName != null
                ? Text(
                  'Welcome, $userName!',
                  style: const TextStyle(fontSize: 18),
                )
                : const Text('Dashboard', style: TextStyle(fontSize: 18)),
          ],
        ),
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              userName != null
                  ? const Placeholder()
                  : const CircularProgressIndicator(),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('/detailedview');
                },
                child: const Text('Go to Detailed View'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) {
          print("Tapped index: $index");
          setState(() {
            _selectedIndex = index;
          });

          if (index == 1) {
            print("Navigating to Search page");
            Get.toNamed('/search');
          } else if (index == 0) {
            Get.toNamed('/dashboard');
          }
        },
      ),
    );
  }
}
