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
    wideScreen = MediaQuery.of(context).size.width > 1100;
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;

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