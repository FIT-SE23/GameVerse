import 'package:provider/provider.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';

/// Handles deep linking for the GameVerse app
/// This class listens for incoming deep links and processes them accordingly,
/// including handling authentication callbacks and navigating to specific pages.

class DeepLink {
  final _appLinks = AppLinks();
  final GoRouter _router;
  StreamSubscription<Uri>? _linkSubscription;
  final BuildContext context;
  bool _isInitialized = false;

  DeepLink(this.context, this._router) {
    _initializeDeepLinking();
  }

  void _initializeDeepLinking() {
    try {
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
      
      _isInitialized = true;
      debugPrint('Deep link handler initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize deep link handler: $e');
    }
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
    handleDeepLink(url);
  }

  /// Public method to handle deep links
  void handleDeepLink(String url) {
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
      if (!context.mounted) return;

      try {
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
          
          _showSnackBar(
            'Successfully logged in!',
            backgroundColor: Colors.green,
          );
        } else {
          debugPrint('Authentication failed or incomplete');
          _router.go('/login');
          
          _showSnackBar(
            'Login failed: ${authViewModel.errorMessage}',
            backgroundColor: Colors.red,
          );
        }
      } catch (e) {
        debugPrint('Error handling auth callback: $e');
        _router.go('/login');
        
        _showSnackBar(
          'Authentication error: $e',
          backgroundColor: Colors.red,
        );
      }
    });
  }

  void _handleOtherDeepLinks(Uri uri) {
    // Handle other types of deep links here
    // For example: gameverse://game/123 -> navigate to game details
    debugPrint('Handling other deep link: $uri');
    
    try {
      if (uri.pathSegments.isNotEmpty) {
        final path = '/${uri.pathSegments.join('/')}';
        _router.go(path);
      }
    } catch (e) {
      debugPrint('Error handling deep link: $e');
    }
  }

  void _showSnackBar(String message, {Color? backgroundColor}) {
    if (!context.mounted) return;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
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

  void dispose() {
    _linkSubscription?.cancel();
    debugPrint('Deep link handler disposed');
  }

  bool get isInitialized => _isInitialized;
}