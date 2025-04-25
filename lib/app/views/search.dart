import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univents_mobile/app/widgets/bottomnav.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  int _selectedIndex = 1; // Set the default index to 1 for the "Search" tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: const Center(
        child: Text('This is the Search Page'),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Navigate to the appropriate page based on the index
          if (index == 0) {
            Get.toNamed('/dashboard'); // Navigate to the Dashboard page
          } else if (index == 1) {
            // Stay on the Search page
          } else if (index == 2) {
            Get.toNamed('/events'); // Navigate to the Events page (if implemented)
          } else if (index == 3) {
            Get.toNamed('/menu'); // Navigate to the Menu page (if implemented)
          }
        },
      ),
    );
  }
}