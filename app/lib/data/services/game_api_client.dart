import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gameverse/config/api_endpoints.dart';
import 'package:gameverse/utils/response.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:gameverse/domain/models/category_model/category_model.dart';


class GameApiClient {
  final http.Client _client;

  GameApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<void> _addFiles(
    final dynamic request,
    String fieldName,
    List<String>? paths,
  ) async {
    if (paths == null) return;
    for (final path in paths) {
      try {
        request.files.add(await http.MultipartFile.fromPath(fieldName, path));
      } catch (e) {
        return Future.error(
          Response.fromJson(400, {'message': e, 'return': path}),
        );
      }
    }
  }

  Future<Response> addGame(
    String publisherid,
    String name,
    String description,
    List<String> binaries,
    List<String> media,
    String mediaheader,
    List<String> exes,
    String categories,
  ) async {
    final request =
        http.MultipartRequest("POST", Uri.parse(ApiEndpoints.gameUrl))
          ..fields["publisherid"] = publisherid
          ..fields["gamename"] = name
          ..fields["description"] = description
          ..fields["categories"] = categories
          ..fields["mediaheader"] = mediaheader;

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
      Uri.parse('${ApiEndpoints.gameUrl}/$gameId'),
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

  // a temporary function
  GameModel _jsonToGameModel(Map<String, dynamic> json) {
    List<CategoryModel> categories = [];
    for (var list in json["Category"] as List<dynamic>) {
      final categoryid = (list["categoryid"] ?? '') as String;
      final categoryName = (list["categoryname"] ?? '') as String;
      final isSensitive = (list["issensitive"] ?? '') as String?;
      
      categories.add(CategoryModel(categoryId: categoryid, name: categoryName, isSensitive: isSensitive == 'TRUE'));
    }

    final rawMedia = json["Resource"] as List<dynamic>;
    final rawHeader = rawMedia.firstWhere(
      (list) => list["type"] as String == "media_header",
      orElse: () => <dynamic>[],
    );
    // print(rawHeader);
    if (rawHeader.isNotEmpty) {
      rawMedia.remove(rawHeader);
    }

    List<String> media = [for (final m in rawMedia) m["url"]];
 
    final game = GameModel(
      gameId: (json["gameid"] ?? '') as String,
      publisherId: (json["publisherid"] ?? '') as String,
      name: (json["name"] ?? '') as String,
      description: (json["description"] ?? '') as String,
      briefDescription: (json["briefdescription"] ?? '') as String,
      requirement: (json["requirement"] ?? '') as String,
      price: json["price"].toDouble() as double,
      recommended: json["recommend"].toInt() as int,
      releaseDate: DateTime.parse(json["releasedate"] as String? ?? ""),
      categories: categories,
      media: media,
      headerImage: (rawHeader.isNotEmpty ? rawHeader["url"] : '') as String,

      isSale: json["Game_Sale"] == null,
    );
    return game;
  }

  Future<Response> getGame(String token, String gameid) async {
    final raw = await http.get(
      Uri.parse('${ApiEndpoints.gameUrl}/$gameid'),
      headers: <String, String>{"Authorization": "Bearer $token"},
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
    // final game = GameModel.fromJson(response.data[0] as Map<String, dynamic>);

    // will change to using GameModel.fromJson later
    final json = response.data[0] as Map<String, dynamic>;

    // for (final key in json.keys) {
    //   print("$key: ${json[key].runtimeType}");
    // }
    
    final game = _jsonToGameModel(json);

    return Response(code: response.code, message: response.message, data: game);
  }

  Future<Response> listGames(String gamename, String sortBy) async {
    final raw = await http.get(
      Uri.parse(
        "${ApiEndpoints.baseUrl}search?entity=game&gamename=$gamename&sortby=$sortBy",
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

    final games = <GameModel>[];
    for (var game in response.data as List<dynamic>) {
      games.add(GameModel.fromJson(game as Map<String, dynamic>));
    }

    return Response(code: response.code, message: response.message, data: games);
  }

  Future<Response> recommendGame(String token, String gameId) async {
    final raw = await http.post(
      Uri.parse("${ApiEndpoints.recommendedGamesUrl}/game"),
      headers: <String, String>{"Authorization": "Bearer $token"},
      body: <String, String>{"gameid": gameId},
    );
    final response = Response.fromJson(
      raw.statusCode,
      jsonDecode(raw.body) as Map<String, dynamic>,
    );

    return response;
  }

  // Add a game to the user's library or wishlist with a specific status
  Future<Response> addGameWithStatus(
    String token,
    String gameid,
    String status,
  ) async {
    final raw = await _client.post(
      Uri.parse(ApiEndpoints.addGameToUrl),
      headers: <String, String>{"Authorization": "Bearer $token"},
      body: <String, String>{
        "gameid": gameid,
        "status": status,
      },
    );

    final response = Response.fromJson(
      raw.statusCode,
      jsonDecode(raw.body) as Map<String, dynamic>,
    );

    return response;
  }

  // Remove a game from the user's library or wishlist with a specific status
  Future<Response> removeGameWithStatus(
    String token,
    String gameid,
    String status,
  ) async {
    final raw = await _client.post(
      Uri.parse(ApiEndpoints.removeGameFromUrl),
      headers: <String, String>{"Authorization": "Bearer $token"},
      body: <String, String>{
        "gameid": gameid,
        "status": status,
      },
    );

    final response = Response.fromJson(
      raw.statusCode,
      jsonDecode(raw.body) as Map<String, dynamic>,
    );

    return response;
  }

  Future<Response> listGamesInCart(String token) async {
    final raw = await _client.post(
      Uri.parse("${ApiEndpoints.userUrl}/cart"),
      headers: <String, String>{"Authorization": "Bearer $token"},
    );

    final response = Response.fromJson(
      raw.statusCode,
      jsonDecode(raw.body) as Map<String, dynamic>,
    );

    return response;
  }

  Future<Response> getLibraryGames(String userid) async {
    String url = "${ApiEndpoints.userUrl}/$userid/library";
    final raw = await _client.get(Uri.parse(url));

    final response = Response.fromJson(
      raw.statusCode,
      jsonDecode(raw.body) as Map<String, dynamic>,
    );
    return response;
  }
  Future<Response> getWishListGames(String userid) async {
    String url = "${ApiEndpoints.userUrl}/$userid/wishlist";
    final raw = await _client.get(Uri.parse(url));

    final response = Response.fromJson(
      raw.statusCode,
      jsonDecode(raw.body) as Map<String, dynamic>,
    );
    return response;
  }
}