import 'package:flutter/material.dart';
import 'package:gameverse/config/app_theme.dart';
import 'package:provider/provider.dart';
import '../view_model/game_details_viewmodel.dart';

class GameMediaCarousel extends StatefulWidget {
  final List<String> media;
  
  const GameMediaCarousel({
    super.key,
    required this.media,
  });

  @override
  State<StatefulWidget> createState() => _GameMediaCarouselState();
}

class _GameMediaCarouselState extends State<GameMediaCarousel> {
  final ScrollController _scrollController = ScrollController();

  int currentMediaIndex = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GameDetailsViewModel>(context, listen: false);
    final status = viewModel.state;
    final theme = Theme.of(context);

    if (status == GameDetailsState.success) {
      return Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(
                opacity: animation,
                child: child
              ),
              child: Image.network(
                widget.media[currentMediaIndex],
                key: ValueKey(widget.media[currentMediaIndex]),
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
                }
              ),
            ),
          ),
          
          const SizedBox(height: 8),

          SizedBox(
            height: 80,
            child: Scrollbar(
              thumbVisibility: false,
              scrollbarOrientation: ScrollbarOrientation.bottom,
              thickness: 8,
              radius: const Radius.circular(0),
              controller: _scrollController,
              child: ListView.separated(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: widget.media.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() => currentMediaIndex = index);
                    },
                    child: SizedBox(
                      width: 128,
                      height: 72,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              widget.media[index],
                              fit: BoxFit.cover,
                              cacheWidth: 128,
                              cacheHeight: 72,
                            ),
                          ),

                          Positioned(
                            top: -1,
                            bottom: -1,
                            left: -1,
                            right: -1,
                            child: Container(
                              decoration: currentMediaIndex != index
                              ? BoxDecoration(
                                color: theme.scaffoldBackgroundColor.withValues(alpha: 0.6),
                              )
                              : BoxDecoration(
                                border: BoxBorder.all(
                                  color: AppTheme.currentThemeColors(theme.brightness).getText,
                                  width: 2,
                                )
                              )
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 8),
              ),
            ),
          )
        ],
      );
    }
    else if (status == GameDetailsState.loading) {
      return const SizedBox(
        height: 400,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    else {
      return const SizedBox(
        height: 400,
        child: Center(child: Text('Something went wrong :(')),
      );
    }
  }
}