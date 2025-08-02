import 'dart:async';
// import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:gameverse/domain/models/user_model/user_model.dart';

enum AuthProvider { supabase, google, facebook }

class AuthRepository {
  AuthProvider? _lastUsedProvider;
  UserModel? _currentUser;
  String? _accessToken;
  
  // Getters
  String? get accessToken => _accessToken;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  // Get appropriate redirect URL based on platform
  String get _redirectUrl {
    if (kIsWeb) {
      // For web, use the current origin + callback path
      return '${Uri.base.origin}/auth-callback';
    } else {
      // For desktop/mobile, use custom URL scheme
      return 'gameverse://auth-callback';
    }
  }
  
  // Supabase client getter
  SupabaseClient get supabase => Supabase.instance.client;

  // Initialize Supabase - call this before using auth
  static Future<void> initializeSupabase() async {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
      debug: false,
    );
  }

  // Check if user is already logged in
  Future<UserModel?> checkSession() async {
    try {
      // Try restoring Supabase session
      final session = supabase.auth.currentSession;
      if (session != null) {
        final user = supabase.auth.currentUser;
        if (user != null) {
          _currentUser = UserModel(
            id: user.id,
            name: user.userMetadata?['full_name'] ?? user.email?.split('@')[0] ?? 'User',
            email: user.email ?? '',
          );
          _lastUsedProvider = AuthProvider.supabase;
          _accessToken = session.accessToken;
          return _currentUser;
        }
      }
      
      return null;
    } catch (e) {
      debugPrint('Error restoring session: $e');
      return null;
    }
  }

  // Login with Supabase (email/password)
  Future<void> loginWithSupabase(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      // Print debug info
      debugPrint('Supabase login response: $response');

      if (response.user != null) {
        _currentUser = UserModel(
          id: response.user!.id,
          name: response.user!.userMetadata?['full_name'] ?? email.split('@')[0],
          email: email,
        );
        _lastUsedProvider = AuthProvider.supabase;
        _accessToken = response.session?.accessToken;
      }
    } catch (e) {
      debugPrint('Supabase login error: $e');
    }
  }

  // Login with Google
  Future<void> loginWithGoogle() async {
    try {
      debugPrint('Starting Google OAuth...');

      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: _redirectUrl,
        authScreenLaunchMode:
          kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
      );
      debugPrint('OAuth initiated, session will be handled by deep link callback');

    } catch (e) {
      debugPrint('Google login error: $e');
    }
  }
  // Login with Facebook
  Future<void> loginWithFacebook() async {
    try {
      debugPrint('Starting Facebook OAuth...');

      // Desktop/Mobile flow - use custom scheme
      await supabase.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: _redirectUrl,
        authScreenLaunchMode: 
          kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
      );
      debugPrint('OAuth initiated, session will be handled by deep link callback');
    } catch (e) {
      debugPrint('Google login error: $e');
    }
  }

  // Generic login that selects appropriate method
  Future<void> login(AuthProvider provider, {
    String email = '',
    String password = '',
  }) async {
    switch (provider) {
      case AuthProvider.supabase:
        return await loginWithSupabase(email, password);
      case AuthProvider.google:
        return await loginWithGoogle();
      case AuthProvider.facebook:
        return await loginWithFacebook();
    }
  }

  Future<void> logout() async {
    try {
      switch (_lastUsedProvider) {
        case AuthProvider.supabase:
          await supabase.auth.signOut();
          break;
        case AuthProvider.google:
          await supabase.auth.signOut();
          break;
        default:
          await supabase.auth.signOut();
          break;
      }
      
      _currentUser = null;
      _accessToken = null;
      _lastUsedProvider = null;
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }
  
  // Register new user with Supabase
  Future<UserModel?> register(String email, String password, String name) async {
    try {
      final response = await supabase.auth.signUp(
        email: email, 
        password: password,
        data: {'full_name': name},
      );
      
      if (response.user != null) {
        _currentUser = UserModel(
          id: response.user!.id,
          name: name,
          email: email,
        );
        _lastUsedProvider = AuthProvider.supabase;
        _accessToken = response.session?.accessToken;
        return _currentUser;
      }
      return null;
    } catch (e) {
      debugPrint('Register error: $e');
      return null;
    }
  }
  
  // String _generateRandomString(int length) {
  //   const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  //   final random = Random.secure();
  //   return List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();
  // }
}