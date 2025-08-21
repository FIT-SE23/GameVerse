import 'package:flutter/material.dart';
import 'package:gameverse/data/repositories/transaction_repository.dart';
import 'package:gameverse/domain/models/payment_method_model/payment_method_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:gameverse/ui/publisher/view_model/publisher_viewmodel.dart';
import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';

class PublisherRegistrationScreen extends StatefulWidget {
  const PublisherRegistrationScreen({super.key});

  @override
  State<PublisherRegistrationScreen> createState() => _PublisherRegistrationScreenState();
}

class _PublisherRegistrationScreenState extends State<PublisherRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _paymentInfoController = TextEditingController();
  String _selectedPaymentType = 'PayPal'; // Default value
  bool _isLoading = false;
  
  // Payment method types and their hints
  final Map<String, String> _paymentMethods = {
    'PayPal': 'Enter your PayPal email address',
    'VNPay': 'Enter your VNPay account number',
  };
  
  @override
  void dispose() {
    _descriptionController.dispose();
    _paymentInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Center(
                child: Text(
                  'Publisher Registration',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 32),
                    _buildRegistrationForm(context),
                    const SizedBox(height: 32),
                    _buildRequirementsSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.storefront,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Become a GameVerse Publisher',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Share your games with the world',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegistrationForm(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Publisher Information',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Publisher Description *',
                hintText: 'Tell us about your company or yourself as a developer',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a description';
                }
                if (value.trim().length < 20) {
                  return 'Description must be at least 20 characters';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 24),
            
            // Payment method selection
            Text(
              'Payment Method *',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            
            // Payment type selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select payment type:',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Radio buttons for payment methods
                  ..._paymentMethods.keys.map((String method) {
                    return RadioListTile<String>(
                      title: Text(method),
                      value: method,
                      groupValue: _selectedPaymentType,
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            _selectedPaymentType = value;
                            // Clear the text field when switching payment types
                            _paymentInfoController.clear();
                          });
                        }
                      },
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    );
                  }),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Payment information field
            TextFormField(
              controller: _paymentInfoController,
              decoration: InputDecoration(
                labelText: '$_selectedPaymentType Information *',
                hintText: _paymentMethods[_selectedPaymentType],
                prefixIcon: const Icon(Icons.payment),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your payment information';
                }
                
                // Validate based on payment type
                if (_selectedPaymentType == 'PayPal') {
                  // Simple email validation
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                } else if (_selectedPaymentType == 'VNPay') {
                  // Basic number validation for VNPay
                  if (value.length < 8) {
                    return 'Please enter a valid VNPay account number';
                  }
                }
                
                return null;
              },
            ),
            
            const SizedBox(height: 32),
            
            // Submit button
            Consumer2<PublisherViewModel, AuthViewModel>(
              builder: (context, publisherViewModel, authViewModel, _) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading || authViewModel.user == null 
                        ? null 
                        : () => _handleSubmit(context, publisherViewModel, authViewModel),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Apply to Become Publisher'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementsSection(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                'Requirements',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRequirement(context, 'Valid GameVerse account'),
          _buildRequirement(context, 'Detailed company/developer description'),
          _buildRequirement(context, 'Valid payment method for revenue sharing'),
          
          const SizedBox(height: 16),
          
          Text(
            'Your application will be reviewed by our team within 3-5 business days.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirement(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit(
    BuildContext context,
    PublisherViewModel publisherViewModel,
    AuthViewModel authViewModel,
  ) async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      // Create payment method model
      final paymentMethod = Provider.of<TransactionRepository>(context, listen: false).
        paymentMethods.firstWhere(
          (method) => method.information == _selectedPaymentType,
          orElse: () => PaymentMethodModel(
            paymentMethodId: '',
            type: _selectedPaymentType,
            information: _paymentInfoController.text.trim(),
          ),
        );

      final success = await publisherViewModel.registerAsPublisher(
        userId: authViewModel.user!.id,
        description: _descriptionController.text.trim(),
        paymentMethod: paymentMethod,
        paymentCardNumber: _paymentInfoController.text.trim(),
      );

      if (!context.mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Publisher application submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.push('/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(publisherViewModel.errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}