import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';
import 'package:gameverse/ui/auth/widgets/login_screen.dart';
import 'package:gameverse/ui/game_detail/widgets/game_details_screen.dart';
import 'package:gameverse/ui/shared/widgets/main_layout.dart';
import 'routes.dart';

class AppRouter {
  static GoRouter createRouter(BuildContext context) {
    return GoRouter(
      initialLocation: Routes.home,
      redirect: (context, state) {
        final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
        final isLoggedIn = (authViewModel.status == AuthStatus.authenticated); 
        
        // If going to login but already logged in, redirect home
        if (state.matchedLocation == Routes.login && isLoggedIn) {
          return Routes.home;
        }
        
        // If accessing a protected route without being logged in, redirect to login
        // (Add any protected routes here)
        if (['/library'].contains(state.matchedLocation) && !isLoggedIn) {
          return Routes.login;
        }
        
        // Otherwise allow the navigation
        return null;
      },
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) => const MainLayout(initialIndex: 0),
        ),
        GoRoute(
          path: Routes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: Routes.gameDetails,
          builder: (context, state) {
            final gameId = int.parse(state.pathParameters['id'] ?? '0');
            return GameDetailsScreen(gameId: gameId);
          },
        ),
        GoRoute(
          path: Routes.library,
          builder: (context, state) => const MainLayout(initialIndex: 1),
        ),
        GoRoute(
          path: Routes.category,
          builder: (context, state) => const MainLayout(initialIndex: 2),
        ),
        GoRoute(
          path: Routes.community,
          builder: (context, state) => const MainLayout(initialIndex: 3),
        ),
        GoRoute(
          path: Routes.downloads,
          builder: (context, state) => const MainLayout(initialIndex: 4),
        ),
      ],
    );
  }

  // Legacy navigation method for backward compatibility
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const MainLayout(initialIndex: 0));
        
      case '/gameDetails':
        final gameId = (settings.arguments as int?) ?? 0;
        return MaterialPageRoute(builder: (_) => GameDetailsScreen(gameId: gameId));
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}