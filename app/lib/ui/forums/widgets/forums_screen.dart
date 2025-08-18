import 'package:flutter/material.dart';
import 'package:gameverse/config/spacing_config.dart';
// import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:provider/provider.dart';
// import 'package:go_router/go_router.dart';
import 'package:gameverse/ui/forums/view_model/forum_viewmodel.dart';

import 'package:gameverse/config/app_theme.dart';

import 'game_forum_card.dart';

import 'package:gameverse/ui/shared/widgets/page_footer.dart';

class ForumsScreen extends StatefulWidget {
  const ForumsScreen({super.key});

  @override
  State<ForumsScreen> createState() => _ForumsScreenState();
}

class _ForumsScreenState extends State<ForumsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ForumsViewModel>(context, listen: false).loadGamesWithForums();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<ForumsViewModel>(
      builder: (context, viewModel, child) {
        // Filter games based on search query
        final filteredGames = viewModel.gamesWithForums
            .where((game) => game.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: getNegativeSpacePadding(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 64),
                    // Header
                    Text(
                      'Game Forums',
                      style: theme.textTheme.displayLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discuss your favorite games with the community',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                
                    // Search Bar
                    SizedBox(
                      // decoration: BoxDecoration(
                      //   color: theme.colorScheme.surfaceContainerHighest,
                      //   borderRadius: BorderRadius.circular(12),
                      //   border: Border.all(
                      //     color: theme.colorScheme.outline.withValues(alpha: 0.3),
                      //   ),
                      // ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search game forums...',
                          prefixIcon: Icon(
                            Icons.search,
                            color: theme.colorScheme.onSurfaceVariant
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.currentThemeColors(theme.brightness).getText),
                            borderRadius: BorderRadius.circular(6)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.currentThemeColors(theme.brightness).getCyan),
                            borderRadius: BorderRadius.circular(6)
                          ),
                          filled: false,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                
                    // Results count
                    if (_searchQuery.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          '${filteredGames.length} forum${filteredGames.length == 1 ? '' : 's'} found',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                
                    // Content
                    if (viewModel.state == ForumsState.loading)
                      SizedBox(
                        height: 200,
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    else if (viewModel.state == ForumsState.error)
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: theme.colorScheme.error,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              viewModel.errorMessage,
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => viewModel.loadGamesWithForums(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    else if (filteredGames.isEmpty)
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              _searchQuery.isNotEmpty ? Icons.search_off : Icons.forum_outlined,
                              size: 64,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isNotEmpty 
                                  ? 'No forums found for "$_searchQuery"'
                                  : 'No forums available',
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      )
                    else
                      // Column layout for forums
                      // Column(
                      //   children: [
                      //     ListView.separated(
                      //       physics: NeverScrollableScrollPhysics(),
                      //       scrollDirection: Axis.vertical,
                      //       itemCount: filteredGames.length,
                      //       itemBuilder: (context, index) {
                      //         return GameForumCard(game: filteredGames[index]);
                      //       },
                      //       separatorBuilder:(context, index) => const SizedBox(height: 16),
                      //     ),
                      //   ],
                      // ),
                      Column(
                        children: filteredGames.map((game) {
                          return Column(
                            children: [
                              GameForumCard(game: game),
                              const SizedBox(height: 16)
                            ],
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 96),
                  ],
                ),
              ),

              PageFooter()
            ],
          ),
        );
      },
    );
  }
}