import 'package:flutter/material.dart';

class GenresGame extends StatelessWidget {
  
  const GenresGame ({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      fallbackHeight: 100,
      fallbackWidth: double.infinity,
      child: Center(
        child: Text(
          'Genres Game',
          style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}