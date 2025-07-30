import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'dart:math';

import 'package:gameverse/domain/models/game_model/game_model.dart';

class GameCardBig extends StatelessWidget {
  final GameModel game;
  final double height;

  const GameCardBig({
    super.key,
    required this.game,
    required this.height,
  });

  Widget _rawCard(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = max(width / (16 / 9), 440);
                      
        return SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (Widget child, Animation<double> animation)
                    => FadeTransition(
                      opacity: animation,
                      child: child,
                  ),
                  child: Image.network(
                    width: double.infinity,
                    height: height,
                    key: ValueKey(game.headerImage),
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
          
              Positioned(
                top: -1,
                bottom: -1,
                left: -1,
                right: -1,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-0.6, 0),
                      end: Alignment(1, 0),
                      colors: [
                        theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
                        theme.scaffoldBackgroundColor.withValues(alpha: 0)
                      ]
                    )
                  ),
                ),
              ),
                      
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                width: width > 400 ? 400 : width - 32,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(
                    opacity: animation,
                    child: child
                  ),
                  child: Padding(
                    key: ValueKey(game),
                    padding: EdgeInsets.only(left: 32, bottom: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          game.name,
                          style: theme.textTheme.displayLarge!.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          game.price != null 
                            ? '${(game.price!['final'] as int) / 100} VND' 
                            : 'Free to Play',
                          style: theme.textTheme.displaySmall!.copyWith(fontSize: 18),
                        ),
                        // const SizedBox(height: 20),
                        // Text(
                        //   game.briefDescription,
                        //   style: theme.textTheme.displaySmall,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('/game-details/${game.appId}');
      },
      child: _rawCard(context),
    );
  }
}