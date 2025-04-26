import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univents_mobile/events.dart'; // Import the Event model

class DetailedView extends StatelessWidget {
  const DetailedView({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the event object passed as an argument
    final Event event = Get.arguments as Event;

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
                      image: NetworkImage(event.banner), // Use event banner
                      fit: BoxFit.cover,
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
                  child: Text(
                    event.title, // Use event title
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
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
                        event.datetimestart.toLocal().toString().split(' ')[0], // Display event date
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
                        '${event.datetimestart.toLocal().hour}:${event.datetimestart.toLocal().minute} - ${event.datetimeend.toLocal().hour}:${event.datetimeend.toLocal().minute}', // Display event time
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(width: 10),
                      Text(
                        event.location, // Display event location
                        style: const TextStyle(fontSize: 16),
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
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description, // Display event description
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Register functionality can be implemented here
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
                backgroundColor: const Color.fromARGB(255, 16, 118, 202),
              ),
              child: const Text(
                'Register',
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