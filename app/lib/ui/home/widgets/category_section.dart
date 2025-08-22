import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gameverse/ui/settings/view_model/settings_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:gameverse/routing/routes.dart';
import 'package:go_router/go_router.dart';

import '../view_model/home_viewmodel.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'game_section_vertical.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context, listen: false);
    final status = viewModel.state;

    // int m;
    Map<String, List<GameModel>> pickedGamesByCategories = {};

    if (viewModel.gamesByCategories.length > 3) {
      final random = Random();
      final shuffled = viewModel.gamesByCategories.keys.toList()..shuffle(random);
      // m = 3;
      final pickedCategories = shuffled.take(3);
      for (final category in pickedCategories) {
        pickedGamesByCategories[category] = viewModel.gamesByCategories[category]!;
      }
    } else {
      // m = viewModel.gamesByCategories.length;
      pickedGamesByCategories = viewModel.gamesByCategories;
    }
    
    int maxLen = 0;
    // remove this when there are more games
    for (final category in pickedGamesByCategories.keys) {
      maxLen = max(maxLen, pickedGamesByCategories[category]!.length);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Random Picks',
          style: Theme.of(context).textTheme.displayLarge
        ),
        SizedBox(height: 16),

        if (status == HomeViewState.loading)
          const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          )

        else if (status == HomeViewState.error)
          SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(viewModel.errorMessage),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.loadHomePageData(
                      Provider.of<SettingsViewModel>(context, listen: false).downloadPath
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          )
        
        else if (status == HomeViewState.success)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final categoryName in pickedGamesByCategories.keys)
                GameSectionVertical(
                  title: '$categoryName games',
                  gameList: pickedGamesByCategories[categoryName]!,
                  onSelect: () {
                    context.push('${Routes.advancedSearch}?categories=$categoryName');
                  },
                  titleStyle: Theme.of(context).textTheme.displaySmall,
                )
            ]
          )

        else
          const SizedBox(
            height: 200,
            child: Center(child: Text('Something went wrong :(')),
          )
      ],
    );
  }
}