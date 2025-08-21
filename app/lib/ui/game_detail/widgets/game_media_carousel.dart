import 'package:flutter/material.dart';
import 'package:gameverse/config/app_theme.dart';

class GameMediaCarousel extends StatefulWidget {
  final List<String> media;
  
  const GameMediaCarousel({
    super.key,
    required this.media,
  });

  @override
  State<GameMediaCarousel> createState() => _GameMediaCarouselState();
}

class _GameMediaCarouselState extends State<GameMediaCarousel> {
  final ScrollController _scrollController = ScrollController();

  int currentMediaIndex = 0;
  int hoverIndex = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final double radius = 12;

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
            child: ClipRRect(
              key: ValueKey(widget.media[currentMediaIndex]),
              borderRadius: BorderRadiusGeometry.circular(radius),
              child: Image.network(
                widget.media[currentMediaIndex],
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
        ),
        
        const SizedBox(height: 16),

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
                return MouseRegion(
                  onEnter: (_) {
                    setState(() => hoverIndex = index);
                  },
                  onExit: (_) {
                    setState(() => hoverIndex = -1);
                  },
                  child: InkWell(
                    onTap: () {
                      setState(() => currentMediaIndex = index);
                    },
                    child: SizedBox(
                      width: 128,
                      height: 72,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(radius),
                              child: Image.network(
                                widget.media[index],
                                fit: BoxFit.cover,
                                // cacheWidth: 128,
                                // cacheHeight: 72,
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
                  
                          Positioned(
                            top: -0.5,
                            bottom: -0.5,
                            left: -0.5,
                            right: -0.5,
                            child: Container(
                              decoration:
                              currentMediaIndex == index
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(radius),
                                  border: BoxBorder.all(
                                    color: AppTheme.currentThemeColors(theme.brightness).getText,
                                    width: 2,
                                  )
                                )
                              :
                              hoverIndex == index
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(radius),
                                  color: theme.scaffoldBackgroundColor.withValues(alpha: 0.6),
                                  // border: BoxBorder.all(
                                  //   color: AppTheme.currentThemeColors(theme.brightness).getText,
                                  //   width: 2,
                                  // )
                                )
                              : BoxDecoration(
                                  color: theme.scaffoldBackgroundColor.withValues(alpha: 0.6),
                                )
                            ),
                          ),
                        ],
                      ),
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
}