import 'package:flutter/material.dart';
import 'package:gameverse/ui/shared/theme_viewmodel.dart';
import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NavigationTopbar extends StatelessWidget {

  final Function(String) onNavigate;

  const NavigationTopbar({
    super.key, 
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;

    return Container(
      height: 50,
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo/header
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: const Text(
              'GameVerse',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          
          // Navigation items
          _buildNavItem(context, '/', 'Home', Icons.home, currentLocation),
          _buildNavItem(context, '/library', 'Library', Icons.games, currentLocation),
          _buildNavItem(context, '/forums', 'Forums', Icons.forum, currentLocation),
          _buildNavItem(context, '/downloads', 'Downloads', Icons.download, currentLocation),
          
          // Search icon
          SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SizedBox(
                width: 300,
                height: 30,
                child: SearchBar(
                  controller: controller,
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  onTap: () {
                    controller.openView();
                  },
                  onChanged: (_) {
                    controller.openView();
                  },
                  leading: const Icon(Icons.search),
                  hintText: 'Search games, categories, etc...',
                  hintStyle: const WidgetStatePropertyAll<TextStyle>(
                    TextStyle(color: Color.fromARGB(179, 150, 150, 150), fontSize: 14),
                  ),
                ),
              );
            },
            suggestionsBuilder: (BuildContext context, SearchController controller) {
              return List<ListTile>.generate(5, (int index) {
                final String item = 'item $index';
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    // Handle search item tap
                  },
                );
              });
            },
          ),
          Tooltip(
            message: 'Change brightness mode',
            child: Consumer<ThemeViewModel>(
              builder: (context, themeProvider, _) {
                return IconButton(
                  onPressed: () {
                    themeProvider.toggleTheme();
                  },
                  icon: themeProvider.isDarkMode
                    ? const Icon(Icons.brightness_2_outlined, color: Colors.white)
                    : const Icon(Icons.brightness_7_outlined, color: Colors.black),
                );
              }
            ),
          ),
          // Account section
          Consumer<AuthViewModel>(
            builder: (context, authProvider, _) {
              if (authProvider.status == AuthStatus.authenticated) {
                return PopupMenuButton<String>(
                  popUpAnimationStyle: AnimationStyle(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.decelerate,
                  ),
                  child: Container(
                    width: 140,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_circle,
                          color: Theme.of(context).appBarTheme.foregroundColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8), Text(
                            authProvider.user?.name ?? 'Guest',
                            style: TextStyle(
                              color: Theme.of(context).appBarTheme.foregroundColor,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  onSelected: (value) {
                    if (value == 'logout') {
                      authProvider.logout();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'profile',
                      child: ListTile(
                        leading: Icon(Icons.account_circle),
                        title: Text('Profile'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'settings',
                      child: ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Settings'),
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'logout',
                      child: ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Logout'),
                      ),
                    ),
                  ],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onNavigate('/login'),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Theme.of(context).appBarTheme.backgroundColor),
                    ),
                    child: const Text('Log In'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => onNavigate('/signup'), 
                    child: const Text('Sign Up'),
                  ),
                ],
              );
            }
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String route, String title, IconData icon, String currenLocation) {
    final isSelected = currenLocation == route;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected ? Theme.of(context).colorScheme.secondary : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: InkWell(
        onTap: () {
          onNavigate(route);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Theme.of(context).colorScheme.secondary : Theme.of(context).appBarTheme.foregroundColor,
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