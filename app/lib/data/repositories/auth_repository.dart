import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:gameverse/utils/response.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:gameverse/domain/models/user_model/user_model.dart';
import 'package:gameverse/data/services/auth_api_client.dart';
import 'package:gameverse/data/services/secure_storage_service.dart';


enum AuthProvider { server, google, facebook }

class AuthRepository {
  final AuthApiClient _apiClient;
  UserModel? _currentUser;
  String? _accessToken;
  
  AuthRepository({AuthApiClient? apiClient}) : _apiClient = apiClient ?? AuthApiClient();
  
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
      url: String.fromEnvironment('SUPABASE_URL'),
      anonKey: String.fromEnvironment('SUPABASE_ANON_KEY'),
      debug: false,
    );
  }

  Future<UserModel?> checkSession() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) {
        return null;
      }

      final isValid = await _apiClient.verifyToken(token);
      if (!isValid) {
        await SecureStorageService.clearAuthData();
        return null;
      }

      // Get stored user data
      final userData = await SecureStorageService.getUserId();
      if (userData != null) {
        _currentUser = UserModel(
          id: userData,
          username: '', // Fetch from server
          email: '', // Fetch from server
          type: 'user', // Default type, can be updated later
        );
        _accessToken = token;
        return _currentUser;
      }

      return null;
    } catch (e) {
      debugPrint('Error restoring session: $e');
      await SecureStorageService.clearAuthData();
      return null;
    }
  }

  // Login with server
  Future<UserModel?> loginWithServer(String email, String password) async {
    try {
      final Response result = await _apiClient.login(email, password);
      if (result.code == 200) {
        final token = result.data['token'] as String;
        final userId = result.data['userid'] as String;

        // Save to secure storage
        await SecureStorageService.saveAuthData(
          token: token,
          userId: userId,
        );
        final response = await _apiClient.getProfile(token, userId);
        if (response.code == 200) {
          _currentUser = UserModel.fromJson(response.data);
          _accessToken = token;
          return _currentUser;
        } else {
          debugPrint('Get profile error: ${response.message}');
        }
      }
      return null;
    } catch (e) {
      debugPrint('Server login error: $e');
      rethrow;
    }
  }

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
  Future<UserModel?> login(AuthProvider provider, {
    String email = '',
    String password = '',
  }) async {
    switch (provider) {
      case AuthProvider.server:
        return await loginWithServer(email, password);
      case AuthProvider.google:
        await loginWithGoogle();
        // Wait for deep link callback to handle session
        return null; // Session will be handled in the callback
      case AuthProvider.facebook:
        await loginWithFacebook();
        // Wait for deep link callback to handle session
        return null; // Session will be handled in the callback
    }
  }

  Future<void> logout() async {
    try {
      // Clear local data
      _currentUser = null;
      _accessToken = null;
      
      // Clear secure storage
      await SecureStorageService.clearAuthData();
      await supabase.auth.signOut();
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }
  
  // Register new user with server
  Future<bool> register(String username, String email, String password) async {
    try {
      final Response result = await _apiClient.register(username, email, password);
      if (result.code == 200) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Register error: $e');
      return false;
    }
  }
}