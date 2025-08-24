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

  String? _accessToken;
  String? get accessToken => _accessToken;

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
      _accessToken = _authRepository.accessToken;
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
        _accessToken = _authRepository.accessToken;
      } else {
        _status = AuthStatus.unauthenticated;
        if (provider == AuthProvider.server) {
          _errorMessage = 'Invalid email or password';
        } else {
          _errorMessage = 'You are not registered. Please sign up first.';
        }
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

  Future<void> logout(BuildContext context) async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();
      
      await _authRepository.logout(context);
      _user = null;
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Logout failed: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<bool> resetPassword(String newPassword) async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();
      
      final success = await _authRepository.resetPassword(newPassword);
      if (!success) {
        _errorMessage = 'Failed to send reset email. Please try again.';
        _status = AuthStatus.error;
        notifyListeners();
        return false;
      }
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Password reset failed: $e';
      debugPrint('Password reset failed: $e');
      notifyListeners();
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> requestEmail(String email) async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();
      final success = await _authRepository.requestPasswordResetEmail(email);
      if (!success) {
        _errorMessage = 'Failed to send reset email. Please try again.';
        _status = AuthStatus.error;
        notifyListeners();
        return false;
      }
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Requesting reset email failed: $e';
      debugPrint('Requesting reset email failed: $e');
      notifyListeners();
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();
      // Convert OTP to int and handle potential format errors
      otp = otp.trim();
      final intOtp = int.parse(otp);
      
      final success = await _authRepository.verifyOtp(email, intOtp);
      if (!success) {
        _errorMessage = 'Invalid OTP. Please try again.';
        _status = AuthStatus.error;
        notifyListeners();
        return false;
      }
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'OTP verification failed: $e';
      debugPrint('OTP verification failed: $e');
      notifyListeners();
      return false;
    } finally {
      notifyListeners();
    }
  }
}