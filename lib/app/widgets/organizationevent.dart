import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univents_mobile/app/data/models/organization.dart';
import 'package:univents_mobile/app/data/models/events.dart';
import 'package:univents_mobile/app/data/databases/event_database.dart';
import 'package:univents_mobile/app/data/databases/organization_database.dart';
import 'package:univents_mobile/app/widgets/eventcard.dart';
import 'package:univents_mobile/app/widgets/bottomnav.dart'; // ✅ Import

class OrganizationEventPage extends StatefulWidget {
  const OrganizationEventPage({super.key});

  @override
  State<OrganizationEventPage> createState() => _OrganizationEventPageState();
}

class _OrganizationEventPageState extends State<OrganizationEventPage> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final Organization organization = Get.arguments as Organization;

    return Scaffold(
      appBar: AppBar(
        title: Text('${organization.acronym} Events'),
      ),
      body: StreamBuilder<List<Event>>(
        stream: EventDatabase().stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allEvents = snapshot.data!;
          final orgEvents = allEvents
              .where((event) => event.orguid == organization.uid)
              .toList();

          if (orgEvents.isEmpty) {
            return const Center(child: Text('No events found for this organization.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: orgEvents.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5,
            ),
            itemBuilder: (context, index) {
              final event = orgEvents[index];
              return EventCard(
                event: event,
                onTap: () async {
                  final org = await OrganizationDatabase().database
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
