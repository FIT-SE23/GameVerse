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
    void onNavigate(String route) {
      context.go(route);
    }

    return Scaffold(
      body: Column(
        children: [
          // Persistent navigation topbar
          NavigationTopbar(
            onNavigate: onNavigate,
          ),
          
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Main content (this changes based on route)
                SliverToBoxAdapter(
                  // Minimum height to ensure that the footer is always at the bottom
                  // even if the content is short
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height, // Adjust as needed
                    ),
                    child: child,
                  ),
                ),
                // Footer
                SliverToBoxAdapter(
                  child: PageFooter(
                    onNavigate: onNavigate,
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