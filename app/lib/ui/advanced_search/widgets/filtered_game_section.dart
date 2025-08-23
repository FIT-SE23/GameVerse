import 'package:flutter/material.dart';
import 'package:gameverse/data/repositories/game_repository.dart';

import '../view_model/advanced_search_viewmodel.dart';

import 'package:gameverse/ui/shared/widgets/game_card.dart';

import 'package:gameverse/config/spacing_config.dart';


class FilteredGameSection extends StatefulWidget {
  final AdvancedSearchViewmodel viewModel;

  const FilteredGameSection({
    super.key,
    required this.viewModel,
  });

  @override
  State<StatefulWidget> createState() => _FilteredGameSectionState();
}

class _FilteredGameSectionState extends State<FilteredGameSection> {
  String sortCriteria = '';

  @override
  void initState() {
    super.initState();
    sortCriteria = widget.viewModel.sortCriteria;
  }

  @override
  Widget build(BuildContext context) {
    final gameList = widget.viewModel.filteredGames;
    final theme = Theme.of(context);
    
    final crossAxisCount = MediaQuery.of(context).size.width > 1200 ? 3 : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Row(
          children: [
            Text(
              'Sort by:   ',
              style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.normal),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.textTheme.bodyMedium?.color ?? Colors.white,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: BoxConstraints(maxHeight: 200, maxWidth: 200),
              child: DropdownButton<String>(
                focusColor: Colors.transparent,
                isDense: true,
                value: sortCriteria,
                underline: const SizedBox(),
                icon: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.sort,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: GameSortCriteria.popularity,
                    child: Text(
                      GameSortCriteria.popularityDisplay,
                      style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                    ), 
                  ),
                  DropdownMenuItem(
                    value: GameSortCriteria.date,
                    child: Text(
                      GameSortCriteria.dateDisplay,
                      style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                    ), 
                  ),
                  DropdownMenuItem(
                    value: GameSortCriteria.recommend,
                    child: Text(
                      GameSortCriteria.recommendDisplay,
                      style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                    ), 
                  ),
                  DropdownMenuItem(
                    value: GameSortCriteria.price,
                    child: Text(
                      GameSortCriteria.priceDisplay,
                      style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                    ), 
                  ),
                ],
                onChanged: (value) => setState(() {
                  sortCriteria = value!;
                  widget.viewModel.setSortCriteria(value);
                  widget.viewModel.applyFilters();
                }),
              ),
            ),
          ],
        ),

        if (widget.viewModel.state == AdvancedSearchState.loading)
          Container(
            constraints: BoxConstraints(minWidth: 600, minHeight: 320),
            child: Center(child: CircularProgressIndicator()),
          ),

        if (widget.viewModel.state == AdvancedSearchState.success && gameList.isEmpty)
          SizedBox(
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
          ),

        if (widget.viewModel.state == AdvancedSearchState.success && gameList.isNotEmpty)
          Container(
            constraints: BoxConstraints(minHeight: 320),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: spaceCardHorizontal,
                mainAxisSpacing: 16,
                childAspectRatio: 1 / 1.1,
              ),
              itemCount: gameList.length,
              itemBuilder: (context, index) => GameCard(
                game: gameList[index],
                width: cardWidth(context),
                showPrice: true,
              ),
            ),
          ),
      ],
    );
  }
}