import 'package:flutter/material.dart';
import 'package:univents_mobile/app/data/models/organization.dart';

class OrganizationCard extends StatelessWidget {
  final Organization organization;
  final VoidCallback onTap;

  const OrganizationCard({
    super.key,
    required this.organization,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background image with dark overlay
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(organization.banner), // Add banner URL in model
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
              ),
            ),

            // Content
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Badge and Logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            organization.acronym,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),

                        // Logo
                        CircleAvatar(
                          backgroundImage: NetworkImage(organization.logo),
                          backgroundColor: Colors.white,
                          radius: 20,
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Organization Name
                    Text(
                      organization.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Category
                    Text(
                      organization.category,
                      style: const TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Contact Info
                    Row(
                      children: [
                        const Icon(Icons.email, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            organization.email,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            organization.mobile,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.link, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            organization.facebook,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
