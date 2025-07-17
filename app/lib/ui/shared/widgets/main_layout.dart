import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'window_buttons.dart';

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
          // Window title bar
          WindowTitleBarBox(
            child: MoveWindow(
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                height: 32,
                alignment: Alignment.centerRight,
                child: WindowButtons(),
              ),
            ),
          ),

          // Persistent navigation topbar
          NavigationTopbar(),
          
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
                  child: PageFooter(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}