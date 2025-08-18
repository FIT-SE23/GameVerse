import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../view_model/advanced_search_viewmodel.dart';

import 'package:gameverse/ui/shared/widgets/category_chip.dart';
import 'package:gameverse/config/app_theme.dart';

class FilterSidebar extends StatefulWidget {
  const FilterSidebar({
    super.key,
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

    final viewModel = Provider.of<AdvancedSearchViewmodel>(context, listen: false);

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
                        viewModel.setSearchQuery('');
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
            onChanged: viewModel.setSearchQuery,
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
                  viewModel.setOnlyDiscounted(_discounted);
                });
              },
            ),
            Text(
              'Only Discounted',
              style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.normal),
            )
          ],
        ),

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
            for (String name in viewModel.categoryMap.keys) 
              CategoryChip(
                name: name,
                onSelect: () {
                  viewModel.switchCategorySelectState(name);
                },
                isSelected: viewModel.categoryMap[name]!,
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
              viewModel.applyFilters();
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