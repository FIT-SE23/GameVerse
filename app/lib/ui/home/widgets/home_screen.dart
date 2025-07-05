import 'package:flutter/material.dart';

import 'package:gameverse/ui/home/widgets/featured_games_carousel.dart';
import 'package:gameverse/ui/home/widgets/explore_new_game.dart';
import 'package:gameverse/ui/home/widgets/genres_game.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Special Offers',
                  style: TextStyle(
                    fontSize: 22, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 16),
                FeaturedGamesCarousel(),
                Text(
                  'Genres',
                  style: TextStyle(
                    fontSize: 22, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 16),
                GenresGame(),
                SizedBox(height: 32),
                Text(
                  'Explore New Games',
                  style: TextStyle(
                    fontSize: 22, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 16),
                ExploreNewGame(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}