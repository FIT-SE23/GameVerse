import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:go_router/go_router.dart';

// import 'package:gameverse/domain/models/game_model/game_model.dart';
// import '../view_model/home_viewmodel.dart';

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