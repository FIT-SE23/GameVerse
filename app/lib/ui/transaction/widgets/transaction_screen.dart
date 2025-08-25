import 'package:flutter/material.dart';
import 'package:gameverse/domain/models/payment_method_model/payment_method_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:gameverse/ui/transaction/view_model/transaction_viewmodel.dart';
import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';
import 'package:gameverse/ui/transaction/widgets/checkout_bottom_sheet.dart';
import 'package:gameverse/ui/transaction/widgets/cart_item_card.dart';
import 'package:gameverse/ui/transaction/widgets/transaction_card.dart';
import 'package:gameverse/ui/shared/widgets/empty_state.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Load data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final transactionViewModel = Provider.of<TransactionViewModel>(context, listen: false);
      if (authViewModel.status == AuthStatus.authenticated) {
        transactionViewModel.loadCartItems(authViewModel.accessToken!);
        transactionViewModel.loadUserTransactions(authViewModel.accessToken!);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionViewModel = Provider.of<TransactionViewModel>(context);
    
    return Scaffold(
      appBar: AppBar(
        // Hide the back button
        automaticallyImplyLeading: false,
        title: Center(child: const Text('Transactions')),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart),
                  const SizedBox(width: 8),
                  const Text('Cart'),
                  if (transactionViewModel.cartItems.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${transactionViewModel.cartItems.length}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onError,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history),
                  SizedBox(width: 8),
                  Text('History'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: _buildCartTab(context),
          ),
          SingleChildScrollView(
            child: _buildHistoryTab(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCartTab(BuildContext context) {
    final transactionViewModel = Provider.of<TransactionViewModel>(context);
    final cartItems = transactionViewModel.cartItems;
    
    if (transactionViewModel.state == TransactionViewState.loading) {
      return const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    
    if (cartItems.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: EmptyState(
          icon: Icons.shopping_cart_outlined,
          title: 'Your Cart is Empty',
          message: 'Browse and add games to your cart to purchase them',
          actionLabel: 'Browse Games',
          onAction: () => context.go('/'),
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Cart items
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final cartItem = cartItems[index];
              return CartItemCard(
                cartItem: cartItem,
                onRemove: () => transactionViewModel.removeFromCart(cartItem.game.gameId),
              );
            },
          ),
          
          const SizedBox(height: 16),
          
          // Cart summary
          _buildCartSummary(context),
        ],
      ),
    );
  }

  Widget _buildCartSummary(BuildContext context) {
    final theme = Theme.of(context);
    final transactionViewModel = Provider.of<TransactionViewModel>(context);
    final subtotal = transactionViewModel.calculateSubtotal();
    final discount = transactionViewModel.calculateDiscount();
    final total = transactionViewModel.calculateTotal();
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal', style: theme.textTheme.bodyLarge),
                Text('$subtotal VND', style: theme.textTheme.bodyLarge),
              ],
            ),
            
            if (discount > 0) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Discount', style: theme.textTheme.bodyLarge),
                  Text('-$discount VND',
                      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.green)),
                ],
              ),
            ],
            
            const Divider(height: 24),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', 
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text('$total VND',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    )),
              ],
            ),
            
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                key: ValueKey('checkout_button'),
                onPressed: transactionViewModel.isProcessingCheckout
                    ? null
                    : () => _showCheckoutSheet(context),
                icon: const Icon(Icons.payment),
                label: Text(transactionViewModel.isProcessingCheckout
                    ? 'Processing...'
                    : 'Checkout'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCheckoutSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => CheckoutBottomSheet(
        onCheckoutComplete: () {
          // Switch to history tab when checkout completes
          _tabController.animateTo(1);
        },
      ),
    );
  }

  Widget _buildHistoryTab(BuildContext context) {
    final transactionViewModel = Provider.of<TransactionViewModel>(context);
    final transactions = transactionViewModel.transactions;
    
    if (transactionViewModel.state == TransactionViewState.loading) {
      return const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    
    if (transactions.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: const EmptyState(
          icon: Icons.history,
          title: 'No Transaction History',
          message: 'Your purchase history will appear here',
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return TransactionCard(
            transaction: transaction,
            paymentMethod: PaymentMethodModel(
              paymentMethodId: 'pm_123',
              type: 'banking',
              // check in payment methods to find the name
              information: Provider.of<TransactionViewModel>(context)
                  .paymentMethods
                  .firstWhere((pm) => pm.paymentMethodId == transaction.paymentMethodId)
                  .information,
            )
          );
        },
      ),
    );
  }
}