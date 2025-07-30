import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gameverse/config/spacing_config.dart';
// import 'package:gameverse/domain/models/game_model/game_model.dart';

import '../view_model/game_details_viewmodel.dart';

class GameDetailsPanel extends StatefulWidget {
  final String gameId;

  const GameDetailsPanel({
    super.key,
    required this.gameId,
  });

  @override
  State<GameDetailsPanel> createState() => _GameDetailsPanelState();
}

class _GameDetailsPanelState extends State<GameDetailsPanel> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GameDetailsViewModel>(context, listen: false).loadGameDetails(widget.gameId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GameDetailsViewModel>(context, listen: false);
    final status = viewModel.state;
    final theme = Theme.of(context);

    const double keyArtHeight = 640;

    return SizedBox(
      width: double.infinity,
      height: keyArtHeight,
      child: Stack(
        children: [
          // Game's key art
          if (status == GameDetailsState.success)
            Positioned.fill(
              child: Image.network(
                viewModel.gameDetail!.headerImage,
                width: double.infinity,
                height: keyArtHeight,
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
                      const SizedBox(height: 16),
                      
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (viewModel.gameDetail!.screenshots != null)
                                  Text(
                                    'There are screenshots'
                                  )
                                else
                                  Text(
                                    'There is no screenshots'
                                  )
                              ],
                            )
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Text(
                                  viewModel.gameDetail!.briefDescription,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
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