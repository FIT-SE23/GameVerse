import 'package:flutter/material.dart';

import 'package:gameverse/ui/shared/widgets/category_chip.dart';

class FilterSidebar extends StatelessWidget {
  final Map<String, bool> categoryMap;

  const FilterSidebar({
    super.key,
    required this.categoryMap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: theme.textTheme.titleMedium
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (String name in categoryMap.keys)
              if (name.isNotEmpty)
                CategoryChip(
                  name: name,
                  onSelect: () {},
                  isSelected: categoryMap[name] ?? false,
                )
          ],
        )
      ]
    );
  }
}