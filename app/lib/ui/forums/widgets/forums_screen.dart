import 'package:flutter/material.dart';

class ForumsScreen extends StatelessWidget {
  const ForumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Forums',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          // Placeholder for library content
          Text(
            'Here you can discuss games, share tips, and connect with other gamers.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 600), // Extra space before footer
        ],
      ),
    );
  }
}