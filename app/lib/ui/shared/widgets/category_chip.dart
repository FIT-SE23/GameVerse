import 'package:flutter/material.dart';

import 'package:gameverse/config/app_theme.dart';

class CategoryChip extends StatelessWidget {
  final String name;
  final void Function() onSelect;
  final bool isSelected;

  const CategoryChip({
    super.key,
    required this.name,
    required this.onSelect,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (!isSelected) {
      return InkWell(
        onTap: onSelect,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: AppTheme.currentThemeColors(theme.brightness).getText,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(6),
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
    } else {
      return InkWell(
        onTap: onSelect,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.currentThemeColors(theme.brightness).getText,
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
              style: theme.textTheme.bodyMedium!.copyWith(
                color: AppTheme.currentThemeColors(theme.brightness).getBackground
              ),
            ),
          ),
        ),
      );
    }
  }
}