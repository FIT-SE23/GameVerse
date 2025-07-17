import 'package:flutter/material.dart';
import 'package:gameverse/ui/shared/theme_viewmodel.dart';
import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NavigationTopbar extends StatefulWidget {
  final Function(String) onNavigate;

  const NavigationTopbar({
    super.key, 
    required this.onNavigate,
  });

  @override
  State<NavigationTopbar> createState() => _NavigationTopbarState();
}

class _NavigationTopbarState extends State<NavigationTopbar> {
  bool wideScreen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    wideScreen = MediaQuery.of(context).size.width > 1200;
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;

    if (wideScreen) {
      return _buildDesktopNavbar(context, currentLocation);
    } else {
      return _buildMobileNavbar(context, currentLocation);
    }
  }

  // Desktop Navigation Bar
  Widget _buildDesktopNavbar(BuildContext context, String currentLocation) {
    return Container(
      height: 60,
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo/header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(
              'GameVerse',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Navigation items
          Row(
            children: [
              _buildNavItem(context, '/', 'Home', Icons.home, currentLocation),
              _buildNavItem(context, '/library', 'Library', Icons.games, currentLocation),
              _buildNavItem(context, '/forums', 'Forums', Icons.forum, currentLocation),
              _buildNavItem(context, '/downloads', 'Downloads', Icons.download, currentLocation),
            ],
          ),
          
          // Search bar
          Container(
            width: 300,
            height: 35,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  onTap: () => controller.openView(),
                  onChanged: (_) => controller.openView(),
                  leading: const Icon(Icons.search, size: 20),
                  hintText: 'Search games...',
                  hintStyle: const WidgetStatePropertyAll<TextStyle>(
                    TextStyle(color: Color.fromARGB(179, 150, 150, 150), fontSize: 14),
                  ),
                );
              },
              suggestionsBuilder: (BuildContext context, SearchController controller) {
                return _buildSearchSuggestions(controller);
              },
            ),
          ),
          
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
          
          // Account section
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _buildAccountSection(context),
          ),
        ],
      ),
    );
  }

  // Mobile Navigation Bar (with drawer button)
  Widget _buildMobileNavbar(BuildContext context, String currentLocation) {
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
              child: Text(
                'GameVerse',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).appBarTheme.foregroundColor,
                ),
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
                    widget.onNavigate('/login');
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
                                    widget.onNavigate('/login');
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.person_add),
                                  title: const Text('Sign Up'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    widget.onNavigate('/signup');
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

  // Desktop navigation item
  Widget _buildNavItem(BuildContext context, String route, String title, IconData icon, String currentLocation) {
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
        onTap: () => widget.onNavigate(route),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected 
                    ? Theme.of(context).colorScheme.secondary 
                    : Theme.of(context).appBarTheme.foregroundColor,
              ),
              const SizedBox(width: 8),
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
          widget.onNavigate(route);
        },
      ),
    );
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
        } else {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                onPressed: () => widget.onNavigate('/login'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('Log In'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => widget.onNavigate('/signup'),
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
}