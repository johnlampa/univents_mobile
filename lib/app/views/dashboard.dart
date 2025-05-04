import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'package:univents_mobile/app/data/models/organization.dart';
import 'package:univents_mobile/config/config.dart';
import 'package:univents_mobile/app/widgets/bottomnav.dart';
import 'package:univents_mobile/app/data/databases/event_database.dart';
import 'package:univents_mobile/app/data/databases/organization_database.dart';
import 'package:univents_mobile/app/widgets/eventcard.dart';
import 'package:univents_mobile/app/widgets/header.dart';
import 'package:univents_mobile/app/widgets/searchbar.dart';

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
      appBar: Header(
        adduLogo: adduLogo,
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


  SizedBox getUserName() {
    return SizedBox(
            child: userName != null
            ? Text(
              'Welcome, $userName!',
              style: const TextStyle(fontSize: 18),
            )
            : const Text('Dashboard', style: TextStyle(fontSize: 18)),
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
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final organizations = snapshot.data!;

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
    final TextEditingController searchController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSearchBar(
          searchController: searchController,
          onChanged: (value) {
            // Handle search input changes here if needed
          },
        ),
        const SizedBox(height: 10),

        StreamBuilder(
          stream: eventDatabase.stream, 
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final events = snapshot.data!;
            final now = DateTime.now();

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
                        onTap: () async {
                          final organization = await OrganizationDatabase().database
                              .select()
                              .eq('uid', event.orguid)
                              .single();
                          Get.toNamed(
                            '/detailedview',
                            arguments: {
                              'event': event,
                              'organization': Organization.fromMap(organization),
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
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
                        onTap: () async {
                          final organization = await OrganizationDatabase().database
                              .select()
                              .eq('uid', event.orguid)
                              .single();
                          Get.toNamed(
                            '/detailedview',
                            arguments: {
                              'event': event,
                              'organization': Organization.fromMap(organization),
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
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
                        onTap: () async {
                          final organization = await OrganizationDatabase().database
                              .select()
                              .eq('uid', event.orguid)
                              .single();
                          Get.toNamed(
                            '/detailedview',
                            arguments: {
                              'event': event,
                              'organization': Organization.fromMap(organization),
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}