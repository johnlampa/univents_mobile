import 'package:flutter/material.dart';
import 'package:univents_mobile/app/data/models/events.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handle tap events
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            child: Stack(
              children: [
                // Event banner
                Image.network(
                  event.banner,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Dark overlay
                Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.5), // Semi-transparent black overlay
                ),
                // Event name and location
                Positioned(
                  bottom: 10, // Position the text near the bottom
                  left: 10,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event name
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // White text for visibility
                        ),
                        maxLines: 1, // Limit to one line
                        overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                      ),
                      const SizedBox(height: 4),
                      // Event location
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.location,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white, // White text for visibility
                              ),
                              maxLines: 1, // Limit to one line
                              overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}