import 'package:gameverse/ui/advance_search/widgets/advance_search_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';
import 'package:gameverse/ui/auth/widgets/auth_screen.dart';
import 'package:gameverse/ui/auth/widgets/auth_callback_screen.dart';
import 'package:gameverse/ui/game_detail/widgets/game_details_screen.dart';
import 'package:gameverse/ui/home/widgets/home_screen.dart';
import 'package:gameverse/ui/library/widgets/library_screen.dart';
import 'package:gameverse/ui/forums/widgets/forums_screen.dart';
import 'package:gameverse/ui/downloads/widgets/downloads_screen.dart';
import 'package:gameverse/ui/shared/widgets/main_layout.dart';
import 'package:gameverse/ui/profile/widgets/profile_screen.dart';
import 'package:gameverse/ui/settings/widgets/settings_screen.dart';
import 'package:gameverse/ui/post/widgets/post_screen.dart';
import 'package:gameverse/ui/forum_posts/widgets/forum_posts_screen.dart';
import 'package:gameverse/ui/transactions/widgets/transaction_screen.dart';

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

        // Guard against accessing protected routes when not logged in
        if (!isLoggedIn && 
            (state.matchedLocation == Routes.settings ||
             state.matchedLocation == Routes.profile ||
             state.matchedLocation == Routes.transactions)) {
          return Routes.login;
        }
        
        return null;
      },
            routes: [
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
              path: Routes.settings,
              builder: (context, state) => const SettingsScreen(),
            ),
            GoRoute(
              path: Routes.gameDetails,
              builder: (context, state) {
                final gameId = int.parse(state.pathParameters['id'] ?? '0');
                return GameDetailsScreen(gameId: gameId);
              },
              routes: [
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
              path: Routes.profile,
              builder: (context, state) => const ProfileScreen(),
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
                initialTab: 'signup',
              ),
            ),
            GoRoute(
              path: Routes.transactions,
              builder: (context, state) => const TransactionScreen(),
            ),
          ],
        ),
        
        // Forum routes (outside main layout for better navigation)
        GoRoute(
          path: '/forum-posts/:gameId/:gameName',
          builder: (context, state) {
            final gameId = state.pathParameters['gameId']!;
            final gameName = Uri.decodeComponent(state.pathParameters['gameName']!);
            return ForumPostsScreen(gameId: gameId, gameName: gameName);
          },
        ),
        GoRoute(
          path: '/post/:postId',
          builder: (context, state) {
            final postId = state.pathParameters['postId']!;
            return PostScreen(postId: postId);
          },
        ),
        
        // Auth routes
        GoRoute(
          path: Routes.authCallback,
          builder: (context, state) => const AuthCallbackScreen(),
        ),
      ],
    );
  }
}