import 'package:flutter/material.dart';

import 'package:gameverse/routing/routes.dart';
import 'package:go_router/go_router.dart';

import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:gameverse/config/app_theme.dart';

import 'package:gameverse/ui/shared/widgets/category_chip.dart';

class SidePanel extends StatelessWidget {
  final GameModel game;

  const SidePanel({
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
            game.headerImage.url,
            fit: BoxFit.cover
          ),
        ),

        const SizedBox(height: 8),

        Text(
          game.isSale == true && game.discountPercent != null
              ? '\$${(game.price * (1 - (game.discountPercent! / 100))).toStringAsFixed(2)} VND'
              : '\$${game.price.toStringAsFixed(2)} VND',
          style: theme.textTheme.bodyLarge,
        ),

        const SizedBox(height: 8),

        // 'Buy game' button
        SizedBox(
          width: double.infinity,
          height: 36,
          child: ElevatedButton(
            style: theme.elevatedButtonTheme.style,
            onPressed: () => context.push(Routes.transactions),
            child: Text(
              'Buy game',
              style: theme.textTheme.bodyLarge!.copyWith(color: AppTheme.oppositeThemeColors(theme.brightness).getText, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // 'Add to cart', 'Add to wishlist' and 'Upvote' button
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Tooltip(
                message: 'Add to cart',
                child: ElevatedButton(
                  style: theme.elevatedButtonTheme.style!.copyWith(
                    backgroundColor: WidgetStatePropertyAll(AppTheme.currentThemeColors(theme.brightness).getShell)
                  ),
                  onPressed: () => context.push(Routes.transactions),
                  child: Icon(
                    Icons.add_shopping_cart_rounded,
                    color: AppTheme.currentThemeColors(theme.brightness).getText,
                  )
                ),
              ),
            ),
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
                    Icons.add_box_outlined,
                    color: AppTheme.currentThemeColors(theme.brightness).getText,
                  )
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Tooltip(
                message: 'Upvote',
                child: ElevatedButton(
                  style: theme.elevatedButtonTheme.style!.copyWith(
                    backgroundColor: WidgetStatePropertyAll(AppTheme.currentThemeColors(theme.brightness).getShell)
                  ),
                  onPressed: () => context.push(Routes.transactions),
                  child: Icon(
                    Icons.thumb_up_alt_outlined,
                    color: AppTheme.currentThemeColors(theme.brightness).getText,
                  )
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Text(
              'Upvote',
              style: theme.textTheme.bodyLarge,
            ),
            Spacer(),
            Text(
              '${6750}',
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
              '5/10/2020',
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
        Row(
          children: [
            Text(
              'Platform',
              style: theme.textTheme.bodyLarge,
            ),
            Spacer(),
            Text(
              'Windows',
              style: theme.textTheme.bodyLarge
            )
          ],
        ),

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
              CategoryChip(name: name, onSelect: () {}),
          ]
        ),
      ],
    );
  }
}