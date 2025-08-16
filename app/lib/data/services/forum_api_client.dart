import 'package:flutter/foundation.dart';
import 'package:gameverse/utils/response.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gameverse/config/api_endpoints.dart';

class ForumApiClient {
  final http.Client _client;

  ForumApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Response> getAllForums() async {
    try {
      final response = await _client.get(Uri.parse('${ApiEndpoints.baseUrl}/forum'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Response.fromJson(200, jsonData);
      }
      return Response.fromJson(response.statusCode, {'message': 'Failed to fetch forums'});
    } catch (e) {
      debugPrint('Get forums error: $e');
      return Response.fromJson(500, {'message': 'Internal server error'});
    }
  }

  Future<Response> getForum(String id) async {
    try {
      final response = await _client.get(Uri.parse('${ApiEndpoints.baseUrl}/forum/$id'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Response.fromJson(200, jsonData);
      }
      return Response.fromJson(response.statusCode, {'message': 'Failed to fetch forum'});
    } catch (e) {
      debugPrint('Get forum error: $e');
      return Response.fromJson(500, {'message': 'Internal server error'});
    }
  }
}