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

Future<void> _addFiles(
  final request,
  String fieldName,
  List<String>? paths,
) async {
  if (paths == null) return;
  for (final path in paths) {
    try {
      request.files.add(await http.MultipartFile.fromPath(fieldName, path));
    } on PathNotFoundException catch (e) {
      return Future.error(
        Response.fromJson(400, {'message': e.message, 'return': path}),
      );
    }
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

  try {
    await _addFiles(request, 'binary', binaries);
    await _addFiles(request, 'media', medias);
    await _addFiles(request, 'executable', exes);
  } catch (err) {
    if (err is Response) return err;
    return Response.fromJson(400, {
      'message': 'File processing error: ${err.toString()}',
      'return': null
    });
  }

  final raw = await request.send();
  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(await raw.stream.bytesToString()) as Map<String, dynamic>,
  );

  return response;
}

Future<Response> updateGame({
  required String gameId,
  String? name,
  String? description,
  String? categories,
  List<String>? resourceids,
  List<String>? binaries,
  List<String>? medias,
  List<String>? exes,
}) async {
  final request = http.MultipartRequest('PATCH', Uri.parse(serverURL + 'game/$gameId'),);

  if (name != null) {
    request.fields['gamename'] = name;
  }
  if (description != null) {
    request.fields['description'] = description;
  }
  if (categories != null) {
    request.fields['categories'] = categories;
  }
  if (resourceids != null && resourceids.isNotEmpty) {
    final validResourceIDs = resourceids.map((id) => id.trim()).where((id) => id.isNotEmpty).toList();
        
    if (validResourceIDs.isNotEmpty) {
      request.fields['resourceids'] = jsonEncode(validResourceIDs);
    }
  }

  try {
    await _addFiles(request, 'binary', binaries);
    await _addFiles(request, 'media', medias);
    await _addFiles(request, 'executable', exes);
  } catch (err) {
    if (err is Response) return err;
    return Response.fromJson(400, {
      'message': 'File processing error: ${err.toString()}',
      'return': null
    });
  }

  final raw = await request.send();
  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(await raw.stream.bytesToString()) as Map<String, dynamic>,
  );

  return response;
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
