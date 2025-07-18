import 'package:flutter/material.dart';

class PopularGames extends StatelessWidget {
  
  const PopularGames ({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      fallbackHeight: 400,
      fallbackWidth: double.infinity,
      child: Center(
        child: Text(
          'Popular Games',
          style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}