import 'package:flutter/material.dart';
import 'package:gameverse/config/app_theme.dart';

import 'package:gameverse/domain/models/game_model/game_model.dart';

class GameTitleCard extends StatefulWidget {
  final GameModel game;
  final int index;
  final int selectedIndex;
  final void Function(int) onSelect;

  const GameTitleCard({
    super.key,
    required this.game,
    required this.index,
    required this.selectedIndex,
    required this.onSelect
  });

  @override
  State<GameTitleCard> createState() => _GameTitleCardState();
}

class _GameTitleCardState extends State<GameTitleCard> {
  bool _isHovered = false;

  Widget _rawCard(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Stack(
        fit: StackFit.loose,
        children: [
          Positioned.fill(
            child: Image.network(
              widget.game.headerImage.url,
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
                  end: Alignment(1, 0),
                  colors: 
                  widget.selectedIndex != widget.index
                    ? [
                    theme.scaffoldBackgroundColor.withValues(alpha: 0.5),
                    theme.scaffoldBackgroundColor
                  ] : [
                    getOppositeTheme(theme).scaffoldBackgroundColor.withValues(alpha: 0.5),
                    getOppositeTheme(theme).scaffoldBackgroundColor
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
                    style: widget.selectedIndex != widget.index ? theme.textTheme.titleSmall : getOppositeTheme(theme).textTheme.titleSmall,
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (hovering) => setState(() => _isHovered = hovering),
      onTap: () {
        widget.onSelect(widget.index);
        // context.push('/game-details/${widget.game.appId}');
      },
      child: AnimatedScale(
        scale: _isHovered ? 1.1 : 1,
        duration: Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: _rawCard(context),
      ),
    );
  }
}