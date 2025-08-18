import 'dart:convert';

import 'package:gameverse/utils/response.dart';
import 'package:http/http.dart' as http;
import 'package:gameverse/config/api_endpoints.dart';

class TransactionApiClient {
  final http.Client _client;

  TransactionApiClient({http.Client? client}) : _client = client ?? http.Client();

  // Get PayPal payment gateway URL
  Future<Response> getPayPalPaymentGatewayUrl(String token) async {
    final raw = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}/paypal/create'),
      headers: <String, String>{"Authorization": "Bearer $token"},
    );
    final response = Response.fromJson(
      raw.statusCode,
      jsonDecode(raw.body) as Map<String, dynamic>,
    );

    if (response.code == 200) {
      final links = response.data as List<dynamic>;
      for (final link in links) {
        final linkMap = link as Map<String, dynamic>;
        if (linkMap["method"] == "REDIRECT") {
          return Response(
            code: response.code,
            message: response.message,
            data: linkMap["href"],
          );
        }
      }
    }
    return Response.fromJson(
      response.code,
      {'message': 'Failed to fetch PayPal payment gateway URL'},
    );
  }
  // Get VNPay payment gateway URL
  Future<Response> getVNPayPaymentGatewayUrl(String token) async {
    final response = await _client.post(
      Uri.parse('${ApiEndpoints.baseUrl}/vnpay/create'),
      headers: <String, String>{"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Response.fromJson(200, jsonData as Map<String, dynamic>);
    } else {
      return Response.fromJson(
        response.statusCode,
        {'message': 'Failed to fetch VNPay payment gateway URL'},
      );
    }
  }

  Future<Response> getTransactions(String token) async {
    final request = http.MultipartRequest(
      "POST",
      Uri.parse("${ApiEndpoints.baseUrl}/transactions"),
    )..headers["Authorization"] = "Bearer $token";

    final raw = await request.send();
    final response = Response.fromJson(
      raw.statusCode,
      jsonDecode(await raw.stream.bytesToString()) as Map<String, dynamic>,
    );

    return response;
  }

  Future<Response> getPaymentMethods() async {
    final response = await _client.get(
      Uri.parse('${ApiEndpoints.baseUrl}/payment'),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Response.fromJson(200, jsonData as Map<String, dynamic>);
    } else {
      return Response.fromJson(
        response.statusCode,
        {'message': 'Failed to fetch payment methods'},
      );
    }
  }
}