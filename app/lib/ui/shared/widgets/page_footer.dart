import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PageFooter extends StatelessWidget {
  const PageFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String logoAddr;
    if (Theme.brightnessOf(context) == Brightness.dark) {
      logoAddr = 'assets/logo/logo_vertical_white.svg';
    } else {
      logoAddr = 'assets/logo/logo_vertical_black.svg';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      color: theme.appBarTheme.backgroundColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // About column
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: Transform.scale(
                        scale: 1.8,
                        origin: Offset(0, 0),
                        child: SvgPicture.asset(logoAddr, fit: BoxFit.fitHeight, width: 10, height: 80,)
                      ),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: Text(
                        'Where gamers belong',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.facebook),
                                onPressed: () {},
                                tooltip: 'Facebook',
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.discord),
                                onPressed: () {},
                                tooltip: 'Discord',
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.reddit),
                                onPressed: () {},
                                tooltip: 'Reddit',
                              ),
                            ],
                          ),
                          // const SizedBox(width: 32),
                          ]
                        )
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 64),
              
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Links column 1
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'GAMEVERSE',
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              _buildFooterLink(context, 'Home', () {
                                context.push('/');
                              }),
                              _buildFooterLink(context, 'Library', () {
                                context.push('/library');
                              }),
                              _buildFooterLink(context, 'Forums', () {
                                context.push('/forums');
                              }),
                              _buildFooterLink(context, 'Downloads', () {
                                context.push('/downloads');
                              }),
                            ],
                          ),
                        ),
                        
                        // Links column 2
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
                              _buildFooterLink(context, 'FAQs', () {}),
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
                    Text(
                      '© 2025 GAMEVERSE Corporation. All rights reserved. All trademarks are the property of their respective owners in Vietnam and other countries.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
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
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 32),
          alignment: Alignment.centerLeft,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          )
        ),
      ),
    );
  }
}