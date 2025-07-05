import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
      ),
      body: Center(
        child: Text(
          'Community Page',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}