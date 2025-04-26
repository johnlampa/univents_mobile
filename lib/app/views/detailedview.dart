import 'package:flutter/material.dart';
import 'package:univents_mobile/config/config.dart';

class DetailedView extends StatefulWidget {
  const DetailedView({super.key});

  @override
  State<DetailedView> createState() => _DetailedViewState();
}

class _DetailedViewState extends State<DetailedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(''),
      //   backgroundColor: Colors.blue.withValues(alpha: 0.0),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(sampleEventBanner),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 30,
                  child: const Text(
                    'Event Title',
                    style: TextStyle(
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
                      backgroundColor:
                          Colors.transparent, // Removes background color
                      elevation: 0, // Removes the shadow
                      shadowColor:
                          Colors.transparent, // Ensures no shadow is applied
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_outlined,
                      color: Colors.white,
                      size: 30,
                    ), // Set icon color explicitly
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
                    spacing: 20,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.calendar_month),
                      Text('January 1, 2023', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    spacing: 20,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.access_time_outlined),
                      Text('7 PM - 9 PM', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    spacing: 20,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.group),
                      Text('Accountancy', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    spacing: 20,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.label),
                      Text('Culture and Arts', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    spacing: 20,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.location_on),
                      Text('Martin Hall', style: TextStyle(fontSize: 16)),
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
                  const Text(
                    'Event Description goes here. This is a detailed view of the event. Event Description goes here. This is a detailed view of the event. Event Description goes here. This is a detailed view of the event.',
                    style: TextStyle(fontSize: 16),
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
