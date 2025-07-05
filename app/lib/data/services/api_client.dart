import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiResponse<T> {
  final T? data;
  final String? error;
  final int statusCode;

  ApiResponse({
    this.data,
    this.error,
    required this.statusCode,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

class ApiClient {
  final http.Client _client;
  final String baseUrl;
  final Map<String, String> _defaultHeaders;
  // final String? _authToken;
  
  ApiClient({
    http.Client? client,
    required this.baseUrl,
    String? authToken,
    Map<String, String>? defaultHeaders,
  }) : 
    _client = client ?? http.Client(),
    // _authToken = authToken,
    _defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (authToken != null) 'Authorization': 'Bearer $authToken',
      ...?defaultHeaders,
    };

  Map<String, String> get headers => _defaultHeaders;

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParams?.map((key, value) => MapEntry(key, value.toString())),
      );
      
      final response = await _client.get(uri, headers: _defaultHeaders);
      
      return _handleResponse(response, fromJson);
    } catch (e) {
      debugPrint('API GET Error: $e');
      return ApiResponse(
        error: 'Network error: $e',
        statusCode: 500,
      );
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await _client.post(
        uri, 
        headers: _defaultHeaders,
        body: body != null ? json.encode(body) : null,
      );
      
      return _handleResponse(response, fromJson);
    } catch (e) {
      debugPrint('API POST Error: $e');
      return ApiResponse(
        error: 'Network error: $e',
        statusCode: 500,
      );
    }
  }
  
  Future<ApiResponse<List<T>>> getList<T>(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParams?.map((key, value) => MapEntry(key, value.toString())),
      );
      
      final response = await _client.get(uri, headers: _defaultHeaders);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final data = jsonData
              .map((item) => fromJson(item as Map<String, dynamic>))
              .toList();
          return ApiResponse(data: data, statusCode: response.statusCode);
        } else {
          return ApiResponse(
            error: 'Expected list but got ${jsonData.runtimeType}',
            statusCode: response.statusCode,
          );
        }
      } else {
        return ApiResponse(
          error: 'API Error: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('API GET List Error: $e');
      return ApiResponse(
        error: 'Network error: $e',
        statusCode: 500,
      );
    }
  }

  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final jsonData = json.decode(response.body);
        final data = fromJson(jsonData);
        return ApiResponse(data: data, statusCode: response.statusCode);
      } catch (e) {
        debugPrint('JSON parsing error: $e');
        return ApiResponse(
          error: 'Failed to parse response: $e',
          statusCode: response.statusCode,
        );
      }
    } else {
      return ApiResponse(
        error: 'API Error: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }
}