import 'dart:convert';
import 'package:http/http.dart' as http;

import "../config/config.dart";

class Publisher {
  final String? publisherId;
  final String? paymentMethodId;
  final String? description;
  final String? paymentCardNumber;
  final bool? isVerified;

  const Publisher({
    this.publisherId,
    this.paymentMethodId,
    this.description,
    this.paymentCardNumber,
    this.isVerified,
  });

  factory Publisher.fromJson(Map<String, dynamic> json) {
    final publisherid = json["publisherid"] as String?;
    final paymentMethodId = json["paymentMethodId"] as String?;
    final description = json["description"] as String?;
    final paymentCardNumber = json["paymentcardnumber"] as String?;
    final isVerified = json["issensitive"].toString().toLowerCase() as String?;

    return Publisher(
      publisherId: publisherid,
      paymentMethodId: paymentMethodId,
      description: description,
      paymentCardNumber: paymentCardNumber,
      isVerified: isVerified == "true",
    );
  }

  @override
  String toString() {
    return "Publisher {publisherid: " +
        (this.publisherId ?? "\"\"") +
        ", paymentmethodid: " +
        (this.paymentMethodId ?? "\"\"") +
        ", description: " +
        (this.description ?? "\"\"") +
        ", paymentcardnumber: " +
        (this.paymentCardNumber ?? "\"\"") +
        ", verified: " +
        this.isVerified.toString() +
        "}";
  }
}

Future<Response> addPublisher(
  String token,
  String paymentMethodId,
  String description,
  String paymentCardNumber,
) async {
  final raw = await http.post(
    Uri.parse(serverURL + "publisher"),
    body: <String, String>{
      "paymentmethodid": paymentMethodId,
      "description": description,
      "paymentcardnumber": paymentCardNumber,
    },
    headers: {"Authorization": "Bearer " + token},
  );

  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(raw.body) as Map<String, dynamic>,
  );

  return response;
}

Future<Response> getPublisherRequests(String token) async {
  final raw = await http.post(
    Uri.parse(serverURL + "publisher/requests"),
    headers: {"Authorization": "Bearer " + token},
  );

  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(raw.body) as Map<String, dynamic>,
  );

  return response;
}

Future<Response> verifyPublisher(
  String token,
  String publisherid,
  bool isApprove,
) async {
  final raw = await http.post(
    Uri.parse(serverURL + "publisher/requests"),
    body: {"publisherid": publisherid, "isApprove": isApprove},
    headers: {"Authorization": "Bearer " + token},
  );

  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(raw.body) as Map<String, dynamic>,
  );

  return response;
}

Future<Response> updatePublisher({
  required String publisherId,
  String? paymentMethodId,
  String? description,
  String? paymentCardNumber,
  bool? isVerified,
}) async {
  final body = <String, String>{};
  if (paymentMethodId != null) body['paymentmethodid'] = paymentMethodId;
  if (description != null) body['description'] = description;
  if (paymentCardNumber != null) body['paymentcardnumber'] = paymentCardNumber;
  if (isVerified != null) body['isverified'] = isVerified ? "1" : "";

  final raw = await http.patch(
    Uri.parse(serverURL + 'publisher/$publisherId'),
    body: body,
  );

  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(raw.body) as Map<String, dynamic>,
  );

  return response;
}
