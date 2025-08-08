import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:gameverse/config/spacing_config.dart';
// import 'package:gameverse/domain/models/game_model/game_model.dart';

import '../view_model/game_details_viewmodel.dart';
// import 'game_details_layout.dart';

import 'package:gameverse/ui/shared/widgets/page_footer.dart';

import 'package:gameverse/config/spacing_config.dart';
import 'game_media_carousel.dart';
import 'game_info_sidebar.dart';


class GameDetailsScreen extends StatefulWidget {
  final String gameId;

  const GameDetailsScreen({
    super.key,
    required this.gameId,
  });

  @override
  State<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  double _sidebarTop = 127;

  final double _footerHeight = 560;
  final double _sidebarHeight = 300;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GameDetailsViewModel>(context, listen: false).loadGameDetails(widget.gameId);

      _scrollController.addListener(() {
        final scrollOffset = _scrollController.offset;
        final screenHeight = MediaQuery.of(context).size.height;
        final contentHeight = _scrollController.position.maxScrollExtent + screenHeight;

        const double stickyOffset = 127;

        final maxTop = contentHeight - _footerHeight - _sidebarHeight;
        final desiredTop = scrollOffset;

        // Sidebar stays fixed at `stickyOffset`, unless it hits the footer
        final sidebarTop = desiredTop < maxTop - stickyOffset
            ? stickyOffset
            : maxTop - desiredTop;

        setState(() {
          _sidebarTop = sidebarTop;
        });
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final viewModel = Provider.of<GameDetailsViewModel>(context, listen: false);
    // final status = viewModel.state;
    final theme = Theme.of(context);

    const double sidebarWidth = 280;

    return Consumer<GameDetailsViewModel>(
      builder: (context, gameDetailsViewModel, child) {
        if (gameDetailsViewModel.state == GameDetailsState.loading || gameDetailsViewModel.state == GameDetailsState.initial) {
          return SingleChildScrollView(
            controller: _scrollController,
            child: const SizedBox(
              height: 640,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (gameDetailsViewModel.state == GameDetailsState.error) {
          return SingleChildScrollView(
            controller: _scrollController,
            child: SizedBox(
              height: 640,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(gameDetailsViewModel.errorMessage),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => gameDetailsViewModel.loadGameDetails(widget.gameId),
                      child: const Text('Retry'),
                    )
                  ],
                ),
              )
            ),
          );
        } else {
          // state == success
          return Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      // height: 2000,
                      child: Stack(
                        children: [
                          // Game's key art
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Image.network(
                              gameDetailsViewModel.gameDetail!.headerImage,
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
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 64),
                                      Text(
                                        gameDetailsViewModel.gameDetail!.name,
                                        style: theme.textTheme.displayLarge,
                                      ),
                    
                                      const SizedBox(height: 32),
                                      
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                if (gameDetailsViewModel.gameDetail!.media != null)
                                                  if (gameDetailsViewModel.gameDetail!.media!.isNotEmpty)
                                                    Column(
                                                      children: [
                                                        GameMediaCarousel(media: gameDetailsViewModel.gameDetail!.media!),
                                                        const SizedBox(height: 32),
                                                      ],
                                                    ),
                                                Text(
                                                  'About this game',
                                                  style: theme.textTheme.displayMedium
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  gameDetailsViewModel.gameDetail!.description,
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
                    
                                          const SizedBox(width: 32 + sidebarWidth),
                                        ],
                                      ),
                    
                                      const SizedBox(height: 96), // Extra space before footer
                                    ],
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    PageFooter(),
                  ],
                ),
              ),

              Positioned(
                top: _sidebarTop,
                right: negativeSpaceWidth(context),
                child: SizedBox(
                  width: sidebarWidth,
                  child: GameInfoSidebar(game: gameDetailsViewModel.gameDetail!),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}