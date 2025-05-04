import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univents_mobile/app/data/databases/organization_database.dart';
import 'package:univents_mobile/app/data/models/organization.dart';
import 'package:univents_mobile/app/widgets/header.dart';
import 'package:univents_mobile/app/widgets/searchbar.dart';
import 'package:univents_mobile/config/config.dart';
import 'package:univents_mobile/app/widgets/organizationcard.dart';
import 'package:univents_mobile/app/widgets/bottomnav.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  int _selectedIndex = 1;
  final TextEditingController searchController = TextEditingController();
  final OrganizationDatabase organizationDatabase = OrganizationDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        adduLogo: adduLogo,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: CustomSearchBar(
              searchController: searchController,
              onChanged: (value) {
                setState(() {}); // Trigger a rebuild when the search input changes
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Organization>>(
              stream: organizationDatabase.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final organizations = snapshot.data!;
                final filteredOrganizations = organizations.where((organization) {
                  final query = searchController.text.toLowerCase();
                  return organization.name.toLowerCase().contains(query) ||
                      organization.acronym.toLowerCase().contains(query);
                }).toList();

                if (filteredOrganizations.isEmpty) {
                  return const Center(
                    child: Text('No organizations found.'),
                  );
                }

                return ListView.builder(
                  itemCount: filteredOrganizations.length,
                  itemBuilder: (context, index) {
                    final organization = filteredOrganizations[index];
                    return OrganizationCard(
                      organization: organization,
                      onTap: () {
                        Get.toNamed('/organizationevent', arguments: organization);
                        print('Tapped on ${organization.name}');
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
          // Add more tabs if needed
        },
      ),
    );
  }
}