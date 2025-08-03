import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:gameverse/config/spacing_config.dart';

import '../view_model/home_viewmodel.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:gameverse/ui/home/widgets/game_title_card.dart';
import 'package:gameverse/ui/home/widgets/game_card_big.dart';

class GameSectionFancy extends StatefulWidget {
  final String title;
  final List<GameModel> gameList;
  
  const GameSectionFancy({super.key, required this.title, required this.gameList});

  @override
  State<GameSectionFancy> createState() => _GameSectionFancyState();
}

class _GameSectionFancyState extends State<GameSectionFancy> {
  int currentGameIndex = 0;

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
    final theme = Theme.of(context);

    const double defaultHeight = 500;

    return SizedBox(
      width: double.infinity,
      height: backgroundKeyArtHeight,
      child: Stack(
        fit: StackFit.loose,
        children: [
          // Background key art
          if (status == HomeViewState.success && widget.gameList.isNotEmpty)
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 1000),
                transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(
                  opacity: animation,
                  child: child
                ),
                child: Image.network(
                  widget.gameList[currentGameIndex].headerImage,
                  key: ValueKey(widget.gameList[currentGameIndex].headerImage),
                  width: double.infinity,
                  height: 640,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / 
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Gradient
          Positioned(
            top: 0,
            bottom: -2,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0, -1),
                  end: Alignment(0, 0.8),
                  colors: [
                    theme.scaffoldBackgroundColor.withValues(alpha: 0.6),
                    theme.scaffoldBackgroundColor
                  ]
                )
              ),
            )
          ),

          // Game section
          Padding(
            padding: getNegativeSpacePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 64),
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.displayLarge
                ),
                const SizedBox(height: 16),
            
                if (status == HomeViewState.loading)
                  const SizedBox(
                    height: defaultHeight,
                    child: Center(child: CircularProgressIndicator()),
                  )
                  
                else if (status == HomeViewState.error)
                  SizedBox(
                    height: defaultHeight,
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
                  // Current chosen game
                  SizedBox(
                    width: double.infinity,
                    height: defaultHeight,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: GameCardBig(game: widget.gameList[currentGameIndex], height: defaultHeight),
                        ),
                  
                        const SizedBox(width: 32),
                        
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              widget.gameList.length,
                              (int index) => GameTitleCard(
                                  game: widget.gameList[index],
                                  index: index,
                                  selectedIndex: currentGameIndex,
                                  onSelect: (index) {
                                    if (index == currentGameIndex) {
                                      context.push('/game-details/${widget.gameList[index].gameId}');
                                    } else {
                                      setState(() => currentGameIndex = index);
                                    }
                                  }
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                  )
            
                else
                  const SizedBox(
                    height: defaultHeight,
                    child: Center(child: Text('Something went wrong :(')),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}