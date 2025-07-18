import 'dart:io';
import 'dart:async';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:app_links/app_links.dart';

import 'package:gameverse/data/repositories/auth_repository.dart';
import 'package:gameverse/ui/shared/theme_viewmodel.dart';
import 'package:gameverse/routing/router.dart';
import 'package:gameverse/config/config.dart';
import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';
import 'package:gameverse/config/url_protocol/api.dart';
void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load();
  } catch (e) {
    debugPrint('Failed to load .env file: $e');
  }
  
  try {
    await AuthRepository.initializeSupabase();
  } catch (e) {
    debugPrint('Failed to initialize Supabase: $e');
  }
  
  // Register the custom URL protocol for Windows
  if (Platform.isWindows && !kIsWeb) {
    try {
      registerProtocolHandler(
        'gameverse',
        arguments: ['%s'],
      );
      debugPrint('Protocol handler registered successfully');
    } catch (e) {
      debugPrint('Failed to register protocol handler: $e');
    }
  }
  
  // Check if app was opened with a URL from command line args
  String? initialDeepLink;
  if (Platform.isWindows && args.isNotEmpty) {
    for (final arg in args) {
      if (arg.startsWith('--url=') || arg.startsWith('gameverse://')) {
        initialDeepLink = arg.startsWith('--url=') 
            ? arg.substring('--url='.length) 
            : arg;
        break;
      }
    }
  }

  runApp(MultiProvider(
    providers: appProviders(),
    child: MyApp(initialDeepLink: initialDeepLink),
  ));

  // Set minimum window size only for desktop platforms
  if (!kIsWeb) {
    doWhenWindowReady(() {
      const minSize = Size(300, 400);
      const initialSize = Size(1400, 800);
      appWindow.minSize = minSize;
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;

      appWindow.show();
    });
  }
}

class MyApp extends StatefulWidget {
  final String? initialDeepLink;
  
  const MyApp({super.key, this.initialDeepLink});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  final GlobalKey<ScaffoldMessengerState> _navigatorKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter();
    _appLinks = AppLinks();
    
    // Initialize deep link handling
    if (!kIsWeb) {
      _initializeDeepLinking();
    }

    // Handle initial deep link if present
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialDeepLink != null) {
        _handleDeepLink(widget.initialDeepLink!);
      }
      
      _initializeAuth();
    });
  }

  Future<void> _initializeAuth() async {
    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      await authViewModel.init();
    } catch (e) {
      debugPrint('Failed to initialize auth: $e');
    }
  }

  void _initializeDeepLinking() {
    // Handle incoming links when the app is already running
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        debugPrint('Received deep link while app running: $uri');
        _handleDeepLinkUri(uri);
      },
      onError: (err) {
        debugPrint('Deep link error: $err');
      },
    );

    // Handle initial link when app is launched from a link
    _handleInitialLink();
  }

  Future<void> _handleInitialLink() async {
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        debugPrint('App launched with deep link: $initialUri');
        _handleDeepLinkUri(initialUri);
      }
    } catch (err) {
      debugPrint('Failed to get initial link: $err');
    }
  }

  void _handleDeepLinkUri(Uri uri) {
    final url = uri.toString();
    _handleDeepLink(url);
  }

  void _handleDeepLink(String url) {
    debugPrint('Handling deep link: $url');
    
    final uri = Uri.tryParse(url);
    if (uri == null) {
      debugPrint('Invalid URI: $url');
      return;
    }

    // Handle auth callback
    if (uri.scheme == 'gameverse' && uri.host == 'auth-callback') {
      _handleAuthCallback(uri);
      return;
    }

    // Handle other deep link patterns
    _handleOtherDeepLinks(uri);
  }

  void _handleAuthCallback(Uri uri) {
    debugPrint('Processing auth callback: $uri');
    
    // Extract parameters from the callback URL
    final params = uri.queryParameters;
    debugPrint('Auth callback parameters: $params');

    // Give Supabase time to process the callback and establish session
    Future.delayed(const Duration(milliseconds: 500), () async {
      if (!mounted) return;

      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      
      // Force refresh the auth state
      await authViewModel.init();
      
      // Wait a bit more and check again if needed
      if (authViewModel.status != AuthStatus.authenticated) {
        await Future.delayed(const Duration(seconds: 2));
        await authViewModel.init();
      }

      // Navigate based on auth status
      if (authViewModel.status == AuthStatus.authenticated) {
        debugPrint('Authentication successful, navigating to home');
        _router.go('/');
        
        // Show success message using the navigatorKey
        _showSnackBar(
          'Successfully logged in!',
          backgroundColor: Colors.green,
        );
      } else {
        debugPrint('Authentication failed or incomplete');
        _router.go('/login');
        
        // Show error message using the navigatorKey
        _showSnackBar(
          'Login failed: ${authViewModel.errorMessage}',
          backgroundColor: Colors.red,
        );
      }
    });
  }

  void _showSnackBar(String message, {Color? backgroundColor}) {
    // Use a post-frame callback to ensure the widget tree is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _navigatorKey.currentContext;
      if (context != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: backgroundColor,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  void _handleOtherDeepLinks(Uri uri) {
    // Handle other deep link patterns if needed
    switch (uri.host) {
      case 'game':
        final gameId = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
        if (gameId != null) {
          _router.go('/game-details/$gameId');
        }
        break;
      case 'library':
        _router.go('/library');
        break;
      case 'forums':
        _router.go('/forums');
        break;
      case 'downloads':
        _router.go('/downloads');
        break;
      default:
        debugPrint('Unhandled deep link: $uri');
        _router.go('/');
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeViewModel themeProvider = Provider.of<ThemeViewModel>(context);

    return MaterialApp.router(
      title: 'GameVerse',
      scaffoldMessengerKey: _navigatorKey,
      theme: themeProvider.isDarkMode
          ? AppTheme.darkTheme
          : AppTheme.lightTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}