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
  bool isDescriptionVisible = true; // State to track visibility of the description
  bool isRegistered = false; // State to track if the user is already registered
  final supabase = Supabase.instance.client;

  late Event event; // Class-level variable for the event
  late Organization organization; // Class-level variable for the organization

  @override
  void initState() {
    super.initState();

    // Retrieve event and organization from Get.arguments
    final Map<String, dynamic> args = Get.arguments as Map<String, dynamic>;
    event = args['event'] as Event;
    organization = args['organization'] as Organization;

    _checkRegistrationStatus(); // Check if the user is already registered
  }

  Future<void> _checkRegistrationStatus() async {
    try {
      final currentUser = supabase.auth.currentUser;
      final userEmail = currentUser?.userMetadata?['email'];

      if (userEmail == null) {
        throw 'Error: User email is missing in metadata.';
      }

      // Fetch the account ID for the current user
      final accountResponse = await supabase
          .from('accounts')
          .select('uid')
          .eq('email', userEmail)
          .maybeSingle();

      if (accountResponse == null || accountResponse['uid'] == null) {
        throw 'Error: No account found for the current user';
      }

      final accountId = accountResponse['uid'] as String;

      // Check if an entry already exists in the attendees table
      final attendeeResponse = await supabase
          .from('attendees')
          .select('uid, status')
          .eq('accountid', accountId)
          .eq('eventid', event.uid as Object)
          .maybeSingle();

      if (attendeeResponse != null && attendeeResponse['status'] == true) {
        // Entry exists and the user is registered
        setState(() {
          isRegistered = true;
        });
      }
    } catch (e) {
      print('Error checking registration status: $e');
    }
  }

  Future<bool?> _showConfirmationDialog(
      BuildContext context, String title, String message) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User cancels
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirms
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _unjoinEvent() async {
    try {
      final currentUser = supabase.auth.currentUser;
      final userEmail = currentUser?.userMetadata?['email'];

      if (userEmail == null) {
        throw 'Error: User email is missing in metadata.';
      }

      // Fetch the account ID for the current user
      final accountResponse = await supabase
          .from('accounts')
          .select('uid')
          .eq('email', userEmail)
          .maybeSingle();

      if (accountResponse == null || accountResponse['uid'] == null) {
        throw 'Error: No account found for the current user';
      }

      final accountId = accountResponse['uid'] as String;

      // Update the status column in the attendees table
      final updateResponse = await supabase
          .from('attendees')
          .update({
            'status': false,
            'datetimestamp': DateTime.now().toUtc().add(const Duration(hours: 8)).toIso8601String(),
          })
          .eq('accountid', accountId)
          .eq('eventid', event.uid as Object)
          .select();

      if (updateResponse.isEmpty) {
        throw 'Error: Update operation returned no data.';
      }

      print('Successfully unjoined the event!');
      setState(() {
        isRegistered = false; // Update the state to reflect unjoining
      });
      Get.snackbar(
        'Unjoined Event',
        'You have successfully unjoined the event.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error during unjoining: $e');
      Get.snackbar(
        'Error',
        'An error occurred while unjoining the event.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _joinEvent() async {
    try {
      final currentUser = supabase.auth.currentUser;
      final userEmail = currentUser?.userMetadata?['email'];

      if (userEmail == null) {
        throw 'Error: User email is missing in metadata.';
      }

      // Fetch the account ID for the current user
      final accountResponse = await supabase
          .from('accounts')
          .select('uid')
          .eq('email', userEmail)
          .maybeSingle();

      if (accountResponse == null || accountResponse['uid'] == null) {
        throw 'Error: No account found for the current user';
      }

      final accountId = accountResponse['uid'] as String;

      // Check if an entry already exists in the attendees table with status false
      final attendeeResponse = await supabase
          .from('attendees')
          .select('uid')
          .eq('accountid', accountId)
          .eq('eventid', event.uid as Object)
          .eq('status', false)
          .maybeSingle();

      if (attendeeResponse != null) {
        // Update the existing row to set status to true
        final updateResponse = await supabase
            .from('attendees')
            .update({
              'status': true,
              'datetimestamp': DateTime.now().toUtc().add(const Duration(hours: 8)).toIso8601String(),
            })
            .eq('accountid', accountId)
            .eq('eventid', event.uid as Object)
            .select();

        if (updateResponse.isEmpty) {
          throw 'Error: Update operation returned no data.';
        }

        print('Successfully rejoined the event!');
      } else {
        // Insert a new row if no matching entry exists
        final insertResponse = await supabase
            .from('attendees')
            .insert({
              'accountid': accountId,
              'datetimestamp': DateTime.now().toUtc().add(const Duration(hours: 8)).toIso8601String(),
              'status': true,
              'eventid': event.uid,
            });

        print('Successfully registered for the event!');
      }

      setState(() {
        isRegistered = true; // Update the state to reflect registration
      });
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
  }

  @override
  Widget build(BuildContext context) {
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
                if (isRegistered) {
                  // Prompt for confirmation to unjoin
                  final shouldUnjoin = await _showConfirmationDialog(
                    context,
                    'Unjoin Event',
                    'Are you sure you want to unjoin this event?',
                  );

                  if (shouldUnjoin == true) {
                    await _unjoinEvent();
                  }
                } else {
                  await _joinEvent();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 10,
                ),
                backgroundColor: isRegistered
                    ? Colors.orange // Orange color if already registered
                    : const Color.fromARGB(255, 16, 118, 202), // Default color
              ),
              child: Text(
                isRegistered ? 'Unjoin Event' : 'Join Event', // Change text based on registration status
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}