import 'package:flutter/material.dart';

import 'package:gameverse/ui/shared/widgets/game_card.dart';

import 'package:gameverse/config/spacing_config.dart';
import 'package:gameverse/ui/shared/widgets/page_footer.dart';

class AdvanceSearchScreen extends StatefulWidget {
  const AdvanceSearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AdvanceSearchScreenState();
}

class _AdvanceSearchScreenState extends State<AdvanceSearchScreen> {
  final ScrollController _scrollController = ScrollController();
  double _sidebarTop = 127;

  final double _footerHeight = 560;
  final double _sidebarHeight = 300;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        final scrollOffset = _scrollController.offset;
        final screenHeight = MediaQuery.of(context).size.height;
        final contentHeight = _scrollController.position.maxScrollExtent + screenHeight;

        const double stickyOffset = 127;

        final maxTop = contentHeight - _footerHeight - _sidebarHeight;
        final desiredTop = scrollOffset;

        // Sidebar stays fixed at `stickyOffset`, unless it hits the footer
        final sidebarTop = desiredTop < maxTop - stickyOffset
            ? stickyOffset
            : maxTop - desiredTop;

        setState(() {
          _sidebarTop = sidebarTop;
        });
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final double sidebarWidth = 280;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: getNegativeSpacePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 64),
                Text(
                  'Advanced Search',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 32),
                // Placeholder for advanced search content
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: spaceCardHorizontal,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: games.length,
                  itemBuilder: (context, index) => GameCard(
                    game: games[index],
                    width: cardWidth(context),
                    showPrice: false,
                  ),
                ),
                const SizedBox(height: 480), // Extra space before footer
              ],
            ),
          ),

          PageFooter(),
        ],
      ),
    );
  }
}