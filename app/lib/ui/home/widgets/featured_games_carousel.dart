import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:gameverse/domain/models/game_model/game_model.dart';
import '../view_model/home_viewmodel.dart';


class FeaturedGamesCarousel extends StatefulWidget {
  const FeaturedGamesCarousel({super.key});

  @override
  State<FeaturedGamesCarousel> createState() => _FeaturedGamesCarouselState();
}

class _FeaturedGamesCarouselState extends State<FeaturedGamesCarousel> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeViewModel>(context, listen: false).loadHomePageData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, homeViewModel, child) {
        final status = homeViewModel.state;
        
        if (status == HomeViewState.loading) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (status == HomeViewState.error) {
          return SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(homeViewModel.errorMessage),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => homeViewModel.loadHomePageData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        } else if (status == HomeViewState.success && homeViewModel.featuredGames.isNotEmpty) {
          return Column(
            children: [
              SizedBox(
                height: 320,
                child: Scrollbar(
                  thumbVisibility: true,
                  scrollbarOrientation: ScrollbarOrientation.bottom,
                  thickness: 8,
                  radius: const Radius.circular(8),
                  controller: _scrollController,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: homeViewModel.featuredGames.length,
                    itemBuilder: (context, index) {
                      final game = homeViewModel.featuredGames[index];
                      return FeaturedGameCard(game: game);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '← Scroll to see more →',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              )
            ],
          );
        } else {
          return const SizedBox(
            height: 200,
            child: Center(child: Text('No special offers available')),
          );
        }
      },
    );
  }
}

class FeaturedGameCard extends StatelessWidget {
  final GameModel game;
  
  const FeaturedGameCard({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Use ViewModel to select game before navigation
          Provider.of<HomeViewModel>(context, listen: false).selectGame(game);
          // Navigator.pushNamed(context, '/gameDetails', arguments: game.appId);
          context.push('/game-details/${game.appId}');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                game.headerImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / 
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Game details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Game title
                  Text(
                    game.name,
                    style: theme.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Discount badge (if available)
                  if (game.description.contains('Save'))
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        game.description,
                        style: TextStyle(
                          color: theme.colorScheme.onSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    
                  const SizedBox(height: 8),
                  
                  // Price
                  Text(
                    game.price != null 
                        ? 'Price: ${(game.price!['final'] as int) / 100}VND' 
                        : 'Free to Play',
                    style: theme.textTheme.bodyMedium,
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