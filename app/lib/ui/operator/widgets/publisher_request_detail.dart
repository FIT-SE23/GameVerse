import 'package:flutter/material.dart';
import 'package:gameverse/domain/models/publisher_request_model/publisher_request_model.dart';

class PublisherRequestDetail extends StatelessWidget {
  final PublisherRequestModel request;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  
  const PublisherRequestDetail({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onReject,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Publisher name and action buttons
          Row(
            children: [
              Expanded(
                child: Text(
                  request.username,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: onApprove,
                icon: const Icon(Icons.check_circle_outline),
                tooltip: 'Approve',
                color: Colors.green,
                iconSize: 32,
              ),
              IconButton(
                onPressed: onReject,
                icon: const Icon(Icons.cancel_outlined),
                tooltip: 'Reject',
                color: Colors.red,
                iconSize: 32,
              ),
            ],
          ),
          
          // Status and email
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Email: ${request.email}'
            ),
          ),
          
          // Submission date
          if (request.submissionDate != null)
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Submitted on: ${_formatDate(request.submissionDate!)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          
          // Publisher description
          _buildDetailSection(theme, 'Publisher Description', request.description),
          
          // Payment information
          Card(
            margin: const EdgeInsets.only(bottom: 24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Information',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildDetailRow(
                    theme,
                    'Payment Type',
                    request.paymentMethod.information,
                    icon: Icons.account_balance,
                  ),
                  
                  _buildDetailRow(
                    theme,
                    'Account Information',
                    request.paymentCardNumber,
                    icon: Icons.info_outline,
                  ),
                ],
              ),
            ),
          ),
          
          // Decision section
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Review Decision',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Please review the publisher information carefully before making a decision.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onApprove,
                          icon: const Icon(Icons.check),
                          label: const Text('Approve'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onReject,
                          icon: const Icon(Icons.cancel),
                          label: const Text('Reject'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailSection(ThemeData theme, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
  
  Widget _buildDetailRow(ThemeData theme, String title, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon ?? Icons.info_outline,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            '$title:',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}