import 'dart:convert';
import 'package:http/http.dart' as http;

import "../config/config.dart";

class PaymentMethod {
  final String? paymentMethodId;
  final String? type;
  final String? information;

  const PaymentMethod({this.paymentMethodId, this.type, this.information});

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    final paymentMethodId = json["paymentMethodId"] as String?;
    final type = json["type"] as String?;
    final information = json["information"] as String?;

    return PaymentMethod(
      paymentMethodId: paymentMethodId,
      type: type,
      information: information,
    );
  }

  @override
  String toString() {
    return "PaymentMethod {paymentmethodid: " +
        (this.paymentMethodId ?? "\"\"") +
        ", type: " +
        (this.type ?? "\"\"") +
        ", information: " +
        (this.information ?? "\"\"") +
        "}";
  }
}

Future<Response> addPaymentMethod(String type, String information) async {
  final raw = await http.post(
    Uri.parse(serverURL + "payment"),
    body: <String, String>{"type": type, "information": information},
  );

  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(raw.body) as Map<String, dynamic>,
  );

  return response;
}
