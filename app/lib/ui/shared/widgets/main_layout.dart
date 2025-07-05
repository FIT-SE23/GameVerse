import 'package:flutter/material.dart';

import '../../home/widgets/home_screen.dart';
import '../../library/widgets/library_screen.dart';
import '../../category/widgets/category_screen.dart';
import '../../community/widgets/community_screen.dart';
import '../../downloads/widgets/download_screen.dart';
import 'navigation_topbar.dart';

class MainLayout extends StatefulWidget {
  final int initialIndex;
  
  const MainLayout({super.key, this.initialIndex = 0});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _selectedIndex;
  
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _pages = const [
    HomeScreen(),
    LibraryScreen(),
    CategoryScreen(),
    CommunityScreen(),
    DownloadsScreen(),
  ];

  void _onNavigate(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Navigation topbar - persistent
          NavigationTopbar(
            selectedIndex: _selectedIndex,
            onNavigate: _onNavigate,
          ),
          
          // Content area - changes based on navigation
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}