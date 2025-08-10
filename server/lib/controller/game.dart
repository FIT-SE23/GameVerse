import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import "../config/config.dart";

class Game {
  final String? gameId;
  final String? publisherId;
  final String? name;
  final String? description;
  final String? briefDescription;
  final String? requirement;
  final double? price;
  final int? recommend;
  final DateTime? releaseDate;
  final List<Category>? categories;
  final List<Resource>? resources;
  final GameSale? gameSale;

  const Game({
    this.gameId,
    this.publisherId,
    this.name,
    this.description,
    this.briefDescription,
    this.requirement,
    this.categories,
    this.resources,
    this.price,
    this.recommend,
    this.releaseDate,
    this.gameSale,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    final gameid = json["gameid"] as String?;
    final publisherid = json["publisherid"] as String?;
    final name = json["name"] as String?;
    final description = json["description"] as String?;
    final briefDescription = json["briefdescription"] as String?;
    final requirement = json["requirement"] as String?;
    final price = json["price"]?.toDouble() as double?;
    final recommend = json["recommend"]?.toInt() as int?;
    final releaseDate = DateTime.parse(json["releasedate"] as String? ?? "");
    final categories = <Category>[];
    for (var category in json["Category"] as List<dynamic>) {
      categories.add(Category.fromJson(category as Map<String, dynamic>));
    }

    final resources = <Resource>[];
    for (var resource in json["Resource"] as List<dynamic>) {
      resources.add(Resource.fromJson(resource as Map<String, dynamic>));
    }
    GameSale? gameSale = null;
    if (json["Game_Sale"] != null) {
      gameSale = GameSale.fromJson(json["Game_Sale"] as Map<String, dynamic>);
    }

    return Game(
      gameId: gameid,
      publisherId: publisherid,
      name: name,
      description: description,
      briefDescription: briefDescription,
      requirement: requirement,
      price: price,
      recommend: recommend,
      releaseDate: releaseDate,
      categories: categories,
      resources: resources,
      gameSale: gameSale,
    );
  }

  @override
  String toString() {
    return "Game {gameid: " +
        (this.gameId ?? "\"\"") +
        ", publisherid: " +
        (this.publisherId ?? "\"\"") +
        ", name: " +
        (this.name ?? "\"\"") +
        ", description: " +
        (this.description ?? "\"\"") +
        ", briefdescription: " +
        (this.briefDescription ?? "\"\"") +
        ", requirement: " +
        (this.requirement ?? "\"\"") +
        ", price: " +
        this.price.toString() +
        ", recommend: " +
        this.recommend.toString() +
        ", releasedate: " +
        this.releaseDate.toString() +
        ", categories: " +
        this.categories.toString() +
        ", resources: " +
        this.resources.toString() +
        ", gamesale: " +
        this.gameSale.toString() +
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
  String token,
  String name,
  String description,
  String briefDescription,
  String requirement,
  double price,
  List<String> binaries,
  List<String> media,
  List<String> media_header,
  List<String> exes,
  String categories,
) async {
  final request =
      http.MultipartRequest("POST", Uri.parse(serverURL + "game"))
        ..fields["gamename"] = name
        ..fields["description"] = description
        ..fields["briefdescription"] = briefDescription
        ..fields["requirement"] = requirement
        ..fields["price"] = price.toString()
        ..fields["categories"] = categories
        ..headers["Authorization"] = token;

  try {
    await _addFiles(request, 'binary', binaries);
    await _addFiles(request, 'media', media);
    await _addFiles(request, 'media_header', media_header);
    await _addFiles(request, 'executable', exes);
  } catch (err) {
    if (err is Response) return err;
    return Response.fromJson(400, {
      'message': 'File processing error: ${err.toString()}',
      'return': null,
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
  List<String>? media,
  List<String>? exes,
}) async {
  final request = http.MultipartRequest(
    'PATCH',
    Uri.parse(serverURL + 'game/$gameId'),
  );

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
    final validResourceIDs =
        resourceids
            .map((id) => id.trim())
            .where((id) => id.isNotEmpty)
            .toList();

    if (validResourceIDs.isNotEmpty) {
      request.fields['resourceids'] = jsonEncode(validResourceIDs);
    }
  }

  try {
    await _addFiles(request, 'binary', binaries);
    await _addFiles(request, 'media', media);
    await _addFiles(request, 'executable', exes);
  } catch (err) {
    if (err is Response) return err;
    return Response.fromJson(400, {
      'message': 'File processing error: ${err.toString()}',
      'return': null,
    });
  }

  final raw = await request.send();
  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(await raw.stream.bytesToString()) as Map<String, dynamic>,
  );

  return response;
}

Future<Response> getGame(String token, String gameid) async {
  final raw = await http.get(
    Uri.parse(serverURL + "game/" + gameid),
    headers: <String, String>{"Authorization": "Bearer " + token},
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

  // print(jsonBody);
  // print(response.data.runtimeType);
  if (response.data.length == 0) {
    return Response(code: 400, message: "Gameid not found");
  }

  final game = Game.fromJson(response.data[0] as Map<String, dynamic>);

  return Response(code: response.code, message: response.message, data: game);
}

Future<Response> listGames(
  String gamename,
  String sortBy,
  int start,
  int cnt,
) async {
  final raw = await http.get(
    Uri.parse(
      serverURL +
          "search?entity=game&gamename=$gamename&sortby=$sortBy&start=$start&cnt=$cnt",
    ),
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

  final games = <Game>[];
  for (var game in response.data as List<dynamic>) {
    games.add(Game.fromJson(game as Map<String, dynamic>));
  }

  return Response(code: response.code, message: response.message, data: games);
}

Future<Response> recommendGame(String token, String gameId) async {
  final raw = await http.post(
    Uri.parse(serverURL + "recommend/game"),
    headers: <String, String>{"Authorization": "Bearer " + token},
    body: <String, String>{"gameid": gameId},
  );
  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(await raw.body) as Map<String, dynamic>,
  );

  return response;
}

Future<Response> downloadGame(
  String token,
  String gameId, 
  {List<String>? resourceIds,}
) async {
  final request = http.MultipartRequest(
    "POST",
    Uri.parse(serverURL + "download/game"),
  )
    ..headers["Authorization"] = token
    ..fields["gameid"] = gameId;

  if (resourceIds != null && resourceIds.isNotEmpty) {
    final validResourceIDs = resourceIds
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toList();

    if (validResourceIDs.isNotEmpty) {
      request.fields['resourceids'] = jsonEncode(validResourceIDs);
    }
  }

  final raw = await request.send();
  final response = Response.fromJson(
    raw.statusCode,
    jsonDecode(await raw.stream.bytesToString()) as Map<String, dynamic>,
  );

  return response;
}

class Category {
  final String? categoryId;
  final String? name;
  final bool? isSensitive;

  const Category({this.categoryId, this.name, this.isSensitive});

  factory Category.fromJson(Map<String, dynamic> json) {
    final categoryid = json["categoryid"] as String?;
    final categoryName = json["categoryname"] as String?;
    final isSensitive = json["issensitive"] as String?;

    return Category(
      categoryId: categoryid,
      name: categoryName,
      isSensitive: isSensitive == "TRUE",
    );
  }

  @override
  String toString() {
    return "Category {categoryid: " +
        (this.categoryId ?? "\"\"") +
        ", name: " +
        (this.name ?? "\"\"") +
        ", sensitive: " +
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

class Resource {
  final String? resourceid;
  final String? userid;
  final String? url;
  final String? type;

  const Resource({this.resourceid, this.userid, this.url, this.type});

  factory Resource.fromJson(Map<String, dynamic> json) {
    final resourceid = json["resourceid"] as String?;
    final userid = json["userid"] as String?;
    final url = json["url"] as String?;
    final type = json["type"] as String?;

    return Resource(
      resourceid: resourceid,
      userid: userid,
      url: url,
      type: type,
    );
  }

  @override
  String toString() {
    return "Resource {resourceid: " +
        (this.resourceid ?? "\"\"") +
        ", userid: " +
        (this.userid ?? "\"\"") +
        ", url: " +
        (this.url ?? "\"\"") +
        ", type: " +
        (this.type ?? "\"\"") +
        "}";
  }
}

/*
Future<Response> addResource(String categoryName, bool isSensitive) async {
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
*/

class GameSale {
  final String? gameid;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? discountPercentage;

  const GameSale({
    this.gameid,
    this.startDate,
    this.endDate,
    this.discountPercentage,
  });

  factory GameSale.fromJson(Map<String, dynamic> json) {
    final gameid = json["gameid"] as String?;
    final startDate = DateTime.parse(json["startdate"] as String);
    final endDate = DateTime.parse(json["enddate"] as String);
    final discountPercentage = json["discountpercentage"].toInt() as int?;

    return GameSale(
      gameid: gameid,
      startDate: startDate,
      endDate: endDate,
      discountPercentage: discountPercentage,
    );
  }

  @override
  String toString() {
    return "GameSale {gameid: " +
        (this.gameid ?? "\"\"") +
        ", startdate: " +
        this.startDate.toString() +
        ", enddate: " +
        this.endDate.toString() +
        ", discountpercentage: " +
        this.discountPercentage.toString() +
        "}";
  }
}
