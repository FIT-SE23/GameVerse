import 'package:flutter/material.dart';
import 'package:gameverse/config/config.dart';
import 'package:go_router/go_router.dart';

import 'package:gameverse/domain/models/game_model/game_model.dart';

import 'game_price.dart';

class GameCardLong extends StatelessWidget {
  final GameModel game;
  final double height;
  final bool showPrice;

  const GameCardLong({
    super.key,
    required this.game,
    required this.height,
    this.showPrice = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: height,
      child: InkWell(
        hoverColor: Colors.transparent,
        // splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          context.push('/game-details/${game.gameId}');
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [               
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
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
                  ),
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (game.isSale!)
                            if (DateTime.now().isAfter(game.saleStartDate!) && DateTime.now().isBefore(game.saleEndDate!))
                              Container(
                                width: 48,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondary,
                                  // borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '-${game.discountPercent!.toInt()}%',
                                  style: theme.textTheme.bodySmall!.copyWith(
                                    color: AppTheme.oppositeThemeColors(theme.brightness).getText,
                                    fontWeight: FontWeight.bold
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                          const SizedBox(height: 16)
                        ]
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.name,
                  style: theme.textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
                const SizedBox(height: 8),
                if (showPrice)
                  GamePrice(
                    game: game,
                    textStyle: theme.textTheme.bodyMedium!,
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}