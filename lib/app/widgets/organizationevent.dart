import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univents_mobile/app/data/models/organization.dart';
import 'package:univents_mobile/app/data/models/events.dart';
import 'package:univents_mobile/app/data/databases/event_database.dart';
import 'package:univents_mobile/app/data/databases/organization_database.dart';
import 'package:univents_mobile/app/widgets/eventcard.dart';
import 'package:univents_mobile/app/widgets/bottomnav.dart';
import 'package:univents_mobile/app/widgets/searchbar.dart';

class OrganizationEventPage extends StatefulWidget {
  const OrganizationEventPage({super.key});

  @override
  State<OrganizationEventPage> createState() => _OrganizationEventPageState();
}

class _OrganizationEventPageState extends State<OrganizationEventPage> {
  int _selectedIndex = 1;
  final TextEditingController searchController = TextEditingController();
  final List<String> selectedTags = []; // To track selected tags for filtering
  final List<String> availableTags = ['Forum', 'Advocacy', 'Engagement', 'Career Talk', 'Seminar', 'Competition', 'Cluster', 'Webinar', 'Art Contest', 'Quiz Bowl', 'Olympiad', 'Talk']; // Predefined tags

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
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(organization.logo), // Organization logo
              radius: 16, // Adjust the size of the logo
            ),
            const SizedBox(width: 8), // Add spacing between the logo and text
            Text('${organization.acronym} Events'),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Add the CustomSearchBar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: CustomSearchBar(
              searchController: searchController,
              onChanged: (value) {
                setState(() {}); // Trigger a rebuild when the search input changes
              },
            ),
          ),
          // Add the filter section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Wrap(
              spacing: 8.0,
              children: availableTags.map((tag) {
                return FilterChip(
                  label: Text(tag),
                  selected: selectedTags.contains(tag),
                  onSelected: (isSelected) {
                    setState(() {
                      if (isSelected) {
                        selectedTags.add(tag); // Add tag to selected list
                      } else {
                        selectedTags.remove(tag); // Remove tag from selected list
                      }
                    });
                  },
                );
              }).toList(),
            ),
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

                // Filter events based on the search query and selected tags
                final filteredEvents = orgEvents.where((event) {
                  final query = searchController.text.toLowerCase().trim();
                  final matchesQuery = event.title.toLowerCase().contains(query);

                  final matchesTags = selectedTags.isEmpty ||
                    selectedTags.every((selected) =>
                        event.tags.map((t) => t.toLowerCase()).contains(selected.toLowerCase()));

                  return matchesQuery && matchesTags;
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