import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:gameverse/ui/shared/theme_viewmodel.dart';
import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';

import 'package:gameverse/config/app_theme.dart';

class DesktopNavbar extends StatelessWidget {
  final String currentLocation;
  const DesktopNavbar({
    super.key,
    required this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    String logoAddr;
    if (Theme.brightnessOf(context) == Brightness.dark) {
      logoAddr = 'assets/logo/logo_horizontal_white.svg';
    }
    else {
      logoAddr = 'assets/logo/logo_horizontal_black.svg';
    }
    final theme = Theme.of(context);

    return Container(
      height: 60,
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo/header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Transform.scale(
              scale: 1.8,
              origin: Offset(0, 0),
              child: 
              SvgPicture.asset(logoAddr, fit: BoxFit.fitHeight, width: 10, height: 50,)
            ),
          ),
          
          // Navigation items
          Row(
            children: [
              _buildNavItem(context, '/', 'Home', currentLocation),
              _buildNavItem(context, '/library', 'Library', currentLocation),
              _buildNavItem(context, '/forums', 'Forums', currentLocation),
              _buildNavItem(context, '/downloads', 'Downloads', currentLocation),
            ],
          ),
          const SizedBox(width: 8),
          // Search bar
          Container(
            width: 300,
            height: 30,
            margin: const EdgeInsets.symmetric(horizontal: 0),
            child: SearchAnchor(
              viewShape: RoundedRectangleBorder(
                // borderRadius: BorderRadius.circular(0),
              ),
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                  onTap: () => controller.openView(),
                  onChanged: (_) => controller.openView(),
                  leading: Icon(Icons.search, size: 20, color: AppTheme.themeColors(theme.brightness).getText),
                  hintText: 'Search games...',
                  hintStyle: const WidgetStatePropertyAll<TextStyle>(
                    TextStyle(color: Color.fromARGB(179, 150, 150, 150), fontSize: 14),
                  ),
                  elevation: WidgetStateProperty.all(0),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      // borderRadius: BorderRadius.circular(0),
                      side: BorderSide(color: AppTheme.themeColors(theme.brightness).getText, width: 1)
                    )
                  ),
                  backgroundColor: WidgetStateProperty.all(theme.appBarTheme.backgroundColor),
                );
              },
              suggestionsBuilder: (BuildContext context, SearchController controller) {
                return _buildSearchSuggestions(controller);
              },
            ),
          ),
          
          const SizedBox(width: 8),
          // Theme toggle
          Tooltip(
            message: 'Toggle theme',
            child: Consumer<ThemeViewModel>(
              builder: (context, themeProvider, _) {
                return IconButton(
                  onPressed: themeProvider.toggleTheme,
                  icon: Icon(
                    themeProvider.isDarkMode 
                        ? Icons.brightness_2_outlined 
                        : Icons.brightness_7_outlined,
                    color: Theme.of(context).appBarTheme.foregroundColor,
                  ),
                );
              }
            ),
          ),
          const SizedBox(width: 8),
          
          // Account section
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _buildAccountSection(context),
          ),
        ],
      ),
    );
  }

  // Search suggestions
  List<Widget> _buildSearchSuggestions(SearchController controller) {
    return List<ListTile>.generate(5, (int index) {
      final String item = 'Game Suggestion ${index + 1}';
      return ListTile(
        leading: const Icon(Icons.games),
        title: Text(item),
        onTap: () {
          controller.closeView(item);
          // Handle search selection
        },
      );
    });
  }

  // Account section for desktop
  Widget _buildAccountSection(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authProvider, _) {
        if (authProvider.status == AuthStatus.authenticated) {
          return PopupMenuButton<String>(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.account_circle,
                    color: Theme.of(context).appBarTheme.foregroundColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 100),
                    child: Text(
                      authProvider.user?.name ?? 'Guest',
                      style: TextStyle(
                        color: Theme.of(context).appBarTheme.foregroundColor,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            onSelected: (value) {
              if (value == 'logout') {
                authProvider.logout();
              }
              else {
                context.push('/${value.toLowerCase()}');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                mouseCursor: SystemMouseCursors.click,
                child: ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Profile'),
                ),
              ),
              const PopupMenuItem(
                value: 'transactions',
                mouseCursor: SystemMouseCursors.click,
                child: ListTile(
                  leading: Icon(Icons.account_balance_wallet),
                  title: Text('Transactions'),
                ),
              ),
              
              const PopupMenuItem(
                value: 'settings',
                mouseCursor: SystemMouseCursors.click,
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                mouseCursor: SystemMouseCursors.click,
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                ),
              ),
            ],
          );
        } else {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                onPressed: () => context.push('/login'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('Log In'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => context.push('/signup'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('Sign Up'),
              ),
            ],
          );
        }
      },
    );
  }

    // Desktop navigation item
  Widget _buildNavItem(BuildContext context, String route, String title, String currentLocation) {
    final isSelected = currentLocation == route;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected ? Theme.of(context).colorScheme.secondary : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: InkWell(
        onTap: () => context.go(route),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isSelected 
                      ? Theme.of(context).colorScheme.secondary 
                      : Theme.of(context).appBarTheme.foregroundColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}