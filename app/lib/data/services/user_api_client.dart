import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gameverse/config/api_endpoints.dart';
import 'package:gameverse/utils/response.dart';

class UserApiClient {
  final http.Client _client;

  UserApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Response> getUsername(String publisherId) async {
    final raw = await _client.get(Uri.parse(
      "${ApiEndpoints.baseUrl}/user/$publisherId"
    ));

    final response = Response.fromJson(
      raw.statusCode,
      jsonDecode(raw.body) as Map<String, dynamic>,
    );

    return Response(code: response.code, message: response.message, data: response.data['username']);
  }
}