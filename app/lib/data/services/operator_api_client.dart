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
      
      final raw = await _client.post(
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
      
      final raw = await _client.post(
        Uri.parse(ApiEndpoints.operatorPublisherRequests),
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
  Future<Response> approveGameRequest(String token, String requestId) async {
    try {
      final raw = await _client.post(
        Uri.parse('${ApiEndpoints.baseUrl}/game/verify'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: <String, String>{
          'gameid': requestId,
          'isapprove': '1',
        }
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
  Future<Response> approvePublisherRequest(String token, String requestId) async {
    try {
      final raw = await _client.post(
        Uri.parse('${ApiEndpoints.baseUrl}/publisher/verify'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: <String, String> {
          'publisherid': requestId,
          'isapprove': '1',
        }
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
  Future<Response> rejectGameRequest(String token, String publisherId,  String requestId, {
    required String gameName,
    required String feedback}) async {
    try {
      final raw = await _client.post(
        Uri.parse('${ApiEndpoints.baseUrl}/game/verify'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: <String, String>{
          'gameid': requestId,
          'isapprove': '0',
        }
      );

      final response = Response.fromJson(
        raw.statusCode,
        jsonDecode(raw.body) as Map<String, dynamic>,
      );
      if (response.code != 200) {
        throw Exception(response.message);
      }
      final raw2 = await _client.post(
        Uri.parse('${ApiEndpoints.baseUrl}/messages/game'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: <String, String>{
          'publisherid': publisherId,
          'gamename': gameName,
          'message': feedback,
        }
      );
      final response2 = Response.fromJson(
        raw2.statusCode,
        jsonDecode(raw2.body) as Map<String, dynamic>,
      );
      if (response2.code != 200) {
        throw Exception(response2.message);
      }
      return response2;
    } catch (e) {
      return Response(
        code: 500,
        message: e.toString(),
        data: null,
      );
    }
  }
  Future<Response> rejectPublisherRequest(String token, String requestId, {
    required String feedback}) async {
    try {
      final raw = await _client.post(
        Uri.parse('${ApiEndpoints.baseUrl}/publisher/verify'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: <String, String> {
          'publisherid': requestId,
          'isapprove': '0',
        }
      );

      final response = Response.fromJson(
        raw.statusCode,
        jsonDecode(raw.body) as Map<String, dynamic>,
      );

      if (response.code != 200) {
        throw Exception(response.message);
      }

      final raw2 = await _client.post(
        Uri.parse('${ApiEndpoints.baseUrl}/messages/publisher'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: <String, String> {
          'userid': requestId,
          'message': feedback,
        }
      );
      final response2 = Response.fromJson(
        raw2.statusCode,
        jsonDecode(raw2.body) as Map<String, dynamic>,
      );

      return response2;
    } catch (e) {
      return Response(
        code: 500,
        message: e.toString(),
        data: null,
      );
    }
  }
}