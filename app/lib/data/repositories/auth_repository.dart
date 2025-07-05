import 'dart:async';
// import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:gameverse/domain/models/user_model/user_model.dart';

enum AuthProvider { supabase, google }

class AuthRepository {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  
  AuthProvider? _lastUsedProvider;
  UserModel? _currentUser;
  String? _accessToken;
  
  // Getters
  String? get accessToken => _accessToken;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  
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
  Future<UserModel?> loginWithSupabase(String email, String password) async {
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
        return _currentUser;
      }
      return null;
    } catch (e) {
      debugPrint('Supabase login error: $e');
      return null;
    }
  }

  // Login with Google
  Future<UserModel?> loginWithGoogle() async {
    try {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'gameverse://auth-callback',
        authScreenLaunchMode:
            kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication, // Launch the auth screen in a new webview on mobile.
      );

      return await checkSession();
    } catch (e) {
      debugPrint('Google login error: $e');
      return null;
    }
  }

  // Generic login that selects appropriate method
  Future<UserModel?> login({AuthProvider provider = AuthProvider.supabase}) async {
    switch (provider) {
      case AuthProvider.supabase:
        // This is just a demo login - in real app, you'd show a login form
        return await loginWithSupabase('demo@example.com', 'password123');
      case AuthProvider.google:
        return await loginWithGoogle();
    }
  }

  Future<void> logout() async {
    try {
      switch (_lastUsedProvider) {
        case AuthProvider.supabase:
          await supabase.auth.signOut();
          break;
        case AuthProvider.google:
          await _googleSignIn.signOut();
          await supabase.auth.signOut();
          break;
        default:
          // Just in case, try to clean up everything
          await supabase.auth.signOut();
          await _googleSignIn.signOut();
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