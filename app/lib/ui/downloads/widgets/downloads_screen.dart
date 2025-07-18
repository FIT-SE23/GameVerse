import 'package:flutter/material.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Downloads',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          // Placeholder for library content
          Text(
            'Here you can manage your downloads, view progress, and access your downloaded games.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 600), // Extra space before footer
        ],
      ),
    );
  }
}