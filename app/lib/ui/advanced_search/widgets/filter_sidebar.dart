import 'package:flutter/material.dart';

import '../view_model/advanced_search_viewmodel.dart';

import 'package:gameverse/ui/shared/widgets/category_chip.dart';
import 'package:gameverse/config/app_theme.dart';

class FilterSidebar extends StatefulWidget {
  final AdvancedSearchViewmodel viewModel;

  const FilterSidebar({
    super.key,
    required this.viewModel
  });

  @override
  State<FilterSidebar> createState() => _FilterSidebarState();
}

class _FilterSidebarState extends State<FilterSidebar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _discounted = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title search
        SizedBox(
          height: 36,
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              hintText: 'Search by title',
              prefixIcon: Icon(
                Icons.search,
                color: theme.colorScheme.onSurfaceVariant
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        widget.viewModel.setSearchQuery('');
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
                vertical: 12,
              ),
            ),
            onChanged: widget.viewModel.setSearchQuery,
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Checkbox(
              value: _discounted,
              onChanged: (value) {
                setState(() {
                  _discounted = value!;
                  widget.viewModel.setOnlyDiscounted(_discounted);
                });
              },
            ),
            Text(
              'Only Discounted',
              style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.normal),
            )
          ],
        ),
        const SizedBox(height: 12,),

        // Categories filter
        Text(
          'Categories',
          style: theme.textTheme.titleMedium
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (String name in widget.viewModel.categoryMap.keys) 
              CategoryChip(
                name: name,
                onSelect: () {
                  widget.viewModel.switchCategorySelectState(name);
                },
                isSelected: widget.viewModel.categoryMap[name]!,
              )
          ],
        ),

        SizedBox(height: 32),
        
        SizedBox(
          width: 128,
          height: 36,
          child: ElevatedButton(
            style: theme.elevatedButtonTheme.style,
            onPressed: () {
              widget.viewModel.applyFilters();
            },
            child: Text(
              'Apply filter',
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.scaffoldBackgroundColor
              ),
            ),
          ),
        ),
      ]
    );
  }
}