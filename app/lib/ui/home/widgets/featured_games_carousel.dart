import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/home_viewmodel.dart';
import 'package:gameverse/ui/shared/widgets/game_card.dart';


class FeaturedDiscountCarousel extends StatefulWidget {
  const FeaturedDiscountCarousel({super.key});

  @override
  State<FeaturedDiscountCarousel> createState() => _FeaturedDiscountCarouselState();
}

class _FeaturedDiscountCarouselState extends State<FeaturedDiscountCarousel> {
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
        } else if (status == HomeViewState.success && homeViewModel.featuredDiscount.isNotEmpty) {
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
                    itemCount: homeViewModel.featuredDiscount.length,
                    itemBuilder: (context, index) {
                      final game = homeViewModel.featuredDiscount[index];
                      return GameCard(
                        game: game,
                        onSelect: Provider.of<HomeViewModel>(context, listen: false).selectGame,
                      );
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