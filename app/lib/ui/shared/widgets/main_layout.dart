import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'navigation_topbar.dart';
import 'page_footer.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  
  const MainLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Persistent navigation topbar
          NavigationTopbar(
            onNavigate: (String route) {
              context.go(route);
            },
          ),
          
          // Content area with footer
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Main content (this changes based on route)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      // Page content
                      Expanded(child: child),
                      // Footer at the bottom
                      PageFooter(
                        onNavigate: (String route) {
                          // Handle footer navigation
                          context.go(route);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}