import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'package:univents_mobile/config/config.dart';
import 'package:univents_mobile/app/widgets/bottomnav.dart';
import 'package:univents_mobile/event_database.dart';
import 'package:univents_mobile/organization_database.dart';

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

  final organizationDatabase = OrganizationDatabase();
  final organizationController = TextEditingController();



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
              Container(
                padding: const EdgeInsets.all(10),
                child: EventsListView(
                  userName: userName,
                  eventDatabase: EventDatabase(), // Pass the EventDatabase instance
                ),
              )
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

class OrganizationsListView extends StatelessWidget {
  const OrganizationsListView({
    super.key,
    required this.userName,
    required this.organizationDatabase,
  });

  final String? userName;
  final OrganizationDatabase organizationDatabase;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: organizationDatabase.stream,
        builder: (context, snapshot) {
          //loading
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          //loaded
          final organizations = snapshot.data!;

          //list of organizations
          return ListView.builder(
            itemCount: organizations.length,
            itemBuilder: (context, index) {
              final organization = organizations[index];
              return ListTile(
                title: Text(organization.uid ?? 'No ID'),
              );
            },
          );
        }
    );
  }
}

class EventsListView extends StatelessWidget {
  const EventsListView({
    super.key,
    required this.userName,
    required this.eventDatabase,
  });

  final String? userName;
  final EventDatabase eventDatabase;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: eventDatabase.stream, // Updated to use events stream
      builder: (context, snapshot) {
        // Loading
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        // Loaded
        final events = snapshot.data!;

        // List of events in separate cards
        return ListView.builder(
          shrinkWrap: true, // Ensures the ListView takes only the necessary space
          physics: const NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return GestureDetector(
              onTap: () {
                // Navigate to DetailedView with event details
                Get.toNamed(
                  '/detailedview',
                  arguments: event, // Pass the event object as an argument
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Date: ${event.datetimestart.toLocal().toString().split(' ')[0]}', // Extracting only the date part
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}