import 'dart:convert';
import 'package:http/http.dart' as http;
import "package:crypto/crypto.dart";

import "../config/config.dart";

class User {
  final String? id;
  final String? username;
  final String? email;
  final String? type;

  const User({this.id, this.username, this.email, this.type});

  factory User.fromJson(Map<String, dynamic> json) {
    final userid = json["userid"] as String?;
    final username = json["username"] as String?;
    final email = json["email"] as String?;
    final type = json["type"] as String?;

    return User(id: userid, username: username, email: email, type: type);
  }

  @override
  String toString() {
    return "User {userid: " +
        (this.id ?? "\"\"") +
        ", username: " +
        (this.username ?? "\"\"") +
        ", email: " +
        (this.email ?? "\"\"") +
        ", type: " +
        (this.type ?? "\"\"") +
        "}";
  }
}
