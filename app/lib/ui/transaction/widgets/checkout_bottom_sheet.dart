import 'package:flutter/material.dart';
import 'package:gameverse/domain/models/cart_item_model/cart_item_model.dart';
import 'package:provider/provider.dart';
import 'package:gameverse/ui/transaction/view_model/transaction_viewmodel.dart';

class CheckoutBottomSheet extends StatefulWidget {
  final VoidCallback onCheckoutComplete;

  const CheckoutBottomSheet({
    super.key,
    required this.onCheckoutComplete,
  });

  @override
  State<CheckoutBottomSheet> createState() => _CheckoutBottomSheetState();
}

class _CheckoutBottomSheetState extends State<CheckoutBottomSheet> {
  bool _isProcessing = false;
  String method = 'paypal';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final transactionViewModel = Provider.of<TransactionViewModel>(context);
    final total = transactionViewModel.calculateTotal();

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          top: 24,
          left: 16,
          right: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.payment, size: 28, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'Checkout',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (!_isProcessing)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            if (_isProcessing) ...[
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 24),
                    Text('Processing your payment...'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ] else ...[
              // Order summary
              Text(
                'Order Summary',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              Container(
                constraints: const BoxConstraints(maxHeight: 250),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ...transactionViewModel.cartItems.map((item) => ListTile(
                      title: Text(
                        item.game.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: item.game.isSale == true && item.game.discountPercent != null
                          ? Text('${item.game.discountPercent!.toInt()}% off')
                          : null,
                      trailing: Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              
              const Divider(height: 32),
              
              // Price breakdown
              ListTile(
                title: const Text('Subtotal'),
                trailing: Text('\$${transactionViewModel.calculateSubtotal().toStringAsFixed(2)}'),
              ),
              
              if (transactionViewModel.calculateDiscount() > 0)
                ListTile(
                  title: const Text('Discount'),
                  trailing: Text(
                    '-\$${transactionViewModel.calculateDiscount().toStringAsFixed(2)}',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              
              ListTile(
                title: Text(
                  'Total',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Payment method selection
              Text(
                'Payment Method',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // PayPal option
              Card(
                child: RadioListTile(
                  title: Row(
                    children: [
                      Icon(Icons.paypal, color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                      Text('PayPal'),
                    ],
                  ),
                  subtitle: const Text('Pay securely with PayPal'),
                  value: 'paypal',
                  groupValue: method,
                  onChanged: (String? value) {
                    setState(() {
                      method = value!;
                    });
                  },
                )
              ),
              const SizedBox(height: 8),
              Card(
                child: RadioListTile(
                  title: Row(
                    children: [
                      Icon(Icons.credit_card, color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                      Text('VNPay'),
                    ],
                  ),
                  subtitle: const Text('Pay securely with VNPay'),
                  value: 'vnpay',
                  groupValue: method,
                  onChanged: (String? value) {
                    setState(() {
                      method = value!;
                    });
                  },
                )
              ),

              const SizedBox(height: 24),
              
              // Checkout button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _initiatePayPalCheckout(context),
                  icon: const Icon(Icons.payment),
                  label: Text('Pay \$${total.toStringAsFixed(2)} with ${method.toUpperCase()}'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _initiatePayPalCheckout(BuildContext context) async {
    return; // Temporarily disable PayPal checkout for development
  }

}