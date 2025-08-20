import 'package:flutter/material.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';

class GameSearchResultItem extends StatelessWidget {
  final GameModel game;
  final VoidCallback onTap;
  final SearchController controller;

  const GameSearchResultItem({
    required this.game,
    required this.onTap,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: () {
        controller.closeView(game.name);
        onTap();
      },
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          width: 70,
          height: 40,
          child: Image.network(
                  game.headerImage,
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
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                )
        ),
      ),
      title: Text(
        game.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: game.categories.isNotEmpty
          ? Wrap(
              spacing: 2,
              runSpacing: 2,
              children: game.categories
                  .map((category) => Chip(
                        padding: const EdgeInsets.all(1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        label: Text(category.name),
                        backgroundColor: theme.colorScheme.surfaceContainerLowest,
                        labelStyle: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ))
                  .toList(),
            )
          : null,
    );
  }
}