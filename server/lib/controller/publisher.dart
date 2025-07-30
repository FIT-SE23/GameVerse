import 'dart:convert';
import 'package:http/http.dart' as http;

import "../config/config.dart";

class Publisher {
  final String? publisherid;
  final String? paymentMethodId;
  final String? description;

  const Publisher({this.publisherid, this.paymentMethodId, this.description});

  factory Publisher.fromJson(Map<String, dynamic> json) {
    final publisherid = json["publisherid"] as String?;
    final paymentMethodId = json["paymentMethodId"] as String?;
    final description = json["description"] as String?;

    return Publisher(
      publisherid: publisherid,
      paymentMethodId: paymentMethodId,
      description: description,
    );
  }

  @override
  String toString() {
    return "Publisher {publisherid: " +
        (this.publisherid ?? "\"\"") +
        ", paymentmethodid: " +
        (this.paymentMethodId ?? "\"\"") +
        ", description: " +
        (this.description ?? "\"\"") +
        "}";
  }
}

Future<Response> addPublisher(
  String userid,
  String paymentMethodId,
  String description,
) async {
  final raw = await http.post(
    Uri.parse(serverURL + "publisher"),
    body: <String, String>{
      "userid": userid,
      "paymentmethodid": paymentMethodId,
      "description": description,
    },
  );

  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(raw.body) as Map<String, dynamic>,
  );

  return response;
}
