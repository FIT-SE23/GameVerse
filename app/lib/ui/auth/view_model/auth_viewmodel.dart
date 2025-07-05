import 'package:flutter/material.dart';

import 'package:gameverse/data/repositories/auth_repository.dart';
import 'package:gameverse/domain/models/user_model/user_model.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  
  AuthViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository;
  
  AuthStatus _status = AuthStatus.initial;
  AuthStatus get status => _status;
  
  UserModel? _user;
  UserModel? get user => _user;
  
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Initialize the view model and check existing session
  Future<void> init() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      _user = await _authRepository.checkSession();
      _status = _user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Session check failed: $e';
    }
    
    notifyListeners();
  }

  // Login with Supabase email/password (default)
  Future<void> login({AuthProvider provider = AuthProvider.google}) async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();
      
      _user = await _authRepository.login(provider: provider);
      
      if (_user != null) {
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
        _errorMessage = 'Login failed: No user data returned';
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Login failed: $e';
      debugPrint('Authentication error: $_errorMessage');
    } finally {
      notifyListeners();
    }
  }
  
  // Register new user
  Future<void> register(String email, String password, String name) async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();
      
      _user = await _authRepository.register(email, password, name);
      
      if (_user != null) {
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
        _errorMessage = 'Registration failed: No user data returned';
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Registration failed: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();
      
      await _authRepository.logout();
      _user = null;
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Logout failed: $e';
    } finally {
      notifyListeners();
    }
  }
}