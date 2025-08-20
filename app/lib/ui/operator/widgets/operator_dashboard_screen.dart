import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gameverse/ui/operator/view_model/operator_viewmodel.dart';
import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';
import 'package:gameverse/domain/models/game_request_model/game_request_model.dart';
import 'package:gameverse/domain/models/publisher_request_model/publisher_request_model.dart';
import 'package:gameverse/ui/operator/widgets/game_request_detail.dart';
import 'package:gameverse/ui/operator/widgets/publisher_request_detail.dart';
import 'package:gameverse/ui/operator/widgets/feedback_dialog.dart';
import 'package:gameverse/ui/shared/widgets/empty_state.dart';
import 'package:gameverse/ui/shared/widgets/loading_overlay.dart';

class OperatorDashboardScreen extends StatefulWidget {
  const OperatorDashboardScreen({super.key});

  @override
  State<OperatorDashboardScreen> createState() => _OperatorDashboardScreenState();
}

class _OperatorDashboardScreenState extends State<OperatorDashboardScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    // Initialize tab controller
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging || !mounted) {
      return;
    }
    
    final operatorViewModel = Provider.of<OperatorViewModel>(context, listen: false);
    operatorViewModel.setActiveTab(
      _tabController.index == 0 ? OperatorTab.games : OperatorTab.publishers
    );
    _loadData();
  }
  
  Future<void> _loadData() async {
    if (!mounted) return;
    
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
    
    if (_tabController.index != (operatorViewModel.activeTab == OperatorTab.games ? 0 : 1)) {
      _tabController.animateTo(operatorViewModel.activeTab == OperatorTab.games ? 0 : 1);
    }
    
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
        automaticallyImplyLeading: false,
        title: const Text('Operator Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Game Requests'),
            Tab(text: 'Publisher Requests'),
          ],
        ),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: operatorViewModel.activeTab == OperatorTab.games
            ? _buildGameRequestsContent(context, operatorViewModel, theme)
            : _buildPublisherRequestsContent(context, operatorViewModel, theme),
      ),
    );
  }
  
  Widget _buildGameRequestsContent(BuildContext context, OperatorViewModel viewModel, ThemeData theme) {
    // Handle error state
    if (viewModel.state == OperatorViewState.error) {
      return _buildErrorState(viewModel.errorMessage);
    }
    
    // Empty state when there are no pending requests
    if (viewModel.pendingGameRequests.isEmpty && viewModel.state == OperatorViewState.success) {
      return Center(
        child: EmptyState(
          icon: Icons.check_circle_outline,
          title: 'No Pending Game Requests',
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
                  'Pending Game Requests (${viewModel.pendingGameRequests.length})',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: viewModel.pendingGameRequests.length,
                  itemBuilder: (context, index) {
                    final request = viewModel.pendingGameRequests[index];
                    return _buildGameRequestCard(context, request, viewModel);
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
          child: viewModel.hasSelectedGameRequest
              ? GameRequestDetail(
                  request: viewModel.selectedGameRequest!,
                  onApprove: () => _showGameApprovalDialog(context, viewModel),
                  onReject: () => _showGameRejectionDialog(context, viewModel),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.gamepad,
                        size: 80,
                        color: theme.colorScheme.primary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Select a game request to review',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
  
  Widget _buildPublisherRequestsContent(BuildContext context, OperatorViewModel viewModel, ThemeData theme) {
    // Handle error state
    if (viewModel.state == OperatorViewState.error) {
      return _buildErrorState(viewModel.errorMessage);
    }
    
    // Empty state when there are no pending requests
    if (viewModel.pendingPublisherRequests.isEmpty && viewModel.state == OperatorViewState.success) {
      return Center(
        child: EmptyState(
          icon: Icons.check_circle_outline,
          title: 'No Pending Publisher Requests',
          message: 'There are no publisher applications waiting for review.',
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
                  'Pending Publisher Requests (${viewModel.pendingPublisherRequests.length})',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: viewModel.pendingPublisherRequests.length,
                  itemBuilder: (context, index) {
                    final request = viewModel.pendingPublisherRequests[index];
                    return _buildPublisherRequestCard(context, request, viewModel);
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
          child: viewModel.hasSelectedPublisherRequest
              ? PublisherRequestDetail(
                  request: viewModel.selectedPublisherRequest!,
                  onApprove: () => _showPublisherApprovalDialog(context, viewModel),
                  onReject: () => _showPublisherRejectionDialog(context, viewModel),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.business,
                        size: 80,
                        color: theme.colorScheme.primary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Select a publisher request to review',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
  
  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading data',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: Theme.of(context).textTheme.bodyMedium,
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
  
  Widget _buildGameRequestCard(BuildContext context, GameRequestModel request, OperatorViewModel viewModel) {
    final theme = Theme.of(context);
    final isSelected = viewModel.selectedGameRequest?.requestId == request.requestId;
    
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
        onTap: () => viewModel.selectGameRequest(request),
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
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Publisher ID: ${request.publisherId}',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                request.briefDescription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPublisherRequestCard(BuildContext context, PublisherRequestModel request, OperatorViewModel viewModel) {
    final theme = Theme.of(context);
    final isSelected = viewModel.selectedPublisherRequest?.requestId == request.requestId;
    
    // Format submission date
    final submissionDate = request.submissionDate;
    final formattedDate = submissionDate != null
        ? '${submissionDate.day}/${submissionDate.month}/${submissionDate.year}'
        : 'Unknown date';
    
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
        onTap: () => viewModel.selectPublisherRequest(request),
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
                      request.username,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Email: ${request.email}',
                style: theme.textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    _getPaymentIcon(request.paymentMethod.type),
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    request.paymentMethod.type,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Submitted: $formattedDate',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  IconData _getPaymentIcon(String paymentType) {
    switch (paymentType.toLowerCase()) {
      case 'paypal':
        return Icons.paypal;
      case 'vnpay':
        return Icons.account_balance_wallet;
      default:
        return Icons.payment;
    }
  }
  
  // Show dialog for approving a game request
  Future<void> _showGameApprovalDialog(BuildContext context, OperatorViewModel viewModel) async {
    final feedback = await showDialog<String>(
      context: context,
      builder: (context) => FeedbackDialog(
        title: 'Approve Game',
        content: 'Are you sure you want to approve this game for publication? You can provide optional feedback to the publisher.',
        confirmLabel: 'Approve',
        isRequired: false,
      ),
    );
    
    if (feedback != null && viewModel.hasSelectedGameRequest) {
      final requestId = viewModel.selectedGameRequest!.requestId;
      final success = await viewModel.approveGameRequest(requestId);
      
      if (context.mounted) {
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
  Future<void> _showGameRejectionDialog(BuildContext context, OperatorViewModel viewModel) async {
    final feedback = await showDialog<String>(
      context: context,
      builder: (context) => const FeedbackDialog(
        title: 'Reject Game',
        content: 'Please provide feedback explaining why this game is being rejected.',
        confirmLabel: 'Reject',
        isRequired: true,
      ),
    );
    
    if (feedback != null && viewModel.hasSelectedGameRequest) {
      final requestId = viewModel.selectedGameRequest!.requestId;
      final success = await viewModel.rejectGameRequest(requestId, feedback: feedback);
      
      if (context.mounted) {
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
  
  // Show dialog for approving a publisher request
  Future<void> _showPublisherApprovalDialog(BuildContext context, OperatorViewModel viewModel) async {
    final feedback = await showDialog<String>(
      context: context,
      builder: (context) => FeedbackDialog(
        title: 'Approve Publisher',
        content: 'Are you sure you want to approve this publisher application? You can provide optional feedback.',
        confirmLabel: 'Approve',
        isRequired: false,
      ),
    );
    
    if (feedback != null && viewModel.hasSelectedPublisherRequest) {
      final requestId = viewModel.selectedPublisherRequest!.requestId;
      final success = await viewModel.approvePublisherRequest(requestId, feedback: feedback);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Publisher application approved successfully'
                : 'Failed to approve publisher application'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }
  
  // Show dialog for rejecting a publisher request
  Future<void> _showPublisherRejectionDialog(BuildContext context, OperatorViewModel viewModel) async {
    final feedback = await showDialog<String>(
      context: context,
      builder: (context) => const FeedbackDialog(
        title: 'Reject Publisher',
        content: 'Please provide feedback explaining why this publisher application is being rejected.',
        confirmLabel: 'Reject',
        isRequired: true,
      ),
    );
    
    if (feedback != null && viewModel.hasSelectedPublisherRequest) {
      final requestId = viewModel.selectedPublisherRequest!.requestId;
      final success = await viewModel.rejectPublisherRequest(requestId, feedback: feedback);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Publisher application has been rejected'
                : 'Failed to reject publisher application'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }
}