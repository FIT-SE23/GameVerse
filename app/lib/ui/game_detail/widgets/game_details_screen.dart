import 'package:flutter/material.dart';

class GameDetailsScreen extends StatelessWidget {
  final int gameId;

  const GameDetailsScreen({
    super.key,
    required this.gameId,  
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Details'),
      ),
      body: Center(
        child: Text(
          'GameDetails Page for Game ID: $gameId',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}