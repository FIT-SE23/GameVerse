import 'package:flutter/material.dart';

class GameDetailsScreen extends StatelessWidget {
  final int gameId;

  const GameDetailsScreen({
    super.key,
    required this.gameId,  
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Game Details for Game ID: $gameId',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          // Placeholder for game details content
          Text(
            'Here you can view detailed information about the game with ID $gameId.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32), // Extra space before footer
        ],
      ),
    );
  }
}