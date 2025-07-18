import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Library',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          // Placeholder for library content
          Text(
            'Here you can manage your games, view installed titles, and access your game collection.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 600), // Extra space before footer
        ],
      ),
    );
  }
}