import 'package:flutter/material.dart';
import 'package:gameverse/ui/advance_search/view_model/advanced_search_viewmodel.dart';

import 'package:gameverse/ui/shared/widgets/game_card.dart';

import 'package:gameverse/config/spacing_config.dart';
import 'package:gameverse/ui/shared/widgets/page_footer.dart';
import 'package:provider/provider.dart';

import 'filter_sidebar.dart';

class AdvanceSearchScreen extends StatefulWidget {
  const AdvanceSearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AdvanceSearchScreenState();
}

class _AdvanceSearchScreenState extends State<AdvanceSearchScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  double _sidebarTop = 127;

  final double _footerHeight = 560;
  final double _sidebarHeight = 300;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdvancedSearchViewmodel>(context, listen: false).loadData();

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
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double sidebarWidth = 280;

    return Consumer<AdvancedSearchViewmodel>(
      builder: (context, advancedSearchViewmodel, child) {
        return Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
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
                        const SizedBox(height: 640),
                        
                        // GridView.builder(
                        //   shrinkWrap: true,
                        //   physics: NeverScrollableScrollPhysics(),
                        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //     crossAxisCount: 3,
                        //     crossAxisSpacing: spaceCardHorizontal,
                        //     mainAxisSpacing: 16,
                        //     childAspectRatio: 1,
                        //   ),
                        //   itemCount: games.length,
                        //   itemBuilder: (context, index) => GameCard(
                        //     game: games[index],
                        //     width: cardWidth(context),
                        //     showPrice: false,
                        //   ),
                        // ),
              
                        const SizedBox(height: 96), // Extra space before footer
                      ],
                    ),
                  ),
              
                  PageFooter(),
                ],
              ),
            ),

            Positioned(
              top: _sidebarTop,
              right: negativeSpaceWidth(context),
              child: SizedBox(
                width: sidebarWidth,
                child: FilterSidebar(categoryMap: advancedSearchViewmodel.categoryMap),
              ),
            ),
          ],
        );
      }
    );
  }
}