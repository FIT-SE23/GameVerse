import 'package:flutter/material.dart';
import 'package:gameverse/ui/settings/view_model/settings_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:gameverse/config/spacing_config.dart';

import '../view_model/home_viewmodel.dart';

import 'game_section_horizontal.dart';
import 'game_section_fancy.dart';
import 'category_section.dart';

import 'package:gameverse/ui/shared/widgets/page_footer.dart';


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
      final SettingsViewModel settingsViewModel = Provider.of<SettingsViewModel>(context, listen: false);
      Provider.of<HomeViewModel>(context, listen: false).loadHomePageData(
        settingsViewModel.downloadPath
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<HomeViewModel>(
        builder: (context, homeViewModel, child) {
          return Column(
            children: [
              // this is not in Padding because the background key art
              // fills the window's width
              GameSectionFancy(title: 'Popular Games', gameList: Provider.of<HomeViewModel>(context, listen: false).popularGames,),

              Padding(
                padding: getNegativeSpacePadding(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 32,
                  children: [
                    SizedBox(height: 0),

                    if (Provider.of<HomeViewModel>(context, listen: false).featuredDiscount.isNotEmpty)
                      GameSectionHorizontal(title: 'Feature Discounts', gameList: Provider.of<HomeViewModel>(context, listen: false).featuredDiscount,),
                            
                    // SizedBox(height: 32),
                    GameSectionHorizontal(title: 'Explore New Games', gameList: Provider.of<HomeViewModel>(context, listen: false).newReleases,),

                    // SizedBox(height: 32),
                    GameSectionHorizontal(title: 'Top Recommended Games', gameList: Provider.of<HomeViewModel>(context, listen: false).topRecommendedGames,),

                    // SizedBox(height: 32),
                    CategorySection(),
              
                    const SizedBox(height: 64), // Extra space before footer
                  ],
                ),
              ),

              PageFooter(),
            ],
          );
        },
      ),
    );
  }
}