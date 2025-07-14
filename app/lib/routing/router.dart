import 'package:gameverse/ui/advance_search/widgets/advance_search_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';
import 'package:gameverse/ui/auth/widgets/auth_screen.dart';
import 'package:gameverse/ui/game_detail/widgets/game_details_screen.dart';
import 'package:gameverse/ui/home/widgets/home_screen.dart';
import 'package:gameverse/ui/library/widgets/library_screen.dart';
import 'package:gameverse/ui/forums/widgets/forums_screen.dart';
import 'package:gameverse/ui/downloads/widgets/downloads_screen.dart';
import 'package:gameverse/ui/shared/widgets/main_layout.dart';
import 'routes.dart';

class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: Routes.home,
      redirect: (context, state) {
        final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
        final isLoggedIn = (authViewModel.status == AuthStatus.authenticated);
        
        // If going to login but already logged in, redirect home
        if (state.matchedLocation == Routes.login && isLoggedIn) {
          return Routes.home;
        }
        
        return null;
      },
      routes: [
        // Main shell route with persistent navigation and footer
        ShellRoute(
          builder: (context, state, child) {
            return MainLayout(child: child);
          },
          routes: [
            GoRoute(
              path: Routes.home,
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: Routes.library,
              builder: (context, state) => const LibraryScreen(),
            ),
            GoRoute(
              path: Routes.advanceSearch,
              builder: (context, state) => const AdvanceSearchScreen(),
            ),
            GoRoute(
              path: Routes.forums,
              builder: (context, state) => const ForumsScreen(),
            ),
            GoRoute(
              path: Routes.downloads,
              builder: (context, state) => const DownloadsScreen(),
            ),
            GoRoute(
              path: Routes.gameDetails,
              builder: (context, state) {
                final gameId = int.parse(state.pathParameters['id'] ?? '0');
                return GameDetailsScreen(gameId: gameId);
              },
              routes: [
                // Nested route for game details with dynamic ID
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    final gameId = int.parse(state.pathParameters['id'] ?? '0');
                    return GameDetailsScreen(gameId: gameId);
                  },
                ),
              ]
            ),
            GoRoute(
              path: Routes.login,
              builder: (context, state) => const AuthScreen(
                initialTab: 'login',
              ),
            ),
            GoRoute(
              path: Routes.signup,
              builder: (context, state) => const AuthScreen(
                initialTab: 'register',
              ),
            ),

          ],
        ),
        // Standalone login route (no shell)
      ],
    );
  }
}