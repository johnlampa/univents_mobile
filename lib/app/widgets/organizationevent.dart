import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univents_mobile/app/data/models/organization.dart';
import 'package:univents_mobile/app/data/models/events.dart';
import 'package:univents_mobile/app/data/databases/event_database.dart';
import 'package:univents_mobile/app/data/databases/organization_database.dart';
import 'package:univents_mobile/app/widgets/eventcard.dart';
import 'package:univents_mobile/app/widgets/bottomnav.dart';
import 'package:univents_mobile/app/widgets/searchbar.dart'; // ✅ Import CustomSearchBar

class OrganizationEventPage extends StatefulWidget {
  const OrganizationEventPage({super.key});

  @override
  State<OrganizationEventPage> createState() => _OrganizationEventPageState();
}

class _OrganizationEventPageState extends State<OrganizationEventPage> {
  int _selectedIndex = 1;
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    // Dispose the search controller when the widget is removed
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Organization organization = Get.arguments as Organization;

    return Scaffold(
      appBar: AppBar(
        title: Text('${organization.acronym} Events'),
      ),
      body: Column(
        children: [
          // Add the CustomSearchBar
          CustomSearchBar(
            searchController: searchController,
            onChanged: (value) {
              setState(() {}); // Trigger a rebuild when the search input changes
            },
          ),
          Expanded(
            child: StreamBuilder<List<Event>>(
              stream: EventDatabase().stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allEvents = snapshot.data!;
                final orgEvents = allEvents
                    .where((event) => event.orguid == organization.uid)
                    .toList();

                // Filter events based only on the event.title
                final filteredEvents = orgEvents.where((event) {
                  final query = searchController.text.toLowerCase();
                  return event.title.toLowerCase().contains(query);
                }).toList();

                if (filteredEvents.isEmpty) {
                  return const Center(
                    child: Text('No events found for this organization.'),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: filteredEvents.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemBuilder: (context, index) {
                    final event = filteredEvents[index];
                    return EventCard(
                      event: event,
                      onTap: () async {
                        final org = await OrganizationDatabase()
                            .database
                            .select()
                            .eq('uid', event.orguid)
                            .single();
                        Get.toNamed('/detailedview', arguments: {
                          'event': event,
                          'organization': Organization.fromMap(org),
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);

          if (index == 0) {
            Get.toNamed('/dashboard');
          } else if (index == 1) {
            Get.toNamed('/search');
          }
        },
      ),
    );
  }
}