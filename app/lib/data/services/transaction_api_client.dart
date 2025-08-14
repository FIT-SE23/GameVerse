import 'dart:convert';

import 'package:gameverse/utils/response.dart';
import 'package:http/http.dart' as http;
import 'package:gameverse/config/api_endpoints.dart';
import 'package:gameverse/domain/models/transaction_model/transaction_model.dart';

class TransactionApiClient {
  final http.Client _client;

  TransactionApiClient({http.Client? client}) : _client = client ?? http.Client();

  // Get user transactions
  Future<Response> getUserTransactions(String userId) async {
    final response = await _client.get(
      Uri.parse('${ApiEndpoints.baseUrl}/transactions?userid=$userId'),
    );
    if (response.statusCode == 200) {
      final jsonData = response.body;
      final transactions = (jsonData as List)
          .map((item) => TransactionModel.fromJson(item))
          .toList();
      return Response.fromJson(200, {'data': transactions});
    } else {
      return Response.fromJson(
        response.statusCode,
        {'message': 'Failed to fetch transactions'},
      );
    }
  }

  // Get PayPal payment gateway URL
  Future<Response> getPayPalPaymentGatewayUrl(String token) async {
    final response = await _client.post(
      Uri.parse('${ApiEndpoints.baseUrl}/paypal/create'),
      headers: <String, String>{"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Response.fromJson(200, jsonData as Map<String, dynamic>);
    } else {
      return Response.fromJson(
        response.statusCode,
        {'message': 'Failed to fetch PayPal payment gateway URL'},
      );
    }
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
}