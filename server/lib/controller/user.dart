import 'dart:convert';
import 'package:http/http.dart' as http;
import "package:crypto/crypto.dart";

import "../config/config.dart";

class User {
  final String? userid;
  final String? username;
  final String? email;

  const User({this.userid, this.username, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    final userid = json["userid"] as String?;
    final username = json["username"] as String?;
    final email = json["password"] as String?;

    return User(userid: userid, username: username, email: email);
  }

  @override
  String toString() {
    return "User {userid: " +
        (this.userid ?? "\"\"") +
        ", username: " +
        (this.username ?? "\"\"") +
        ", email: " +
        (this.email ?? "\"\"") +
        "}";
  }
}

Future<Response> addUser(String username, String email, String password) async {
  final bytePassword = utf8.encode(password);
  final hashPassword = sha256.convert(bytePassword).toString();

  final raw = await http.post(
    Uri.parse(serverURL + "register"),
    body: <String, String>{
      "username": username,
      "email": email,
      "hashpassword": hashPassword,
    },
  );

  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(raw.body) as Map<String, dynamic>,
  );

  return response;
}

Future<Response> listUser(String username) async {
  final raw = await http.get(
    Uri.parse(serverURL + "search?entity=user&username=$username"),
  );

  var jsonBody;

  try {
    jsonBody = jsonDecode(raw.body);
  } on FormatException catch (e) {
    return Response.fromJson(400, {"message": e.message});
  }

  final response = Response.fromJson(
    raw.statusCode,
    jsonBody as Map<String, dynamic>,
  );

  final users = <User>[];
  for (var user in response.data as List<dynamic>) {
    users.add(User.fromJson(user as Map<String, dynamic>));
  }

  return Response(code: response.code, message: response.message, data: users);
}

Future<Response> login(String email, String password) async {
  final bytePassword = utf8.encode(password);
  final hashPassword = sha256.convert(bytePassword).toString();

  final raw = await http.post(
    Uri.parse(serverURL + "login"),
    body: <String, String>{"email": email, "hashpassword": hashPassword},
  );

  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(raw.body) as Map<String, dynamic>,
  );

  return response;
}

Future<Response> addGameWithStatus(
  String token,
  String userid,
  String gameid,
  String status,
) async {
  Uri uri = Uri();
  if (status == "In library") {
    uri = Uri.parse(serverURL + "addtolibrary");
  } else if (status == "In wishlist") {
    uri = Uri.parse(serverURL + "addtowishlist");
  } else if (status == "In cart") {
    uri = Uri.parse(serverURL + "addtocart");
  }
  final raw = await http.post(
    uri,
    headers: <String, String>{"Authorization": "Bearer " + token},
    body: <String, String>{"userid": userid, "gameid": gameid},
  );

  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(raw.body) as Map<String, dynamic>,
  );

  return response;
}

Future<Response> listGamesInCart(String token, String userid) async {
  final raw = await http.post(
    Uri.parse(serverURL + "user/cart"),
    headers: <String, String>{"Authorization": "Bearer " + token},
    body: <String, String>{"userid": userid},
  );

  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(raw.body) as Map<String, dynamic>,
  );

  return response;
}

Future<Response> listGamesInLibraryOrWishlist(
  String userid,
  String status,
) async {
  String url = serverURL + "user/" + userid + "/";
  if (status == "In library") {
    url += "library";
  } else if (status == "In wishlist") {
    url += "wishlist";
  }
  final raw = await http.get(Uri.parse(url));

  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(raw.body) as Map<String, dynamic>,
  );

  return response;
}
