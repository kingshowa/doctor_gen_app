import 'package:flutter/material.dart';

class BunnerCard extends StatelessWidget {
  const BunnerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card.filled(
      color: theme.colorScheme.primary,
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.end, // Align everything to bottom
        children: [
          // Text part
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 0, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ask DoctorGen",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "I provide general health advice and remedy suggestions based on user input",
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      //fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/chat',
                        arguments: {"id": null},
                      );
                    },
                    icon: Icon(Icons.bolt),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    label: Text("Start Chatting"),
                  ),
                ],
              ),
            ),
          ),
          // Image aligned to bottom
          // Clipped image in bottom-right with no padding
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(12), // Match card's corner radius
            ),
            child: Image.asset(
              'assets/images/robodoctor1.png',
              width: 170,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
