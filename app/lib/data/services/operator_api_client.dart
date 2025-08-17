import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:gameverse/config/api_endpoints.dart';
import 'package:gameverse/utils/response.dart';

class OperatorApiClient {
  final http.Client _client;

  OperatorApiClient({http.Client? client}) : _client = client ?? http.Client();

  
  // Get all pending game requests
  Future<Response> getPendingGameRequests(String token) async {
    try {
      
      final raw = await _client.get(
        Uri.parse(ApiEndpoints.operatorGameRequests),
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
      return Response(
        code: 500,
        message: e.toString(),
        data: null,
      );
    }
  }
  Future<Response> getPendingPublisherRequests(String token) async {
    try {
      
      final raw = await _client.get(
        Uri.parse(ApiEndpoints.operatorGameRequests),
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
      return Response(
        code: 500,
        message: e.toString(),
        data: null,
      );
    }
  }
  
  // Approve a game request
  Future<Response> approveGameRequest(String token, String requestId, {String? feedback}) async {
    try {
      
      final raw = await _client.post(
        Uri.parse('${ApiEndpoints.operatorGameRequests}/$requestId/approve'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'feedback': feedback,
        }),
      );

      final response = Response.fromJson(
        raw.statusCode,
        jsonDecode(raw.body) as Map<String, dynamic>,
      );

      return response;
    } catch (e) {
      return Response(
        code: 500,
        message: e.toString(),
        data: null,
      );
    }
  }
  Future<Response> approvePublisherRequest(String token, String requestId, {String? feedback}) async {
    try {
      
      final raw = await _client.post(
        Uri.parse('${ApiEndpoints.operatorGameRequests}/$requestId/approve'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'feedback': feedback,
        }),
      );

      final response = Response.fromJson(
        raw.statusCode,
        jsonDecode(raw.body) as Map<String, dynamic>,
      );

      return response;
    } catch (e) {
      return Response(
        code: 500,
        message: e.toString(),
        data: null,
      );
    }
  }
  
  // Reject a game request
  Future<Response> rejectGameRequest(String token, String requestId, {required String feedback}) async {
    try {
      final raw = await _client.post(
        Uri.parse('${ApiEndpoints.operatorGameRequests}/$requestId/reject'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'feedback': feedback,
        }),
      );

      final response = Response.fromJson(
        raw.statusCode,
        jsonDecode(raw.body) as Map<String, dynamic>,
      );

      return response;
    } catch (e) {
      return Response(
        code: 500,
        message: e.toString(),
        data: null,
      );
    }
  }
  Future<Response> rejectPublisherRequest(String token, String requestId, {required String feedback}) async {
    try {
      final raw = await _client.post(
        Uri.parse('${ApiEndpoints.operatorGameRequests}/$requestId/reject'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'feedback': feedback,
        }),
      );

      final response = Response.fromJson(
        raw.statusCode,
        jsonDecode(raw.body) as Map<String, dynamic>,
      );

      return response;
    } catch (e) {
      return Response(
        code: 500,
        message: e.toString(),
        data: null,
      );
    }
  }
}