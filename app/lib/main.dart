import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:gameverse/data/repositories/auth_repository.dart';
import 'package:gameverse/ui/shared/theme_viewmodel.dart';
import 'package:gameverse/routing/router.dart';
import 'package:gameverse/config/config.dart';
import 'package:gameverse/config/url_protocol/api.dart';
import 'package:gameverse/utils/deeplink.dart';
import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';

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
  if (!kIsWeb && Platform.isWindows) {
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
  if (!kIsWeb && Platform.isWindows && args.isNotEmpty) {
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
      const minSize = Size(400, 400);
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
  DeepLink? deepLinkHandler; // Make it nullable
  final GlobalKey<ScaffoldMessengerState> _navigatorKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter();
    
    // Initialize deep link handling AFTER the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    // Initialize auth first
    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      await authViewModel.init();
    } catch (e) {
      debugPrint('Failed to initialize auth: $e');
    }

    // Initialize deep link handling only for desktop
    if (!kIsWeb && mounted) {
      try {
          deepLinkHandler = DeepLink(context, _router);
          // Handle initial deep link if present
          if (widget.initialDeepLink != null) {
            deepLinkHandler!.handleDeepLink(widget.initialDeepLink!);
          }
      } catch (e) {
        debugPrint('Failed to initialize deep link handler: $e');
      }
    }
  }

  @override
  void dispose() {
    deepLinkHandler?.dispose();
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