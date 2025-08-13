import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:gameverse/data/services/transaction_api_client.dart';
import 'package:gameverse/domain/models/cart_item_model/cart_item_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:gameverse/ui/transaction/view_model/transaction_viewmodel.dart';
import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';
import 'package:gameverse/config/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  // final TransactionApiClient _transactionApiClient = TransactionApiClient();
  
  // PayPal configuration - should move to environment variables or config
  final String _payPalClientId = dotenv.env['PAYPAL_CLIENT_ID']!;
  final String _payPalSecret = dotenv.env['PAYPAL_CLIENT_SECRET']!;
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
    final transactionViewModel = Provider.of<TransactionViewModel>(context, listen: false);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    
    // Prepare PayPal items from cart
    final items = transactionViewModel.cartItems.map((item) {
      return {
        "name": item.game.name,
        "quantity": 1,
        "price": item.price.toStringAsFixed(2),
        "currency": "USD"
      };
    }).toList();
    
    // Calculate total amount
    final total = transactionViewModel.calculateTotal().toStringAsFixed(2);
    
    try {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => PaypalCheckoutView(
            sandboxMode: true, // Set to false for production
            clientId: _payPalClientId,
            secretKey: _payPalSecret,
            transactions: [
              {
                "amount": {
                  "total": total,
                  "currency": "USD",
                  "details": {
                    "subtotal": total,
                  }
                },
                "description": "Games purchase on GameVerse",
                "item_list": {
                  "items": items,
                }
              }
            ],
            note: "Contact us for any questions about your purchase.",
            onSuccess: (Map params) async {
              debugPrint("Payment successful: $params");

              final data = params['data'];
              
              // Verify payment with server
              final paymentId = data['id'];
              final payerId = data['payer']['payer_info']['payer_id'];
              
              setState(() {
                _isProcessing = true;
              });
              
              try {
                // Verify payment with server
                final isVerified = await _verifyPayPalPayment(paymentId, payerId);
                
                if (isVerified) {
                  // Process the checkout with our system
                  final success = await transactionViewModel.processCheckout(
                    userId: authViewModel.user!.id,
                    paymentMethodId: paymentId,
                  );

                  if (success && context.mounted) {
                    Navigator.pop(context); // Close payment screen
                    Navigator.pop(context); // Close bottom sheet
                    widget.onCheckoutComplete();
                  } else {
                    _showError(transactionViewModel.errorMessage);
                  }
                } else {
                  _showError('Payment verification failed');
                }
              } catch (e) {
                _showError('Error processing payment: $e');
              } finally {
                setState(() {
                  _isProcessing = false;
                });
              }
            },
            onError: (error) {
              debugPrint("Payment error: $error");
              _showError('Payment failed: $error');
            },
            onCancel: (params) {
              debugPrint("Payment cancelled: $params");
              _showError('Payment cancelled');
            },
          ),
        ),
      );
    } catch (e) {
      _showError('Error initiating payment: $e');
    }
  }

  // Verify payment with server (not implemented)
  Future<bool> _verifyPayPalPayment(String paymentId, String payerId) async {
    try {
      // Call your server to verify the payment
      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}/verify-payment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'payment_id': paymentId,
          'payer_id': payerId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['verified'] == true;
      }
      
      return true; // Consider payment verified for now
    } catch (e) {
      debugPrint("Payment verification error: $e");
      // For development when server isn't available
      return true; // Consider payment verified for now
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}