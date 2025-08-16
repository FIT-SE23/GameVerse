import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import "package:crypto/crypto.dart";

import 'package:gameverse/config/api_endpoints.dart';
import 'package:gameverse/utils/response.dart';

class AuthApiClient {
  final http.Client _client;
  
  AuthApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Response> login(String email, String password) async {
    final bytePassword = utf8.encode(password);
    final hashPassword = sha256.convert(bytePassword).toString();

    final raw = await _client.post(
      Uri.parse(ApiEndpoints.loginUrl),
      body: <String, String>{"email": email, "password": hashPassword},
    );

    final response = Response.fromJson(
      raw.statusCode,
      jsonDecode(raw.body) as Map<String, dynamic>,
    );

    return response;
  }

  Future<Response> register(String username, String email, String password) async {
    final bytePassword = utf8.encode(password);
    final hashPassword = sha256.convert(bytePassword).toString();

    final raw = await _client.post(
      Uri.parse(ApiEndpoints.registerUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: <String, String>{
        "username": username,
        "email": email,
        "password": hashPassword,
      },
    );

    final response = Response.fromJson(
      raw.statusCode,
      jsonDecode(raw.body) as Map<String, dynamic>,
    );

    return response;
  }
  
  Future<Response> getProfile(String token, String userId) async {
    final raw = await _client.get(
      Uri.parse('${ApiEndpoints.userUrl}/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final response = Response.fromJson(
      raw.statusCode,
      jsonDecode(raw.body) as Map<String, dynamic>,
    );

    return response;
  }
    
  // Verify token is still valid
  Future<bool> verifyToken(String token) async {
    try {
      // You'll need to add a token verification endpoint on your server
      final response = await _client.get(
        Uri.parse('${ApiEndpoints.baseUrl}/verify-token'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['code'] == 200;
      }
      return false;
    } catch (e) {
      debugPrint('Token verification error: $e');
      return false;
    }
  }

  Future<Response> verifyOauthToken(String token) async {
    try {
      final raw = await _client.post(
        Uri.parse('${ApiEndpoints.baseUrl}/verify-oauth-token'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final response = Response.fromJson(
        raw.statusCode,
        jsonDecode(raw.body) as Map<String, dynamic>,
      );
      return response;
    } catch (e) {
      debugPrint('OAuth token verification error: $e');
      return Response(code: 500, message: 'Internal Server Error', data: {});
    }
  }
}