import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Placeholder(),
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
              itemCount: 10,
              itemBuilder:(context, index) {
                return SizedBox(
                  height: 72,
                  width: 128,
                  child: Placeholder(),
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