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

Future<Response> addUser(String username, String email, String password) async {
  final bytePassword = utf8.encode(password);
  final hashPassword = sha256.convert(bytePassword).toString();

  final raw = await http.post(
    Uri.parse(serverURL + "register"),
    body: <String, String>{
      "username": username,
      "email": email,
      "password": hashPassword,
    },
  );

  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(raw.body) as Map<String, dynamic>,
  );

  return response;
}

Future<Response> getUser(String userId) async {
  final raw = await http.get(Uri.parse(serverURL + "user/" + userId));

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
    body: <String, String>{"email": email, "password": hashPassword},
  );

  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(raw.body) as Map<String, dynamic>,
  );

  return response;
}

Future<Response> addGameWithStatus(
  String token,
  String gameid,
  String status,
) async {
  final raw = await http.post(
    Uri.parse(serverURL + "addgameto"),
    headers: <String, String>{"Authorization": "Bearer " + token},
    body: <String, String>{"gameid": gameid, "status": status},
  );

  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(raw.body) as Map<String, dynamic>,
  );

  return response;
}

Future<Response> removeGameWithStatus(
  String token,
  String gameid,
  String status,
) async {
  final raw = await http.post(
    Uri.parse(serverURL + "removegamefrom"),
    headers: <String, String>{"Authorization": "Bearer " + token},
    body: <String, String>{"gameid": gameid, "status": status},
  );

  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(raw.body) as Map<String, dynamic>,
  );

  return response;
}

Future<Response> listGamesInCart(String token) async {
  final raw = await http.post(
    Uri.parse(serverURL + "user/cart"),
    headers: <String, String>{"Authorization": "Bearer " + token},
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

Future<Response> getOwnedPosts(String userId, {int limit = 20}) async {
  final raw = await http.get(
    Uri.parse(serverURL + "user/$userId/post?limit=$limit"),
  );

  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(raw.body) as Map<String, dynamic>,
  );

  return response;
}
