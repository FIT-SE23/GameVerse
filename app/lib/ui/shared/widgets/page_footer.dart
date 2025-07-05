import 'package:flutter/material.dart';

class PageFooter extends StatelessWidget {
  const PageFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // About column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GameVerse',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The ultimate gaming platform for discovering and playing your favorite games.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              
              // Links column 1
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Company',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildFooterLink(context, 'About Us', () {}),
                    _buildFooterLink(context, 'Careers', () {}),
                    _buildFooterLink(context, 'News', () {}),
                    _buildFooterLink(context, 'Partners', () {}),
                  ],
                ),
              ),
              
              // Links column 2
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Support',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildFooterLink(context, 'Help Center', () {}),
                    _buildFooterLink(context, 'FAQs', () {}),
                    _buildFooterLink(context, 'Contact Us', () {}),
                    _buildFooterLink(context, 'Account Issues', () {}),
                  ],
                ),
              ),
              
              // Links column 3
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Legal',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildFooterLink(context, 'Terms of Service', () {}),
                    _buildFooterLink(context, 'Privacy Policy', () {}),
                    _buildFooterLink(context, 'Cookie Policy', () {}),
                    _buildFooterLink(context, 'EULA', () {}),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Social media and copyright row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© 2025 GameVerse. All rights reserved.',
                style: theme.textTheme.bodySmall,
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.facebook),
                    onPressed: () {},
                    tooltip: 'Facebook',
                  ),
                  IconButton(
                    icon: const Icon(Icons.discord),
                    onPressed: () {},
                    tooltip: 'Discord',
                  ),
                  IconButton(
                    icon: const Icon(Icons.reddit),
                    onPressed: () {},
                    tooltip: 'Reddit',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildFooterLink(BuildContext context, String title, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: TextButton(
        onPressed: onPressed,
        child: Text(title),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 32),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}