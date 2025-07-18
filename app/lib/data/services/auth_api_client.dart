import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:gameverse/domain/models/user_model/user_model.dart';

class AuthApiClient {
  final http.Client _client;
  final String baseUrl;
  
  AuthApiClient({
    http.Client? client,
    required this.baseUrl,
  }) : _client = client ?? http.Client();

  // Login with email and password
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return UserModel.fromJson(jsonData['user']);
      } else {
        debugPrint('Login failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Login error: $e');
      return null;
    }
  }
  
  // Register new user
  Future<UserModel?> register(String email, String password, String name) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'name': name,
        }),
      );
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return UserModel.fromJson(jsonData['user']);
      } else {
        debugPrint('Registration failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Registration error: $e');
      return null;
    }
  }
  
  // Get user profile
  Future<UserModel?> getProfile(String token) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return UserModel.fromJson(jsonData);
      } else {
        debugPrint('Get profile failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Get profile error: $e');
      return null;
    }
  }
}