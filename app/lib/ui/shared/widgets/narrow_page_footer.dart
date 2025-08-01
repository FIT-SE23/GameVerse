import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NarrowPageFooter extends StatelessWidget {
  const NarrowPageFooter({
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
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
                  textAlign: TextAlign.center,
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
                  ]
                )
              ),
            ],
          ),

          // const SizedBox(height: 32),
          const Divider(height: 32, color: Color.fromARGB(255, 96, 96, 96),),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'GAMEVERSE',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
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
                  )
                ],
              ),
            ],
          ),

          // const SizedBox(height: 32),
          const Divider(height: 32, color: Color.fromARGB(255, 96, 96, 96),),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Legal',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        _buildFooterLink(context, 'Terms of Service', () {}),
                        _buildFooterLink(context, 'Privacy Policy', () {}),
                        _buildFooterLink(context, 'Cookie Policy', () {}),
                        _buildFooterLink(context, 'EULA', () {}),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),

          // const SizedBox(height: 32),
          const Divider(height: 32, color: Color.fromARGB(255, 96, 96, 96),),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Company',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        _buildFooterLink(context, 'About Us', () {}),
                        _buildFooterLink(context, 'FAQs', () {}),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),

          // const SizedBox(height: 32),
          const Divider(height: 32, color: Color.fromARGB(255, 96, 96, 96),),

          Text(
            '© 2025 GAMEVERSE Corporation. All rights reserved. All trademarks are the property of their respective owners in Vietnam and other countries.',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
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