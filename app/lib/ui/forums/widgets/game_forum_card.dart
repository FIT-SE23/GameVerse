import 'package:flutter/material.dart';
import 'package:gameverse/domain/models/forum_model/forum_model.dart';
import 'package:go_router/go_router.dart';

// import 'package:gameverse/config/app_theme.dart';

class GameForumCard extends StatelessWidget {
  final ForumModel game;

  const GameForumCard({
    super.key,
    required this.game
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        context.push('/forum-posts/${game.gameId}/${Uri.encodeComponent(game.name)}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color
        ),
        height: 120,
        width: double.infinity,
        child: Row(
          children: [           
            // Game Info
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          game.name,
                          style: theme.textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          game.briefDescription,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 16,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Join Discussion',
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // const Spacer(),
                        // Icon(
                        //   Icons.arrow_forward_ios,
                        //   size: 16,
                        //   color: theme.colorScheme.onSurfaceVariant,
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Game Image with gradient opacity
            Expanded(
              flex: 2,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image.network(
                          game.headerImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: const Center(
                                child: Icon(Icons.videogame_asset, size: 32),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                
                    // Gradient overlay from right to left (opacity 1 to 0)
                    Positioned(
                      top: -2,
                      bottom: -2,
                      left: -2,
                      right: -2,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              theme.cardTheme.color!,
                              theme.cardTheme.color!.withValues(alpha: 0.8)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}