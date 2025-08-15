import 'dart:convert';
import 'package:http/http.dart' as http;

import "../config/config.dart";

class Transaction {
  final String id;
  final String paymentMethodId;
  final String senderId;
  final String gameId;
  final double amount;
  final DateTime transactionDate;
  final bool isRefundable;

  const Transaction({
    required this.id,
    required this.paymentMethodId,
    required this.senderId,
    required this.gameId,
    required this.amount,
    required this.transactionDate,
    required this.isRefundable,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    final transactionId = json["transactionid"] as String;
    final paymentMethodId = json["paymentmethodid"] as String;
    final senderId = json["senderid"] as String;
    final gameId = json["gameid"] as String;
    final amount = json["moneyamount"]?.toDouble() as double;
    final transactionDate = DateTime.parse(json["transactiondate"] as String);
    final isRefundable = (json["isrefundable"] as String) == "true";

    return Transaction(
      id: transactionId,
      paymentMethodId: paymentMethodId,
      senderId: senderId,
      gameId: gameId,
      amount: amount,
      transactionDate: transactionDate,
      isRefundable: isRefundable,
    );
  }

  @override
  String toString() {
    return "Transaction {transactionid: " +
        this.id +
        ", paymentmethodid: " +
        this.paymentMethodId +
        ", senderid: " +
        this.senderId +
        ", gameid: " +
        this.gameId +
        ", amount: " +
        this.amount.toString() +
        ", transactiondate: " +
        this.transactionDate.toString() +
        ", isrefundable: " +
        this.isRefundable.toString() +
        "}";
  }
}

Future<Response> getTransactions(String token) async {
  final request = http.MultipartRequest(
    "POST",
    Uri.parse(serverURL + "transactions"),
  )..headers["Authorization"] = "Bearer " + token;

  final raw = await request.send();
  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(await raw.stream.bytesToString()) as Map<String, dynamic>,
  );

  return response;
}
