import 'package:flutter/material.dart';
import 'dart:math';

import 'featured_games_carousel.dart';
import 'explore_new_game.dart';
import 'genres_game.dart';
import 'popular_games.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: max(MediaQuery.of(context).size.width / 10, 32)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Popular Games',
              style: TextStyle(
                fontSize: 22, 
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 16),
            PopularGames(),
            SizedBox(height: 32),
            Text(
              'Features Discounts',
              style: TextStyle(
                fontSize: 22, 
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 16),
            FeaturedDiscountCarousel(),
            SizedBox(height: 32),
            Text(
              'Categories',
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
            SizedBox(height: 32), // Extra space before footer
          ],
        ),
      ),
    );
  }
}