import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:gameverse/domain/models/game_model/game_model.dart';

class GameCard extends StatelessWidget {
  final GameModel game;
  // a function like "Provider.of<HomeViewModel>(context, listen: false).selectGame"
  // is passed so that it will be called when tapping on the game card
  final void Function(GameModel) onSelect;

  const GameCard({
    super.key,
    required this.game,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 16),
      // decoration: BoxDecoration(
      //   color: theme.cardTheme.color,
      //   borderRadius: BorderRadius.circular(8),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withValues(alpha: 0.1),
      //       blurRadius: 8,
      //       offset: const Offset(0, 2),
      //     ),
      //   ],
      // ),
      // clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Provider.of<HomeViewModel>(context, listen: false).selectGame(game);
          onSelect(game);
          // Navigator.pushNamed(context, '/gameDetails', arguments: game.appId);
          context.push('/game-details/${game.appId}');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game image
            AspectRatio(
              aspectRatio: 16 / 9,
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

            // Discount badge (if available)
            if (game.description.contains('Save'))
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  // borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    game.description,
                    style: TextStyle(
                      color: theme.colorScheme.onSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            
            // Game details
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Game title
                  Text(
                    game.name,
                    style: theme.textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  // Price
                  Text(
                    game.price != null 
                        ? '${(game.price!['final'] as int) / 100} VND' 
                        : 'Free to Play',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}