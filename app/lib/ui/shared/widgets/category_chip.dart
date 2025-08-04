import 'package:flutter/material.dart';

import 'package:gameverse/config/app_theme.dart';

class CategoryChip extends StatelessWidget {
  final String name;
  final void Function() onSelect;

  const CategoryChip({
    super.key,
    required this.name,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onSelect,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: AppTheme.currentThemeColors(theme.brightness).getText,
            width: 1,
          ),
          borderRadius: BorderRadius.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            name,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}