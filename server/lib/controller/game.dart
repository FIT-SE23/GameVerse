import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import "../config/config.dart";

class Game {
  final String? gameid;
  final String? publisherid;
  final String? name;
  final String? description;

  const Game({this.gameid, this.publisherid, this.name, this.description});

  factory Game.fromJson(Map<String, dynamic> json) {
    final gameid = json["gameid"] as String?;
    final publisherid = json["publisherid"] as String?;
    final name = json["name"] as String?;
    final description = json["description"] as String?;

    return Game(
      gameid: gameid,
      publisherid: publisherid,
      name: name,
      description: description,
    );
  }

  @override
  String toString() {
    return "Game {gameid: " +
        (this.gameid ?? "\"\"") +
        ", publisherid: " +
        (this.publisherid ?? "\"\"") +
        ", name: " +
        (this.name ?? "\"\"") +
        ", description: " +
        (this.description ?? "\"\"") +
        "}";
  }
}

Future<Response> addGame(
  String publisherid,
  String name,
  String description,
  List<String> binaries,
  List<String> medias,
  List<String> exes,
  String categories,
) async {
  final request =
      http.MultipartRequest("POST", Uri.parse(serverURL + "game"))
        ..fields["publisherid"] = publisherid
        ..fields["gamename"] = name
        ..fields["description"] = description
        ..fields["categories"] = categories;
  for (final file in binaries) {
    try {
      request.files.add(await http.MultipartFile.fromPath("binary", file));
    } on PathNotFoundException catch (e) {
      return Response.fromJson(400, {"message": e.message, "return": file});
    }
  }
  for (final file in medias) {
    try {
      request.files.add(await http.MultipartFile.fromPath("media", file));
    } on PathNotFoundException catch (e) {
      return Response.fromJson(400, {"message": e.message, "return": file});
    }
  }
  for (final file in exes) {
    try {
      request.files.add(await http.MultipartFile.fromPath("executable", file));
    } on PathNotFoundException catch (e) {
      return Response.fromJson(400, {"message": e.message, "return": file});
    }
  }

  final raw = await request.send();
  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(await raw.stream.bytesToString()) as Map<String, dynamic>,
  );

  return response;
}

Future<Response> getGame(String gameid) async {
  final raw = await http.get(
    Uri.parse(serverURL + "game/" + gameid),
    headers: {"Autorization": "Bearer " + ""},
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

  print(jsonBody);
  final game = Game.fromJson(response.data as Map<String, dynamic>);

  return Response(code: response.code, message: response.message, data: game);
}

Future<Response> listGames(String gamename) async {
  final raw = await http.get(
    Uri.parse(serverURL + "search?entity=game&gamename=$gamename"),
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

  final users = <Game>[];
  for (var user in response.data as List<dynamic>) {
    users.add(Game.fromJson(user as Map<String, dynamic>));
  }

  return Response(code: response.code, message: response.message, data: users);
}

class Category {
  final String? categoryid;
  final String? categoryName;
  final bool? isSensitive;

  const Category({this.categoryid, this.categoryName, this.isSensitive});

  factory Category.fromJson(Map<String, dynamic> json) {
    final categoryid = json["categoryid"] as String?;
    final categoryName = json["categoryname"] as String?;
    final isSensitive = json["issensitive"] as String?;

    return Category(
      categoryid: categoryid,
      categoryName: categoryName,
      isSensitive: isSensitive == "TRUE",
    );
  }

  @override
  String toString() {
    return "Category {categoryid: " +
        (this.categoryid ?? "\"\"") +
        ", publisherid: " +
        (this.categoryName ?? "\"\"") +
        ", name: " +
        this.isSensitive.toString() +
        "}";
  }
}

Future<Response> addCategory(String categoryName, bool isSensitive) async {
  final raw = await http.post(
    Uri.parse(serverURL + "category"),
    body: <String, String>{
      "categoryname": categoryName,
      "issensitive": isSensitive ? "1" : "",
    },
  );
  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(await raw.body) as Map<String, dynamic>,
  );

  return response;
}
