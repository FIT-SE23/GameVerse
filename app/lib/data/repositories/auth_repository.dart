import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gameverse/data/repositories/game_repository.dart';
import 'package:gameverse/ui/settings/view_model/settings_viewmodel.dart';
import 'package:gameverse/utils/response.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:gameverse/domain/models/user_model/user_model.dart';
import 'package:gameverse/data/services/auth_api_client.dart';
import 'package:gameverse/data/services/secure_storage_service.dart';
import 'package:gameverse/ui/home/view_model/home_viewmodel.dart';



enum AuthProvider { server, google, facebook }

class AuthRepository {
  final AuthApiClient _apiClient;
  UserModel? _currentUser;
  String _accessToken = '';
  
  AuthRepository({AuthApiClient? apiClient}) : _apiClient = apiClient ?? AuthApiClient();
  
  // Getters
  String get accessToken => _accessToken;
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
    const String envUrl = String.fromEnvironment('SUPABASE_URL');
    const String envAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    await Supabase.initialize(
      url: envUrl,
      anonKey: envAnonKey,
      debug: false,
    );
  }

  Future<UserModel?> checkSession() async {
    try {
      // final token = await SecureStorageService.getToken();
      // debugPrint('Checking session with token: $token');
      // if (token != null && token.isNotEmpty) {
      //   final isValid = await _apiClient.verifyToken(token);
      //   debugPrint('Token validity: $isValid');
      //   if (!isValid) {
      //     await SecureStorageService.clearAuthData();
      //     return null;
      //   }

      //   // Get stored user data
      //   final userData = await SecureStorageService.getUserId();
      //   if (userData != null) {
      //     _currentUser = UserModel(
      //       id: userData,
      //       username: '', // Fetch from server
      //       email: '', // Fetch from server
      //       type: 'user', // Default type, can be updated later
      //     );
      //     _accessToken = token;
      //     return _currentUser;
      //   }
      // }

      // If not found, check supabase session
      final session = supabase.auth.currentSession;
      if (session != null) {
        // First verify token 
        final result = await _apiClient.verifyOauthToken(session.user.email!);
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
          return _currentUser;
        }
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

  Future<void> logout(BuildContext context) async {
    try {
      // Clear local data
      _currentUser = null;
      _accessToken = '';
      final GameRepository gameRepository = Provider.of<GameRepository>(context, listen: false);
      final HomeViewModel homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
      final SettingsViewModel settingsViewModel = Provider.of<SettingsViewModel>(context, listen: false);
      
      // Clear secure storage
      await SecureStorageService.clearAuthData();
      await supabase.auth.signOut();
      gameRepository.clearCache();
      homeViewModel.loadHomePageData(settingsViewModel.downloadPath);
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

  Future<bool> requestPasswordResetEmail(String email) async {
    try {
      final Response result = await _apiClient.requestPasswordResetEmail(email);
      if (result.code == 200) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Request password reset email error: $e');
      return false;
    }
  }

  Future<bool> verifyOtp(String email, int otp) async {
    try {
      final Response result = await _apiClient.verifyOtp(email, otp);
      if (result.code == 200) {
        _currentUser = UserModel(
          id: result.data['userid'],
          username: "",
          email: email,
          type: 'user',
        );
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Verify OTP error: $e');
      return false;
    }
  }

  Future<bool> resetPassword(String password) async {
    try {
      final Response result = await _apiClient.resetPassword(currentUser!.id, password);
      if (result.code == 200) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Reset password error: $e');
      return false;
    }
  }
}