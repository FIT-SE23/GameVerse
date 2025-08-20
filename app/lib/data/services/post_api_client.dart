import 'package:gameverse/utils/response.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gameverse/config/api_endpoints.dart';

class PostApiClient {
  final http.Client _client;

  PostApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Response> addPost(
    String token,
    String forumId,
    String title,
    String content,
  ) async {
    final raw = await _client.post(
      Uri.parse("${ApiEndpoints.baseUrl}/post"),
      headers: <String, String>{"Authorization": "Bearer $token"},
      body: <String, String>{
        "forumid": forumId,
        "title": title,
        "content": content,
      }
    );

    return Response.fromJson(raw.statusCode, jsonDecode(raw.body) as Map<String, dynamic>);
  }

  Future<Response> getPost(String postId) async {
    final raw = await _client.get(Uri.parse("${ApiEndpoints.baseUrl}/post/$postId"));

    var jsonBody;
    try {
      jsonBody = jsonDecode(raw.body);
    } on FormatException catch (e) {
      return Response.fromJson(400, {"message": e.message});
    }

    final response = Response.fromJson(raw.statusCode, jsonBody as Map<String, dynamic>);
    
    return response;
    // final post = Post.fromJson(response.data[0] as Map<String, dynamic>);
    // return Response(code: response.code, message: response.message, data: post);
  }

  Future<Response> updatePost(
    String token, 
    String postId, 
    String title, 
    String content
  ) async {
    final raw = await _client.patch(
      Uri.parse("${ApiEndpoints.baseUrl}/post/$postId"),
      headers: {"Authorization": "Bearer $token"},
      body: {
        "title": title,
        "content": content,
      }
    );

    return Response.fromJson(raw.statusCode, jsonDecode(raw.body) as Map<String, dynamic>);
  }

  Future<Response> deletePost(String token, String postId) async {
    final raw = await _client.delete(
      Uri.parse("${ApiEndpoints.baseUrl}/post/$postId"),
      headers: {"Authorization": "Bearer $token"}
    );

    return Response.fromJson(raw.statusCode, jsonDecode(raw.body) as Map<String, dynamic>);
  }

  Future<Response> recommendPost(String token, String postId) async {
    final raw = await _client.post(
      Uri.parse("${ApiEndpoints.baseUrl}/recommend/post"),
      headers: {"Authorization": "Bearer $token"},
      body: {"postid": postId}
    );

    return Response.fromJson(raw.statusCode, jsonDecode(raw.body) as Map<String, dynamic>);
  }

  Future<Response> listPosts(
    String forumId,
    String title,
    String sortBy,
    {int limit = 20}
  ) async {
    final raw = await _client.get(
      Uri.parse("${ApiEndpoints.baseUrl}/search?entity=post&forumid=$forumId&title=${Uri.encodeComponent(title)}&sortby=$sortBy&limit=$limit")
    );

    var jsonBody;
    try {
      jsonBody = jsonDecode(raw.body);
    } on FormatException catch (e) {
      return Response.fromJson(400, {"message": e.message});
    }

    final response = Response.fromJson(raw.statusCode, jsonBody as Map<String, dynamic>);

    return response;
  }

  Future<Response> isPostRecommended(String token, String postId) async {
    final raw = await http.get(
      Uri.parse("${ApiEndpoints.baseUrl}/recommend/post/$postId"),
      headers: {"Authorization": "Bearer $token"},
    );

    return Response.fromJson(
      raw.statusCode,
      jsonDecode(raw.body) as Map<String, dynamic>,
    );
  }
}