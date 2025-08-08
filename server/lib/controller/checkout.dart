import 'dart:convert';
import 'package:http/http.dart' as http;

import "../config/config.dart";

Future<Response> createPaypalReceipt(String token) async {
  final raw = await http.post(
    Uri.parse(serverURL + "paypal/create"),
    headers: <String, String>{"Authorization": "Bearer " + token},
  );
  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(await raw.body) as Map<String, dynamic>,
  );

  return response;
}

Future<Response> createVnpayReceipt(String token) async {
  final raw = await http.post(
    Uri.parse(serverURL + "vnpay/create"),
    headers: <String, String>{"Authorization": "Bearer " + token},
  );
  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(await raw.body) as Map<String, dynamic>,
  );

  return response;
}
