import 'package:flutter/material.dart';
import 'package:gameverse/data/repositories/game_repository.dart';
import 'package:gameverse/ui/advanced_search/view_model/advanced_search_viewmodel.dart';

import 'package:gameverse/config/spacing_config.dart';
import 'package:gameverse/ui/shared/widgets/page_footer.dart';
import 'package:provider/provider.dart';

import 'filter_sidebar.dart';
import 'filtered_game_section.dart';

class AdvancedSearchScreen extends StatefulWidget {
  final String titleQuery;
  final Set<String> selectedCategories;
  final String sortCriteria;
  final bool onlyDiscounted;

  const AdvancedSearchScreen({
    super.key,
    required this.titleQuery,
    required this.selectedCategories,
    this.sortCriteria = GameSortCriteria.popularity,
    this.onlyDiscounted = false
  });

  @override
  State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  final ScrollController _scrollController = ScrollController();

  double _sidebarTop = 127;

  final double _footerHeight = 560;
  final double _sidebarHeight = 200;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdvancedSearchViewmodel>(context, listen: false).loadData(
        titleQuery: widget.titleQuery,
        selectedCategories: widget.selectedCategories,
        sortCriteria: widget.sortCriteria,
        onlyDiscounted: widget.onlyDiscounted
      );

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
    const double sidebarWidth = 280;

    return Consumer<AdvancedSearchViewmodel>(
      builder: (context, advancedSearchViewmodel, child) {       
        final state = advancedSearchViewmodel.state;

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
                        const SizedBox(height: 32),
                        
                        if (state == AdvancedSearchState.initial)
                          const SizedBox(
                            height: 300,
                            child: Center(child: CircularProgressIndicator()),
                          ),

                        if (state == AdvancedSearchState.loading || state == AdvancedSearchState.success)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: FilteredGameSection(viewModel: advancedSearchViewmodel,),
                              ),
                              const SizedBox(width: 32 + sidebarWidth),
                            ],
                          ),
                        
                        if (state == AdvancedSearchState.error)
                          SizedBox(
                            height: 300,
                            child: Center(
                              child: Text(
                                advancedSearchViewmodel.errorMessage,
                              ),
                            )
                          ),
                        
                        const SizedBox(height: 96), // Extra space before footer
                      ],
                    ),
                  ),
                  PageFooter(),
                ],
              ),
            ),

            if (state == AdvancedSearchState.loading || state == AdvancedSearchState.success)
              Positioned(
                top: _sidebarTop,
                right: negativeSpaceWidth(context),
                child: SizedBox(
                  width: sidebarWidth,
                  child: FilterSidebar(
                    viewModel: advancedSearchViewmodel,
                  ),
                ),
              ),
          ],
        );
      }
    );
  }
}