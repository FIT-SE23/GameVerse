import 'package:flutter/material.dart';
import 'package:gameverse/ui/transaction/view_model/transaction_viewmodel.dart';
import 'package:provider/provider.dart';


import 'package:gameverse/routing/routes.dart';
import 'package:gameverse/ui/game_detail/widgets/add_to_cart_button.dart';
import 'package:go_router/go_router.dart';

import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:gameverse/config/app_theme.dart';
import 'package:gameverse/ui/game_detail/widgets/game_download_button.dart';
import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';

import 'package:gameverse/ui/shared/widgets/category_chip.dart';

class GameInfoSidebar extends StatelessWidget {
  final GameModel game;

  const GameInfoSidebar({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            game.headerImage,
            fit: BoxFit.cover
          ),
        ),

        const SizedBox(height: 8),

        Text(
          game.isSale == true && game.discountPercent != null
              ? '${(game.price * (1 - (game.discountPercent! / 100))).toInt()} VND'
              : '${game.price.toInt()} VND',
          style: theme.textTheme.bodyLarge,
        ),

        const SizedBox(height: 8),
        // If game is not owned by user, show 'Buy game' button and other buttons
        if (!game.isOwned)
        ...[
          // 'Buy game' button
          SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton(
              style: theme.elevatedButtonTheme.style,
              onPressed: () => {
                if (Provider.of<AuthViewModel>(context, listen: false).status == AuthStatus.unauthenticated) {
                  context.push(Routes.login),
                } else {
                  Provider.of<TransactionViewModel>(context, listen: false)
                      .addToCart(game),
                  context.push(Routes.transactions),
                }
              },
              child: Text(
                'Buy game',
                style: theme.textTheme.bodyLarge!.copyWith(color: AppTheme.oppositeThemeColors(theme.brightness).getText, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // 'Add to cart', 'Add to wishlist' and 'Recommend' button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: AddToCartButton(game: game, context: context)),
              const SizedBox(width: 8),
              Expanded(
                child: Tooltip(
                  message: 'Add to wishlist',
                  child: ElevatedButton(
                    style: theme.elevatedButtonTheme.style!.copyWith(
                      backgroundColor: WidgetStatePropertyAll(AppTheme.currentThemeColors(theme.brightness).getShell)
                    ),
                    onPressed: () => context.push(Routes.transactions),
                    child: Icon(
                      Icons.bookmark_add_outlined,
                      color: AppTheme.currentThemeColors(theme.brightness).getText,
                    )
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Tooltip(
                  message: 'Go to forum',
                  child: ElevatedButton(
                    style: theme.elevatedButtonTheme.style!.copyWith(
                      backgroundColor: WidgetStatePropertyAll(AppTheme.currentThemeColors(theme.brightness).getShell)
                    ),
                    onPressed: () => context.push('${Routes.forumPosts}/${game.gameId}/${Uri.encodeComponent(game.name)}'),
                    child: Icon(
                      Icons.forum_outlined,
                      color: AppTheme.currentThemeColors(theme.brightness).getText,
                    )
                  ),
                ),
              ),
            ],
          ),
        ] else
        ...[
          // If game is owned, show download button
          GameDownloadButton(game: game),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: Tooltip(
                    message: 'Recommend',
                    child: ElevatedButton(
                      style: theme.elevatedButtonTheme.style!.copyWith(
                        backgroundColor: WidgetStatePropertyAll(AppTheme.currentThemeColors(theme.brightness).getShell)
                      ),
                      onPressed: () => {
                        // Provider.of<GameDetailsViewModel>(context, listen: false)
                        //   .recommendGame(game.gameId),
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Recommended ${game.name} successfully!'),
                            duration: const Duration(seconds: 2),
                          ),
                        ),
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            color: AppTheme.currentThemeColors(theme.brightness).getText,
                          ),
                        ],
                      )
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Not recommend button
                Expanded(
                  child: Tooltip(
                    message: 'Not Recommend',
                    child: ElevatedButton(
                      style: theme.elevatedButtonTheme.style!.copyWith(
                        backgroundColor: WidgetStatePropertyAll(AppTheme.currentThemeColors(theme.brightness).getShell)
                      ),
                      onPressed: () => {
                        // Provider.of<GameDetailsViewModel>(context, listen: false)
                        //   .notrecommendGame(game.gameId),
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Not Recommended ${game.name} successfully!'),
                            duration: const Duration(seconds: 2),
                          ),
                        ),
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.thumb_down_alt_outlined,
                            color: AppTheme.currentThemeColors(theme.brightness).getText,
                          ),
                        ],
                      )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),

        Row(
          children: [
            Text(
              'Recommend',
              style: theme.textTheme.bodyLarge,
            ),
            Spacer(),
            Text(
              '${game.recommended}',
              style: theme.textTheme.bodyLarge!.copyWith(color: AppTheme.currentThemeColors(theme.brightness).getCyan)
            )
          ],
        ),
        Row(
          children: [
            Text(
              'Release date',
              style: theme.textTheme.bodyLarge,
            ),
            Spacer(),
            Text(
              game.releaseDate.toString().split(' ')[0],
              style: theme.textTheme.bodyLarge
            )
          ],
        ),
        Row(
          children: [
            Text(
              'Publisher',
              style: theme.textTheme.bodyLarge,
            ),
            Spacer(),
            Text(
              'Square Enix',
              style: theme.textTheme.bodyLarge
            )
          ],
        ),
        // Row(
        //   children: [
        //     Text(
        //       'Platform',
        //       style: theme.textTheme.bodyLarge,
        //     ),
        //     Spacer(),
        //     Text(
        //       'Windows',
        //       style: theme.textTheme.bodyLarge
        //     )
        //   ],
        // ),

        const SizedBox(height: 16),

        Text(
          'Categories',
          style: theme.textTheme.bodyLarge
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (String name in game.categories.map((e) => e.name))
              if (name.isNotEmpty)
                CategoryChip(
                  name: name, 
                  onSelect: () {
                    context.push('${Routes.advancedSearch}?categories=$name');
                  }
                ),
          ]
        ),
      ],
    );
  }
}