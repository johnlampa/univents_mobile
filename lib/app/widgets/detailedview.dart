import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:univents_mobile/app/data/models/events.dart';
import 'package:univents_mobile/app/data/models/organization.dart';
import 'package:intl/intl.dart';

class DetailedView extends StatefulWidget {
  const DetailedView({super.key});

  @override
  State<DetailedView> createState() => _DetailedViewState();
}

class _DetailedViewState extends State<DetailedView> {
  bool isDescriptionVisible =
      true; // State to track visibility of the description

  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments as Map<String, dynamic>;
    final Event event = args['event'] as Event;
    final Organization organization = args['organization'] as Organization;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(event.banner),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5),
                        BlendMode.darken,
                      ),
                    ),
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 30,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month),
                      const SizedBox(width: 10),
                      Text(
                        event.datetimestart.toLocal().day ==
                                event.datetimeend.toLocal().day
                            ? DateFormat(
                              'MMMM d, yyyy',
                            ).format(event.datetimestart.toLocal())
                            : '${DateFormat('MMMM d, yyyy').format(event.datetimestart.toLocal())} - ${DateFormat('MMMM d, yyyy').format(event.datetimeend.toLocal())}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.access_time_outlined),
                      const SizedBox(width: 10),
                      Text(
                        '${DateFormat('h:mm a').format(event.datetimestart.toLocal())} - ${DateFormat('h:mm a').format(event.datetimeend.toLocal())}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.location_city),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          organization.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.label),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          event.tags
                              .map(
                                (tag) =>
                                    tag[0].toUpperCase() + tag.substring(1),
                              )
                              .join(', '),
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          event.location,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 40, right: 40, left: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isDescriptionVisible
                              ? Icons.expand_less
                              : Icons.expand_more,
                        ),
                        onPressed: () {
                          setState(() {
                            isDescriptionVisible =
                                !isDescriptionVisible; // Toggle visibility
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (isDescriptionVisible)
                    Text(
                      event.description,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  print('Joining event: ${event.uid}');

                  final currentUser = supabase.auth.currentUser;
                  final userEmail = currentUser?.userMetadata?['email'];

                  if (userEmail == null) {
                    throw 'Error: User email is missing in metadata.';
                  }

                  final accountResponse = await supabase
                      .from('accounts')
                      .select('uid')
                      .eq('email', userEmail)
                      .maybeSingle();

                  if (accountResponse == null) {
                    throw 'Error fetching accountid: $accountResponse';
                  }

                  final accountId = accountResponse?['uid'] as String;
                  if (accountId == null) {
                    throw 'Error: No account found for the current user';
                  }

                  print('Account ID: $accountId'); // Debug: Print the accountid

                  // Check if an entry already exists in the attendees table
                  final attendeeResponse = await supabase
                      .from('attendees')
                      .select('uid') // Select the primary key or any column
                      .eq('accountid', accountId)
                      .eq('eventid', event.uid as Object)
                      .maybeSingle(); // Get a single row or null if no match

                  if (attendeeResponse != null) {
                    // Entry already exists
                    print('User is already registered for this event');
                    Get.snackbar(
                      'Already Registered',
                      'You are already registered for this event.',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  return;
                  }

                  // Add a new entry to the attendees table
                  final insertResponse = await supabase
                    .from('attendees')
                    .insert({
                      'accountid': accountId,
                      'datetimestamp': DateTime.now().toUtc().toIso8601String(),
                      'status': true,
                      'eventid': event.uid,
                  });

                  print('Successfully registered for the event!');
                  Get.snackbar(
                    'Registration Successful',
                    'You have successfully registered for the event.',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } catch (e) {
                  print('Error during event registration: $e');
                  Get.snackbar(
                    'Registration Failed',
                    'An error occurred while registering for the event.',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 10,
                ),
                backgroundColor: const Color.fromARGB(255, 16, 118, 202),
              ),
              child: const Text(
                'Join Event',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
