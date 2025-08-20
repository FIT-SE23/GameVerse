import 'package:flutter/material.dart';
import 'package:gameverse/domain/models/game_request_model/game_request_model.dart';
class GameRequestDetail extends StatefulWidget {
  final GameRequestModel request;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const GameRequestDetail({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onReject,
  });
  
  @override
  State<GameRequestDetail> createState() => _GameRequestDetailState();
}

class _GameRequestDetailState extends State<GameRequestDetail> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedMediaIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tabs at top
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Game Info'),
              Tab(text: 'Media'),
              Tab(text: 'Technical'),
            ],
          ),
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Game Info Tab
                _buildGameInfoTab(theme),
                
                // Media Tab
                _buildMediaTab(theme),
                
                // Technical Tab
                _buildTechnicalTab(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildGameInfoTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Game title and action buttons
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.request.gameName,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: widget.onApprove,
                icon: const Icon(Icons.check_circle_outline),
                tooltip: 'Approve',
                color: Colors.green,
                iconSize: 32,
              ),
              IconButton(
                onPressed: widget.onReject,
                icon: const Icon(Icons.cancel_outlined),
                tooltip: 'Reject',
                color: Colors.red,
                iconSize: 32,
              ),
            ],
          ),
          
          // Status and publisher info
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              'Publisher ID: ${widget.request.publisherId}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Game image
          if (widget.request.headerImage.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  widget.request.headerImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 48,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          
          const SizedBox(height: 24),
          
          // Brief Description
          _buildDetailSection(theme, 'Brief Description', widget.request.briefDescription),
          
          // Full Description
          _buildDetailSection(theme, 'Full Description', widget.request.description),
          
          // Price information
          _buildDetailRow(theme, 'Price', '\$${widget.request.price.toStringAsFixed(2)}'),
          
          // Categories
          if (widget.request.categories.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Categories',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.request.categories.map((category) {
                return Chip(
                  label: Text(category.name),
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  labelStyle: TextStyle(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                );
              }).toList(),
            ),
          ],
          
          const SizedBox(height: 24),
          
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
                    'Please review the game information carefully before making a decision.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: widget.onApprove,
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
                          onPressed: widget.onReject,
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
  
  Widget _buildMediaTab(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Game Media',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          if (widget.request.media.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 48.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.image_not_supported,
                      size: 64,
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No media available for this game',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display the selected media
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        widget.request.media[_selectedMediaIndex],
                        width: double.infinity,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: theme.colorScheme.surfaceVariant,
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: theme.colorScheme.onSurfaceVariant,
                                size: 48,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Media thumbnails row
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.request.media.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedMediaIndex = index;
                            });
                          },
                          child: Container(
                            width: 120,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              border: _selectedMediaIndex == index
                                  ? Border.all(color: theme.colorScheme.primary, width: 3)
                                  : null,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                widget.request.media[index],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: theme.colorScheme.surfaceContainerHighest,
                                    child: const Center(
                                      child: Icon(Icons.image_not_supported),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildTechnicalTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Requirements',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
            ),
            child: Text(
              widget.request.requirements,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          
          const SizedBox(height: 32),
          
          Text(
            'Files Included',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Executable files
          if (widget.request.exes.isNotEmpty) ...[
            Text(
              'Executables',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.request.exes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.play_circle_outline),
                  title: Text(widget.request.exes[index]),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                );
              },
            ),
            const SizedBox(height: 16),
          ],
          
          // Binary files
          if (widget.request.binaries.isNotEmpty) ...[
            Text(
              'Binary Files',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.request.binaries.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.data_object),
                  title: Text(widget.request.binaries[index]),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                );
              },
            ),
          ],
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
  
  Widget _buildDetailRow(ThemeData theme, String title, String value, {Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            _getIconForTitle(title),
            size: 20,
            color: iconColor ?? theme.colorScheme.primary,
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
  
  IconData _getIconForTitle(String title) {
    switch (title.toLowerCase()) {
      case 'price':
        return Icons.attach_money;
      default:
        return Icons.info_outline;
    }
  }
}