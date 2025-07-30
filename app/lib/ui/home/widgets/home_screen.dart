import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gameverse/config/spacing_config.dart';

import '../view_model/home_viewmodel.dart';

import 'game_section_horizontal.dart';
import 'game_section_fancy.dart';
import 'genres_game.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeViewModel>(context, listen: false).loadHomePageData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<HomeViewModel>(
        builder: (context, homeViewModel, child) {
          return Column(
            children: [
              // this is not in Padding because the key art's width
              // is the window's width
              GameSectionFancy(title: 'Popular Games', gameList: Provider.of<HomeViewModel>(context, listen: false).popularGames,),

              Padding(
                padding: getNegativeSpacePadding(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 32),
                    GameSectionHorizontal(title: 'Feature Discounts', gameList: Provider.of<HomeViewModel>(context, listen: false).featuredDiscount,),
              
                    SizedBox(height: 32),
                    Text(
                      'Categories',
                      style: Theme.of(context).textTheme.displayLarge
                    ),
                    SizedBox(height: 16),
                    GenresGame(),
              
                    SizedBox(height: 32),
                    GameSectionHorizontal(title: 'Explore New Games', gameList: Provider.of<HomeViewModel>(context, listen: false).newReleases,),
              
                    SizedBox(height: 96), // Extra space before footer
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}