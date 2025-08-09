import 'package:flutter/material.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:gameverse/ui/shared/widgets/game_card.dart';

import 'package:gameverse/config/spacing_config.dart';


class FilteredGameSection extends StatelessWidget {
  final List<GameModel> gameList;

  const FilteredGameSection({
    super.key,
    required this.gameList,
  });

  @override
  Widget build(BuildContext context) {
    if (gameList.isEmpty) {
      return SizedBox(
        height: 320,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.videogame_asset_off,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'No games found',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your filters',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      final crossAxisCount = MediaQuery.of(context).size.width > 1200 ? 3 : 2;

      return Container(
        constraints: BoxConstraints(minHeight: 320),
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spaceCardHorizontal,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: gameList.length,
          itemBuilder: (context, index) => GameCard(
            game: gameList[index],
            width: cardWidth(context),
            showPrice: true,
          ),
        ),
      );
    }
  }
}