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

  bool _isRegistered = false;

  bool _isPublisher = false;
  bool get isPublisher => _isPublisher;
  
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

  // Login with provider
  Future<void> login(AuthProvider provider, {
    String email = '',
    String password = '',
  }) async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = '';
      notifyListeners();

      _user = await _authRepository.login(provider, email: email, password: password);
      if (_user != null) {
        _status = AuthStatus.authenticated;
        _isPublisher = (_user?.type == 'publisher');
      } else {
        _status = AuthStatus.unauthenticated;
        _errorMessage = 'Login failed: Invalid credentials';
      }

    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Login failed: $e';
      debugPrint('Authentication error: $e');
    } finally {
      notifyListeners();
    }
  }
  
  // Register new user
  Future<bool> register(String username, String email, String password) async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();
      
      _isRegistered = await _authRepository.register(username, email, password);
      
      if (!_isRegistered) {
        _errorMessage = 'Registration failed: Email already exists or invalid data';
        _status = AuthStatus.error;
        notifyListeners();
        return false;
      }
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Registration failed: $e';
      debugPrint('Registration failed: $e');
      notifyListeners();
      return false;
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