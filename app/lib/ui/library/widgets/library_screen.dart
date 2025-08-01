import 'package:flutter/material.dart';
import 'package:gameverse/config/spacing_config.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:gameverse/ui/library/view_model/library_viewmodel.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:gameverse/ui/shared/widgets/game_card.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LibraryViewModel>(context, listen: false).loadLibrary();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWideScreen = MediaQuery.of(context).size.width > 800;

    return SingleChildScrollView(
      child: Consumer<LibraryViewModel>(
        builder: (context, libraryViewModel, child) {
          return SizedBox(
            height: 1600,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Section
                Container(
                  padding: EdgeInsets.all(isWideScreen ? 24 : 16),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Stats
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Library',
                                  style: theme.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${libraryViewModel.games.length} games • ${libraryViewModel.downloadedCount} downloaded',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Add game button
                          if (isWideScreen) ...[
                            ElevatedButton.icon(
                              onPressed: () => context.push('/add-game'),
                              icon: const Icon(Icons.add),
                              label: const Text('Add Game'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ] else ...[
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => context.push('/add-game'),
                              tooltip: 'Add Game',
                              style: IconButton.styleFrom(
                                padding: const EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Search Bar
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _searchFocusNode.hasFocus 
                                ? theme.colorScheme.primary 
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Search your games...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      libraryViewModel.searchGames('');
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onChanged: libraryViewModel.searchGames,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Tags Filter
                      if (libraryViewModel.availableTags.isNotEmpty) ...[
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _TagChip(
                                label: 'All',
                                isSelected: libraryViewModel.selectedTags.isEmpty,
                                onTap: () => libraryViewModel.clearTagFilters(),
                              ),
                              const SizedBox(width: 8),
                              ...libraryViewModel.availableTags.map(
                                (tag) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: _TagChip(
                                    label: tag,
                                    isSelected: libraryViewModel.selectedTags.contains(tag),
                                    onTap: () => libraryViewModel.toggleTag(tag),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      // Category Tabs
                      TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        onTap: libraryViewModel.setActiveCategory,
                        tabs: const [
                          Tab(text: 'All Games'),
                          Tab(text: 'Downloaded'),
                          Tab(text: 'Favorites'),
                          Tab(text: 'Recently Played'),
                        ],
                      ),
                    ],
                  ),
                ),
                  
                const SizedBox(height: 8),
                
                // View Mode Toggle
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          _ViewToggleButton(
                            icon: Icons.view_list,
                            isSelected: libraryViewModel.viewMode == LibraryViewMode.list,
                            onTap: () => libraryViewModel.setViewMode(LibraryViewMode.list),
                          ),
                          _ViewToggleButton(
                            icon: Icons.grid_view,
                            isSelected: libraryViewModel.viewMode == LibraryViewMode.grid,
                            onTap: () => libraryViewModel.setViewMode(LibraryViewMode.grid),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Games Content
                Expanded(
                  child: libraryViewModel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : libraryViewModel.filteredGames.isEmpty
                          ? _buildEmptyState(context)
                          : TabBarView(
                              controller: _tabController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                _buildGamesList(libraryViewModel.filteredGames, libraryViewModel.viewMode),
                                _buildGamesList(libraryViewModel.downloadedGames, libraryViewModel.viewMode),
                                _buildGamesList(libraryViewModel.favoriteGames, libraryViewModel.viewMode),
                                _buildGamesList(libraryViewModel.recentGames, libraryViewModel.viewMode),
                              ],
                            ),
                ),

                // Load more button
                if (libraryViewModel.filteredGames.isNotEmpty && !libraryViewModel.isLoading)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Load more functionality can be implemented here
                          debugPrint('Load more games');
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text('Load More'),
                            const SizedBox(height: 4),
                            Icon(
                              Icons.arrow_downward,
                              size: 20,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGamesList(List<GameModel> games, LibraryViewMode viewMode) {
    if (games.isEmpty) {
      return _buildEmptyState(context);
    }

    if (viewMode == LibraryViewMode.list) {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: games.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _GameListTile(game: games[index]),
      );
    } else {
      final crossAxisCount = MediaQuery.of(context).size.width > 1200 ? 4 : 
                           MediaQuery.of(context).size.width > 800 ? 3 : 2;
      
      // Using game_card.dart for grid tiles
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: games.length,
        itemBuilder: (context, index) => GameCard(
          game: games[index],
          width: cardWidth(context)
        ),
      );
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.videogame_asset_off,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No games found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// Supporting Widgets
class _ViewToggleButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ViewToggleButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected 
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TagChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected 
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _GameListTile extends StatelessWidget {
  final GameModel game;

  const _GameListTile({required this.game});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/game-details/${game.appId}'),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Game Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  game.headerImage,
                  width: 80,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 60,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.videogame_asset),
                    );
                  },
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Game Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (game.playtimeHours != null) ...[
                      Text(
                        '${game.playtimeHours!.toStringAsFixed(1)} hours played',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (game.installed) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Installed',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Icon(
                          Icons.star,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Actions
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  final libraryViewModel = Provider.of<LibraryViewModel>(context, listen: false);
                  switch (value) {
                    case 'favorite':
                      libraryViewModel.toggleFavorite(game.appId);
                      break;
                    case 'uninstall':
                      libraryViewModel.toggleInstalled(game.appId);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'favorite',
                    child: ListTile(
                      leading: Icon(Icons.favorite_border),
                      title: Text('Add to Favorites'),
                    ),
                  ),
                  if (game.installed)
                    const PopupMenuItem(
                      value: 'uninstall',
                      child: ListTile(
                        leading: Icon(Icons.delete_outline),
                        title: Text('Uninstall'),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}