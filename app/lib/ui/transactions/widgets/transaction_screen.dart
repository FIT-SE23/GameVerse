import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:gameverse/ui/transactions/view_model/transaction_viewmodel.dart';
import 'package:gameverse/domain/models/transaction_model/transaction_model.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionViewModel>(context, listen: false).loadUserData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Consumer<TransactionViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wallet Balance Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      size: 48,
                      color: theme.colorScheme.onPrimary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'GameVerse Wallet',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${viewModel.balance.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Quick Actions
              Container(
                margin: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: _ActionCard(
                        title: 'Add Funds',
                        subtitle: 'Top up wallet',
                        icon: Icons.add_circle,
                        color: Colors.green,
                        onTap: () => _showAddFundsDialog(context, viewModel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionCard(
                        title: 'Shopping Cart',
                        subtitle: 'View cart items',
                        icon: Icons.shopping_cart,
                        color: Colors.blue,
                        onTap: () => _tabController.animateTo(1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionCard(
                        title: 'Refunds',
                        subtitle: 'Request a refund',
                        icon: Icons.money_off,
                        color: Colors.purple,
                        onTap: () => _tabController.animateTo(0),
                      ),
                    ),
                  ],
                ),
              ),

              // Stats Cards
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatsCard(
                        title: 'Total Spent',
                        value: '\$${_calculateTotalSpent(viewModel.transactions).toStringAsFixed(2)}',
                        icon: Icons.shopping_bag,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatsCard(
                        title: 'Games Owned',
                        value: '${_countGamePurchases(viewModel.transactions)}',
                        icon: Icons.videogame_asset,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Transaction History
              Center(
                child: Text(
                  'Transaction History',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              _buildHistoryTab(viewModel, theme)
            ]
          );
        },
      ),
    );
  }

  Widget _buildHistoryTab(TransactionViewModel viewModel, ThemeData theme) {
    if (viewModel.state == TransactionState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No purchases yet',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your game purchases will appear here',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _tabController.animateTo(1),
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Browse Games'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: viewModel.transactions.length,
      itemBuilder: (context, index) {
        final transaction = viewModel.transactions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _TransactionCard(transaction: transaction),
        );
      },
    );
  }

  void _showAddFundsDialog(BuildContext context, TransactionViewModel viewModel) {
    final amountController = TextEditingController();
    String selectedMethod = 'Credit Card';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.account_balance_wallet, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              const Text('Add Funds to Wallet'),
            ],
          ),
          content: SizedBox(
            width: 320,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter amount to add:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    prefixText: '\$',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    hintText: '0.00',
                    filled: true,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Payment Method:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).colorScheme.outline),
                  ),
                  child: Column(
                    children: [
                      _PaymentMethodTile(
                        icon: Icons.credit_card,
                        title: 'Credit Card',
                        subtitle: 'Visa, Mastercard, American Express',
                        value: 'Credit Card',
                        groupValue: selectedMethod,
                        onChanged: (value) => setState(() => selectedMethod = value!),
                      ),
                      const Divider(height: 1),
                      _PaymentMethodTile(
                        icon: Icons.payment,
                        title: 'PayPal',
                        subtitle: 'Pay with your PayPal account',
                        value: 'PayPal',
                        groupValue: selectedMethod,
                        onChanged: (value) => setState(() => selectedMethod = value!),
                        iconColor: const Color(0xFF003087),
                      ),
                      const Divider(height: 1),
                      _PaymentMethodTile(
                        icon: Icons.account_balance,
                        title: 'Bank Transfer',
                        subtitle: 'Direct bank account transfer',
                        value: 'Bank Transfer',
                        groupValue: selectedMethod,
                        onChanged: (value) => setState(() => selectedMethod = value!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.security, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Your payment information is encrypted and secure',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: viewModel.isProcessingTransaction ? null : () async {
                final amount = double.tryParse(amountController.text);
                if (amount != null && amount > 0) {
                  Navigator.pop(context);
                  
                  bool success;
                  if (selectedMethod == 'PayPal') {
                    success = await viewModel.addFundsWithPayPal(context, amount);
                  } else {
                    success = await viewModel.addFunds(amount, selectedMethod);
                  }
                  
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success 
                            ? 'Added \$${amount.toStringAsFixed(2)} to your wallet!'
                            : viewModel.errorMessage),
                        backgroundColor: success ? Colors.green : Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              style: selectedMethod == 'PayPal'
                  ? ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003087),
                      foregroundColor: Colors.white,
                    )
                  : null,
              child: viewModel.isProcessingTransaction
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(selectedMethod == 'PayPal' ? 'Pay with PayPal' : 'Add Funds'),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTotalSpent(List<TransactionModel> transactions) {
    return transactions
        .where((t) => t.senderId == 'current_user')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  int _countGamePurchases(List<TransactionModel> transactions) {
    return transactions
        .where((t) => t.description?.contains('Purchase:') == true)
        .length;
  }
}

// Reuse existing widget patterns from other screens
class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatsCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    value,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;
  final Color? iconColor;

  const _PaymentMethodTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      secondary: Icon(icon, color: iconColor),
      title: Text(title),
      subtitle: Text(subtitle),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncoming = transaction.receiverId == 'current_user';
    final isGamePurchase = transaction.description?.contains('Purchase:') == true;

    IconData icon;
    Color iconColor;
    String amountText;

    if (isIncoming) {
      icon = Icons.add_circle;
      iconColor = Colors.green;
      amountText = '+\$${transaction.amount.toStringAsFixed(2)}';
    } else {
      icon = isGamePurchase ? Icons.videogame_asset : Icons.remove_circle;
      iconColor = isGamePurchase ? theme.colorScheme.primary : Colors.red;
      amountText = '-\$${transaction.amount.toStringAsFixed(2)}';
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(
          transaction.description ?? 'Transaction',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(_formatDate(transaction.transactionDate)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                transaction.status.toUpperCase(),
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        trailing: Text(
          amountText,
          style: theme.textTheme.titleLarge?.copyWith(
            color: iconColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}