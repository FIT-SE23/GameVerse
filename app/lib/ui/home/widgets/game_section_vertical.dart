import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/home_viewmodel.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:gameverse/ui/shared/widgets/game_card_long.dart';

// import 'package:gameverse/config/spacing_config.dart';


class GameSectionVertical extends StatefulWidget {
  final String title;
  final List<GameModel> gameList;
  final void Function() onSelect;
  final TextStyle? titleStyle;

  const GameSectionVertical({
    super.key,
    required this.title,
    required this.gameList,
    required this.onSelect,
    this.titleStyle 
  });

  @override
  State<GameSectionVertical> createState() => _GameSectionVerticalState();
}

class _GameSectionVerticalState extends State<GameSectionVertical> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<HomeViewModel>(context, listen: false).loadHomePageData();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context, listen: false);
    final status = viewModel.state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
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
                    onPressed: () => viewModel.loadHomePageData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          )
          
        else if (status == HomeViewState.success && widget.gameList.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              for (final game in widget.gameList)
                GameCardLong(game: game, height: 80)
              // Container(
              //   constraints: BoxConstraints(minHeight: 280),
              //   child: ListView.separated(
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     itemCount: widget.gameList.length,
              //     itemBuilder: (context, index) {
              //       final game = widget.gameList[index];
              //       return GameCardLong(
              //         game: game,
              //         height: 80,
              //       );
              //     },
              //     separatorBuilder: (context, index) => const SizedBox(height: spaceCardHorizontal),
              //   ),
              // ),
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