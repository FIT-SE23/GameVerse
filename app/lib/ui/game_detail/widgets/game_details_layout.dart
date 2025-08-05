import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gameverse/config/spacing_config.dart';
// import 'package:gameverse/domain/models/game_model/game_model.dart';

import '../view_model/game_details_viewmodel.dart';
import 'game_media_carousel.dart';
import 'side_panel.dart';

class GameDetailsLayout extends StatefulWidget {
  final String gameId;

  const GameDetailsLayout({
    super.key,
    required this.gameId,
  });

  @override
  State<GameDetailsLayout> createState() => _GameDetailsLayoutState();
}

class _GameDetailsLayoutState extends State<GameDetailsLayout> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<GameDetailsViewModel>(context, listen: false).loadGameDetails(widget.gameId);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GameDetailsViewModel>(context, listen: false);
    final status = viewModel.state;
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      // height: 2000,
      child: Stack(
        children: [
          // Game's key art
          if (status == GameDetailsState.success)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.network(
                viewModel.gameDetail!.headerImage,
                width: double.infinity,
                height: backgroundKeyArtHeight,
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
            
          // Gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: backgroundKeyArtHeight + 2,
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

          Padding(
            padding: getNegativeSpacePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (status == GameDetailsState.loading)
                  const SizedBox(
                    height: 640,
                    child: Center(child: CircularProgressIndicator()),
                  )
                
                else if (status == GameDetailsState.error)
                  SizedBox(
                    height: 640,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(viewModel.errorMessage),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => viewModel.loadGameDetails(widget.gameId),
                            child: const Text('Retry'),
                          )
                        ],
                      ),
                    )
                  )
                
                else if (status == GameDetailsState.success)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 64),
                      Text(
                        viewModel.gameDetail!.name,
                        style: theme.textTheme.displayLarge,
                      ),

                      const SizedBox(height: 32),
                      
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GameMediaCarousel(media: <String>[]),
                                const SizedBox(height: 32),
                                Text(
                                  'About this game',
                                  style: theme.textTheme.displayMedium
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  // 'Welcome to the official description of this game. This is where you can talk about the gameplay, the story, the mechanics, or anything else that makes your game unique. Feel free to elaborate on the features, style, or goals—whatever helps players understand what they\'re about to dive into.\n\nThis is the description of this game. Here you can write about what the game is, what players can expect, and any key features or gameplay elements. Use this section to give a brief overview that captures interest and explains what makes the game worth playing.\n\nThis section is reserved for an exciting and detailed summary of the game. Here, you\'ll describe what players can do, what makes the game fun, and why they should try it. Think of this as your game\'s elevator pitch—but longer.\n\nThis is where the game description goes. Talk about the world, the characters, the gameplay, or just write something to fill space until the real text is ready. Make it sound cool—or don\'t, it\'s just a placeholder!',
                                  viewModel.gameDetail!.description,
                                  style: theme.textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 32),
                                Text(
                                  'System requirements',
                                  style: theme.textTheme.displayMedium
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Center(),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 1,
                                      child: Center(),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ),

                          const SizedBox(width: 32),

                          Expanded(
                            flex: 3,
                            child: SidePanel(game: viewModel.gameDetail!),
                          )
                        ],
                      ),

                      const SizedBox(height: 96), // Extra space before footer
                    ],
                  )
            
                else
                  const SizedBox(
                    height: 640,
                    child: Center(
                      child: Text(
                        'Something went wrong :('
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}