import 'package:flutter/material.dart';
import 'package:gameverse/ui/settings/view_model/settings_viewmodel.dart';
import 'package:provider/provider.dart';

import '../view_model/home_viewmodel.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:gameverse/ui/shared/widgets/game_card.dart';

import 'package:gameverse/config/spacing_config.dart';


class GameSectionHorizontal extends StatefulWidget {
  final String title;
  final List<GameModel> gameList;
  final void Function() onSelect;
  final TextStyle? titleStyle;
  final Key? scrollBarKey;

  const GameSectionHorizontal({
    super.key,
    required this.title,
    required this.gameList,
    required this.onSelect,
    this.titleStyle,
    this.scrollBarKey
  });

  @override
  State<GameSectionHorizontal> createState() => _GameSectionHorizontalState();
}

class _GameSectionHorizontalState extends State<GameSectionHorizontal> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context, listen: false);
    final status = viewModel.state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: widget.onSelect,
          child: Text(
            widget.title,
            style: widget.titleStyle ?? Theme.of(context).textTheme.displayLarge
          ),
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

        else if (status == HomeViewState.success && widget.gameList.isEmpty)
          SizedBox(
            height: 200,
            child: Center(
              child: Text(
                'No games here'
              )
            ),
          )
          
        else if (status == HomeViewState.success && widget.gameList.isNotEmpty)
          Column(
            children: [
              SizedBox(
                height: 300,
                child: Scrollbar(
                  key: widget.scrollBarKey,
                  thumbVisibility: false,
                  scrollbarOrientation: ScrollbarOrientation.bottom,
                  thickness: 8,
                  radius: const Radius.circular(0),
                  controller: _scrollController,
                  child: ListView.separated(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.gameList.length,
                    itemBuilder: (context, index) {
                      final game = widget.gameList[index];
                      return GameCard(
                        game: game,
                        width: cardWidth(context),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(width: spaceCardHorizontal),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (cardPerRow(context) < widget.gameList.length)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '← Scroll to see more →',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                )
            ],
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