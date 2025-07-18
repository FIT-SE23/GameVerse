import 'package:flutter/material.dart';

class ExploreNewGame extends StatelessWidget {
  
  const ExploreNewGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      fallbackHeight: 300,
      fallbackWidth: double.infinity,
      child: Center(
        child: Text(
          'Explore New Game',
          style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}