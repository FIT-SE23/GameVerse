import 'package:gameverse/utils/response.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gameverse/config/api_endpoints.dart';

class CommentApiClient {
  final http.Client _client;

  CommentApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Response> addComment(
    String token,
    String postId,
    String content
  ) async {
    final raw = await _client.post(
      Uri.parse("${ApiEndpoints.baseUrl}/comment"),
      headers: {"Authorization": "Bearer $token"},
      body: {
        "postid": postId,
        "content": content,
      }
    );

    return Response.fromJson(raw.statusCode, jsonDecode(raw.body) as Map<String, dynamic>);
  }

  Future<Response> getComment(String commentId) async {
    final raw = await _client.get(Uri.parse("${ApiEndpoints.baseUrl}/comment/$commentId"));

    var jsonBody;
    try {
      jsonBody = jsonDecode(raw.body);
    } on FormatException catch (e) {
      return Response.fromJson(400, {"message": e.message});
    }

    final response = Response.fromJson(raw.statusCode, jsonBody as Map<String, dynamic>);
    return response;
  }

  Future<Response> updateComment(
    String token,
    String commentId,
    String content
  ) async {
    final raw = await _client.patch(
      Uri.parse("${ApiEndpoints.baseUrl}/comment/$commentId"),
      headers: {"Authorization": "Bearer $token"},
      body: {"content": content}
    );

    return Response.fromJson(raw.statusCode, jsonDecode(raw.body) as Map<String, dynamic>);
  }

  Future<Response> deleteComment(String token, String commentId) async {
    final raw = await _client.delete(
      Uri.parse("${ApiEndpoints.baseUrl}/comment/$commentId"),
      headers: {"Authorization": "Bearer $token"}
    );

    return Response.fromJson(raw.statusCode, jsonDecode(raw.body) as Map<String, dynamic>);
  }

  Future<Response> recommendComment(String token, String commentId) async {
    final raw = await _client.post(
      Uri.parse("${ApiEndpoints.baseUrl}/recommend/comment"),
      headers: {"Authorization": "Bearer $token"},
      body: {"commentid": commentId}
    );

    return Response.fromJson(raw.statusCode, jsonDecode(raw.body) as Map<String, dynamic>);
  }

  Future<Response> listComments(String postId, String sortBy, {int limit = 20}) async {
    final raw = await _client.get(
      Uri.parse("${ApiEndpoints.baseUrl}/post/$postId/comment?sortby=$sortBy&limit=$limit")
    );

    var jsonBody;
    try {
      jsonBody = jsonDecode(raw.body);
    } on FormatException catch (e) {
      return Response.fromJson(400, {"message": e.message});
    }

    final response = Response.fromJson(
      raw.statusCode, 
      jsonBody as Map<String, dynamic>,
    );

    return response;
  }

  Future<Response> isCommentRecommended(String token, String commentId) async {
  final raw = await http.get(
    Uri.parse("${ApiEndpoints.baseUrl}/recommend/comment/$commentId"),
    headers: {"Authorization": "Bearer $token"},
  );

  return Response.fromJson(
    raw.statusCode,
    jsonDecode(raw.body) as Map<String, dynamic>,
  );
}
}