import 'package:flutter/material.dart';

class AdvanceSearchScreen extends StatelessWidget {
  const AdvanceSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Advanced Search',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          // Placeholder for advanced search content
          Text(
            'Here you can perform advanced searches for games based on various criteria.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32), // Extra space before footer
        ],
      ),
    );
  }
}