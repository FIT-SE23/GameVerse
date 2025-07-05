import 'package:flutter/material.dart';
import 'package:gameverse/ui/shared/theme_viewmodel.dart';
import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class NavigationTopbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onNavigate;

  const NavigationTopbar({
    super.key, 
    required this.selectedIndex,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
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
          _buildNavItem(context, 0, 'Home', Icons.home),
          _buildNavItem(context, 1, 'Library', Icons.games),
          _buildNavItem(context, 2, 'Category', Icons.category),
          _buildNavItem(context, 3, 'Community', Icons.people),
          _buildNavItem(context, 4, 'Downloads', Icons.download),
          
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
                    // setState(() {
                    //   controller.closeView(item);
                    // });
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
          // Account icon
        
          Consumer<AuthViewModel>(
            builder: (context, authProvider, _) {
              if (authProvider.status == AuthStatus.authenticated) {
                return Container(
                  width: 140,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // CircleAvatar(
                      //   backgroundImage: NetworkImage(authProvider.userProfile?.avatarUrl ?? ''),
                      //   radius: 12,
                      // ),
                      Icon(
                        Icons.account_circle,
                        color: Theme.of(context).appBarTheme.foregroundColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        authProvider.user?.name ?? 'Guest',
                        style: TextStyle(
                          color: Theme.of(context).appBarTheme.foregroundColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: authProvider.login, 
                    // style: Theme.of(context).elevatedButtonTheme.style,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Theme.of(context).appBarTheme.backgroundColor),
                    ),
                    child: const Text('Log In'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: authProvider.login, 
                    // style: Theme.of(context).elevatedButtonTheme.style,
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

  Widget _buildNavItem(BuildContext context, int index, String title, IconData icon) {
    final isSelected = selectedIndex == index;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected ? Theme.of(context).colorScheme.secondary : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child:
        InkWell(
          onTap: () {
            // Handle navigation
            onNavigate(index);
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