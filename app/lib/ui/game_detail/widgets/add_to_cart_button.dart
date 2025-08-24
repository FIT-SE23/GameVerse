import 'package:flutter/material.dart';
import 'package:gameverse/config/config.dart';
import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:gameverse/ui/transaction/view_model/transaction_viewmodel.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:go_router/go_router.dart';
import 'package:gameverse/routing/routes.dart';

class AddToCartButton extends StatelessWidget {
  final GameModel game;
  final BuildContext context;

  const AddToCartButton({
    super.key,
    required this.game,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Consumer<TransactionViewModel>(
      builder: (context, transactionViewModel, _) {
        final isInCart = transactionViewModel.isGameInCart(game.gameId);

        if (isInCart) {
          return Tooltip(
            message: 'Remove from cart',
            child: ElevatedButton(
              onPressed: () => _removeFromCart(context, transactionViewModel),
              style: theme.elevatedButtonTheme.style!.copyWith(
                // Use different color if game is already in cart
                backgroundColor: WidgetStatePropertyAll(
                  AppTheme.oppositeThemeColors(theme.brightness).getShell,
                ),
              ),
              child: Icon(
                Icons.shopping_cart,
                color: AppTheme.oppositeThemeColors(theme.brightness).getText,
              ),
            ),
          );
        }

        return Tooltip(
          message: 'Add to cart',
          child: ElevatedButton(
            key: ValueKey('add_to_cart_button'),
            onPressed: () => 
            {
              if (Provider.of<AuthViewModel>(context, listen: false).status == AuthStatus.unauthenticated) {
                context.push(Routes.login),
              } else {
                _addToCart(context, transactionViewModel),
              }
            },
            style: theme.elevatedButtonTheme.style!.copyWith(
              backgroundColor: WidgetStatePropertyAll(AppTheme.currentThemeColors(theme.brightness).getShell)
            ),
            child: Icon(
              Icons.add_shopping_cart,
              color: AppTheme.currentThemeColors(theme.brightness).getText,
            ),
          ),
        );
      },
    );
  }

  void _addToCart(BuildContext context, TransactionViewModel viewModel) {
    viewModel.addToCart(game);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${game.name} successfully added to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () => context.push('/transactions'),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _removeFromCart(BuildContext context, TransactionViewModel viewModel) {
    viewModel.removeFromCart(game.gameId);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${game.name} successfully removed from cart'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }
}