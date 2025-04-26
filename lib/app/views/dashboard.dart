import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'package:univents_mobile/config/config.dart';
import 'package:univents_mobile/app/widgets/bottomnav.dart';
import 'package:univents_mobile/app/data/databases/event_database.dart';
import 'package:univents_mobile/app/data/databases/organization_database.dart';
import 'package:univents_mobile/app/widgets/eventcard.dart';

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
        child: userName != null
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: EventsListView(
                      userName: userName,
                      eventDatabase: EventDatabase(), 
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Get.toNamed('/detailedview');
                  //   },
                  //   child: const Text('Go to Detailed View'),
                  // ),
                ],
              )
            : const CircularProgressIndicator(),
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

        // Get current date and time
        final now = DateTime.now();

        // Filter events into categories
        final ongoingEvents = events.where((event) {
          return event.datetimestart.isBefore(now) && event.datetimeend.isAfter(now);
        }).toList();

        final upcomingEvents = events.where((event) {
          return event.datetimestart.isAfter(now);
        }).toList();

        final finishedEvents = events.where((event) {
          return event.datetimeend.isBefore(now);
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ongoing Events Section
            if (ongoingEvents.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.04),
                child: Text(
                  "Ongoing Events",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.5,
                ),
                itemCount: ongoingEvents.length,
                itemBuilder: (context, index) {
                  final event = ongoingEvents[index];
                  return EventCard(
                    event: event,
                    onTap: () {
                      Get.toNamed('/detailedview', arguments: event);
                    },
                  );
                },
              ),
            ],

            // Upcoming Events Section
            if (upcomingEvents.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.04),
                child: Text(
                  "Upcoming Events",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.5,
                ),
                itemCount: upcomingEvents.length,
                itemBuilder: (context, index) {
                  final event = upcomingEvents[index];
                  return EventCard(
                    event: event,
                    onTap: () {
                      Get.toNamed('/detailedview', arguments: event);
                    },
                  );
                },
              ),
            ],

            // Finished Events Section
            if (finishedEvents.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.04),
                child: Text(
                  "Finished Events",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.5,
                ),
                itemCount: finishedEvents.length,
                itemBuilder: (context, index) {
                  final event = finishedEvents[index];
                  return EventCard(
                    event: event,
                    onTap: () {
                      Get.toNamed('/detailedview', arguments: event);
                    },
                  );
                },
              ),
            ],
          ],
        );
      },
    );
  }
}