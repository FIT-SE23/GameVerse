import 'package:flutter/material.dart';

import 'package:gameverse/domain/models/game_model/game_model.dart';

class GameTitleCard extends StatefulWidget {
  final GameModel game;
  final void Function(GameModel) onSelect;
  const GameTitleCard({
    super.key,
    required this.game,
    required this.onSelect
  });

  @override
  State<GameTitleCard> createState() => _GameTitleCardState();
}

class _GameTitleCardState extends State<GameTitleCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Stack(
        fit: StackFit.loose,
        children: [
          Positioned.fill(
            child: Image.network(
              widget.game.headerImage,
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
            top: -1,
            bottom: -1,
            left: -1,
            right: -1,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-1, 0),
                  end: Alignment(0, 1),
                  colors: [
                    theme.scaffoldBackgroundColor.withValues(alpha: 0.5),
                    theme.scaffoldBackgroundColor
                  ]
                )
              ),
            )
          ),

          Positioned.fill(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.game.name,
                    style: theme.textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
        ]
      )
    );
  }
}