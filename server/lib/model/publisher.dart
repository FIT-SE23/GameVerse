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
