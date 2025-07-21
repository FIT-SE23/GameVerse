import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:gameverse/ui/shared/theme_viewmodel.dart';
import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';

  // Mobile Navigation Bar (with drawer button)
class MobileNavbar extends StatelessWidget {
  final String currentLocation;

  const MobileNavbar({
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
    return Container(
      height: 60,
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: Row(
        children: [
          // Menu button
          IconButton(
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
            onPressed: () {
              _showMobileDrawer(context, currentLocation);
            },
          ),
          
          // Logo
          Expanded(
            child: Center(
              child: Transform.scale(
                scale: 1.8,
                origin: Offset(0, 0),
                child: SvgPicture.asset(logoAddr, fit: BoxFit.fitHeight, width: 10, height: 30,)
              ),
            ),
          ),
          
          // Search button
          IconButton(
            icon: Icon(
              Icons.search,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
            onPressed: () {
              _showMobileSearch(context);
            },
          ),
          
          // Account button
          Consumer<AuthViewModel>(
            builder: (context, authProvider, _) {
              return IconButton(
                icon: Icon(
                  authProvider.status == AuthStatus.authenticated 
                      ? Icons.account_circle 
                      : Icons.login,
                  color: Theme.of(context).appBarTheme.foregroundColor,
                ),
                onPressed: () {
                  if (authProvider.status == AuthStatus.authenticated) {
                    _showAccountMenu(context);
                  } else {
                    context.push('/login');
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

    // Mobile Navigation Drawer
  void _showMobileDrawer(BuildContext context, String currentLocation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(top: 12, bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Navigation',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                
                // Navigation items
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildMobileNavItem(context, '/', 'Home', Icons.home, currentLocation),
                      _buildMobileNavItem(context, '/library', 'Library', Icons.games, currentLocation),
                      _buildMobileNavItem(context, '/forums', 'Forums', Icons.forum, currentLocation),
                      _buildMobileNavItem(context, '/downloads', 'Downloads', Icons.download, currentLocation),
                      
                      const Divider(height: 32),
                      
                      // Theme toggle
                      Consumer<ThemeViewModel>(
                        builder: (context, themeProvider, _) {
                          return ListTile(
                            leading: Icon(
                              themeProvider.isDarkMode 
                                  ? Icons.brightness_2_outlined 
                                  : Icons.brightness_7_outlined,
                            ),
                            title: Text(
                              themeProvider.isDarkMode ? 'Dark Theme' : 'Light Theme',
                            ),
                            trailing: Switch(
                              value: themeProvider.isDarkMode,
                              onChanged: (_) => themeProvider.toggleTheme(),
                            ),
                            onTap: themeProvider.toggleTheme,
                          );
                        },
                      ),
                      
                      // Account section
                      Consumer<AuthViewModel>(
                        builder: (context, authProvider, _) {
                          if (authProvider.status == AuthStatus.authenticated) {
                            return Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.account_circle),
                                  title: Text(authProvider.user?.name ?? 'Guest'),
                                  subtitle: Text(authProvider.user?.email ?? ''),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.settings),
                                  title: const Text('Settings'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    // Navigate to settings
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.logout),
                                  title: const Text('Logout'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    authProvider.logout();
                                  },
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.login),
                                  title: const Text('Log In'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    context.push('/login');
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.person_add),
                                  title: const Text('Sign Up'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    context.push('/signup');
                                  },
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Mobile Search Modal
  void _showMobileSearch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search games, categories, etc...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        // Handle search
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
            
            // Search results
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.games),
                    title: Text('Game Result $index'),
                    subtitle: Text('Game description $index'),
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to game
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mobile Account Menu
  void _showAccountMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Consumer<AuthViewModel>(
          builder: (context, authProvider, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: Text(authProvider.user?.name ?? 'Guest'),
                  subtitle: Text(authProvider.user?.email ?? ''),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to settings
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.pop(context);
                    authProvider.logout();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Mobile navigation item
  Widget _buildMobileNavItem(BuildContext context, String route, String title, IconData icon, String currentLocation) {
    final isSelected = currentLocation == route;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).colorScheme.secondaryContainer : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected 
              ? Theme.of(context).colorScheme.secondary 
              : Theme.of(context).iconTheme.color,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected 
                ? Theme.of(context).colorScheme.secondary 
                : Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          context.go(route);
        },
      ),
    );
  }
}