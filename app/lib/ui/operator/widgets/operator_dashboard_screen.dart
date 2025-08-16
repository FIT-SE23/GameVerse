import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gameverse/ui/operator/view_model/operator_viewmodel.dart';
import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';
import 'package:gameverse/domain/models/game_request_model/game_request_model.dart';
import 'package:gameverse/ui/operator/widgets/game_request_detail.dart';
import 'package:gameverse/ui/operator/widgets/feedback_dialog.dart';
import 'package:gameverse/ui/shared/widgets/empty_state.dart';
import 'package:gameverse/ui/shared/widgets/loading_overlay.dart';

class OperatorDashboardScreen extends StatefulWidget {
  const OperatorDashboardScreen({Key? key}) : super(key: key);

  @override
  State<OperatorDashboardScreen> createState() => _OperatorDashboardScreenState();
}

class _OperatorDashboardScreenState extends State<OperatorDashboardScreen> {
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      final operatorViewModel = Provider.of<OperatorViewModel>(context, listen: false);
      await operatorViewModel.loadPendingRequests();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final operatorViewModel = Provider.of<OperatorViewModel>(context);
    final theme = Theme.of(context);
    
    // Check if user is authorized as an operator
    if (authViewModel.status != AuthStatus.authenticated || authViewModel.user?.type != 'operator') {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Operator Dashboard'),
        ),
        body: const Center(
          child: Text('You do not have permission to access this page.'),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Operator Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: _buildContent(context, operatorViewModel, theme),
      ),
    );
  }
  
  Widget _buildContent(BuildContext context, OperatorViewModel viewModel, ThemeData theme) {
    // Handle error state
    if (viewModel.state == OperatorViewState.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading data',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.errorMessage,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      );
    }
    
    // Empty state when there are no pending requests
    if (viewModel.pendingRequests.isEmpty && viewModel.state == OperatorViewState.success) {
      return Center(
        child: EmptyState(
          icon: Icons.check_circle_outline,
          title: 'No Pending Requests',
          message: 'There are no game publishing requests waiting for review.',
          actionLabel: 'Refresh',
          onAction: _loadData,
        ),
      );
    }
    
    // Main content with responsive layout
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Request list (left side)
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Pending Requests (${viewModel.pendingRequests.length})',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: viewModel.pendingRequests.length,
                  itemBuilder: (context, index) {
                    final request = viewModel.pendingRequests[index];
                    return _buildRequestCard(context, request, viewModel);
                  },
                ),
              ),
            ],
          ),
        ),
        
        // Vertical divider
        const VerticalDivider(width: 1),
        
        // Detail view (right side)
        Expanded(
          flex: 5,
          child: viewModel.hasSelectedRequest
              ? GameRequestDetail(
                  request: viewModel.selectedRequest!,
                  onApprove: () => _showApprovalDialog(context, viewModel),
                  onReject: () => _showRejectionDialog(context, viewModel),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.gamepad,
                        size: 80,
                        color: theme.colorScheme.primary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Select a request to review',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
  
  Widget _buildRequestCard(BuildContext context, GameRequestModel request, OperatorViewModel viewModel) {
    final theme = Theme.of(context);
    final isSelected = viewModel.selectedRequest?.requestId == request.requestId;
    
    // Format submission date
    final submissionDate = request.submissionDate;
    final formattedDate = '${submissionDate.day}/${submissionDate.month}/${submissionDate.year}';
    
    return Card(
      elevation: isSelected ? 4 : 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => viewModel.selectRequest(request),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      request.gameName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(request.status, theme).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusColor(request.status, theme),
                      ),
                    ),
                    child: Text(
                      _getStatusText(request.status),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _getStatusColor(request.status, theme),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Publisher: ${request.publisherId}',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Submitted: $formattedDate',
                style: theme.textTheme.bodySmall,
              ),
              if (request.categories.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    ...request.categories.take(3).map((category) {
                      return Chip(
                        label: Text(
                          category.name,
                          style: const TextStyle(fontSize: 10),
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                      );
                    }),
                    if (request.categories.length > 3)
                      Chip(
                        label: Text(
                          '+${request.categories.length - 3} more',
                          style: const TextStyle(fontSize: 10),
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'moreinfo':
        return 'Needs Info';
      default:
        return 'Unknown';
    }
  }
  
  Color _getStatusColor(String status, ThemeData theme) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return theme.colorScheme.error;
      case 'moreinfo':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
  
  // Show dialog for approving a game request
  Future<void> _showApprovalDialog(BuildContext context, OperatorViewModel viewModel) async {
    final feedback = await showDialog<String>(
      context: context,
      builder: (context) => FeedbackDialog(
        title: 'Approve Game',
        content: 'Are you sure you want to approve this game for publication? You can provide optional feedback to the publisher.',
        confirmLabel: 'Approve',
        isRequired: false,
      ),
    );
    
    if (feedback != null && viewModel.hasSelectedRequest) {
      final requestId = viewModel.selectedRequest!.requestId;
      final success = await viewModel.approveGameRequest(requestId, feedback: feedback);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Game successfully approved for publication'
                : 'Failed to approve game'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }
  
  // Show dialog for rejecting a game request
  Future<void> _showRejectionDialog(BuildContext context, OperatorViewModel viewModel) async {
    final feedback = await showDialog<String>(
      context: context,
      builder: (context) => const FeedbackDialog(
        title: 'Reject Game',
        content: 'Please provide feedback explaining why this game is being rejected.',
        confirmLabel: 'Reject',
        isRequired: true,
      ),
    );
    
    if (feedback != null && viewModel.hasSelectedRequest) {
      final requestId = viewModel.selectedRequest!.requestId;
      final success = await viewModel.rejectGameRequest(requestId, feedback: feedback);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Game request has been rejected'
                : 'Failed to reject game request'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }
}