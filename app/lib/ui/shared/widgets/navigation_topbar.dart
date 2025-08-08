import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'desktop_navbar.dart';
import 'mobile_navbar.dart';
class NavigationTopbar extends StatefulWidget {

  const NavigationTopbar({
    super.key,
  });

  @override
  State<NavigationTopbar> createState() => _NavigationTopbarState();
}

class _NavigationTopbarState extends State<NavigationTopbar> {
  bool wideScreen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    wideScreen = MediaQuery.sizeOf(context).width > 1200;
  }

  @override
  Widget build(BuildContext context) {
    // Get the current location from the GoRouter
    final currentLocation = GoRouterState.of(context).uri.toString();

    if (wideScreen) {
      return DesktopNavbar(
        currentLocation: currentLocation,
      );
    } else {
      return MobileNavbar(
        currentLocation: currentLocation,
      );
    }
  }
}