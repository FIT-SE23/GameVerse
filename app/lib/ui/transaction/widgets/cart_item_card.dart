import 'package:flutter/material.dart';
import 'package:gameverse/domain/models/cart_item_model/cart_item_model.dart';
import 'package:go_router/go_router.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel cartItem;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.cartItem,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final game = cartItem.game;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/game-details/${game.gameId}'),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Game image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  game.headerImage,
                  width: 100,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 100,
                    height: 60,
                    color: theme.colorScheme.onSurfaceVariant,
                    child: Icon(Icons.games,
                        color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Game details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      game.briefDescription,
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Price
                    Row(
                      children: [
                        if (game.isSale == true && game.discountPercent != null
                            && DateTime.now().isAfter(game.saleStartDate!)
                            && DateTime.now().isBefore(game.saleEndDate!)
                        ) ...[
                          Text(
                            '${game.price.toStringAsFixed(2)} VND',
                            style: theme.textTheme.bodySmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: theme.colorScheme.error),
                            ),
                            child: Text(
                              '-${game.discountPercent!.toInt()}%',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          '${cartItem.price.toStringAsFixed(2)} VND',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Remove button
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline),
                color: theme.colorScheme.error,
                tooltip: 'Remove from cart',
              ),
            ],
          ),
        ),
      ),
    );
  }
}