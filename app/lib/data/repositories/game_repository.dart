import 'package:flutter/widgets.dart';
import 'package:gameverse/domain/models/category_model/category_model.dart';
import 'package:gameverse/domain/models/game_request_model/game_request_model.dart';
import 'package:gameverse/domain/models/url_model/url_model.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:gameverse/data/services/game_api_client.dart';
import 'package:gameverse/utils/response.dart';

import 'package:collection/collection.dart';


class GameSortCriteria {
  static const String popularity = 'popularity';
  static const String price = 'price';
  static const String date = 'date';
  static const String recommend = 'recommend';

  static const String popularityDisplay = 'Popularity';
  static const String priceDisplay = 'Price';
  static const String dateDisplay = 'Date';
  static const String recommendDisplay = 'Recommend';
}

class GameRepository {
  final Set<GameModel> _libraryGames = {};
  Set<GameModel> get libraryGames => _libraryGames;

  static List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;
  
  Future<List<GameModel>> searchGames(
    String title,
    String sortBy,
    int start,
    int cnt,
    List<String> categories,
    bool onSale
  ) async {
    return await _getDataFromResponse(GameApiClient().listGames(title, sortBy, start, cnt, categories.join(','), onSale)) as List<GameModel>;
  }

  Future<List<CategoryModel>> getCategories() async {
    _categories = await _getDataFromResponse(GameApiClient().getCategories()) as List<CategoryModel>;

    return _categories;
  }

  Future<List<GameModel>> getLibraryGames(String path, String token, String userId) async {
    final Response response = await GameApiClient().getLibraryGames(token, userId);

    if (response.code != 200) {
      return Future.error(response.message);
    }
    for (var gameData in response.data) {
      // Update the game with isOwned
      GameModel game;
      try {
        _libraryGames.firstWhere((g) => g.gameId == gameData.gameId);
        continue; // Skip if the game is already in the library
      } catch (e) {
        game = gameData as GameModel;
      }
      game = game.copyWith(isOwned: true);
      final response = await GameApiClient().downloadGame(token, game.gameId);
      List<UrlModel> binaries = [];
      List<UrlModel> exes = [];
      if (response.code == 200) {
        for (final item in response.data as List<dynamic>) {
          if (item['type'] == 'binary') {
            binaries.add(UrlModel(
              urlId: item['resourceId'],
              url: item['url'],
            ));
          } else if (item['type'] == 'executable') {
            exes.add(UrlModel(
              urlId: item['resourceId'],
              url: item['url'],
            ));
          }
        }
        game = game.copyWith(
          binaries: binaries,
          exes: exes,
        );
      } else {
        debugPrint('Failed to get download URL for ${game.gameId}: ${response.message}');
        _libraryGames.add(game.copyWith(
          binaries: [],
          exes: [],
        ));
      }
      _libraryGames.add(game);
      setGameInstallation(path, game.gameId);
    }
    final libraryGames = _libraryGames.where((game) => game.isOwned).toList();
    return libraryGames;
  }

  Future<List<GameModel>> getWishlistGames(String token, String userId) async {
    final Response response = await GameApiClient().getWishlistGames(token, userId);

    if (response.code != 200) {
      return Future.error(response.message);
    }
    for (var gameData in response.data) {
      GameModel game;
      try {
        game = _libraryGames.firstWhere((g) => g.gameId == gameData.gameId);
        _libraryGames.remove(game);
      } catch (e) {
        game = gameData as GameModel;
      }
      game = game.copyWith(isInWishlist: true);
      _libraryGames.add(game);
    }
    final wishlistGames = _libraryGames.where((game) => game.isInWishlist).toList();
    return wishlistGames;
  }

  Future<GameModel?> getGameDetails(String gameId, {String token = ''}) async {
    GameModel? existingGame;
    try {
      existingGame = _libraryGames.firstWhereOrNull((game) => game.gameId == gameId);      if (existingGame == null) {
        final response = await GameApiClient().getGame(token, gameId);
        if (response.code != 200) {
          throw Exception('Failed to load game details: ${response.message}');
        } else {
          existingGame = response.data as GameModel;
        }
      }
      
    } catch (e) {
      debugPrint('Game with ID $gameId not found in repository.');
      return null;
    }
    return existingGame;
  }

  Future<String> getPublisherName(String publisherId) async {
    return await _getDataFromResponse(GameApiClient().getPublisherName(publisherId)) as String;
  }

  Future<List<GameModel>> getDiscountededGames() async {
    final discountededGames =
      await _getDataFromResponse(GameApiClient().listGames('', GameSortCriteria.popularity, 0, 10, '', true)) as List<GameModel>;
    return discountededGames;
  }

  Future<List<GameModel>> getNewGames() async {
    final newGames =
      await _getDataFromResponse(GameApiClient().listGames('', GameSortCriteria.date, 0, 10, '', false)) as List<GameModel>;
    return newGames;
  }

  Future<List<GameModel>> getPopularGames() async {
    final popularGames =
      await _getDataFromResponse(GameApiClient().listGames('', GameSortCriteria.popularity, 0, 5, '', false)) as List<GameModel>;
    return popularGames;
  }

  Future<List<GameModel>> getTopRecommendedGames() async {
    final topRecommendedGames =
      await _getDataFromResponse(GameApiClient().listGames('', GameSortCriteria.recommend, 0, 10, '', false)) as List<GameModel>;
    return topRecommendedGames;
  }

  Future<List<GameModel>> getGamesByCategory(String category, int cnt) async {
    return await _getDataFromResponse(GameApiClient().listGames('', GameSortCriteria.popularity, 0, cnt, category, false)) as List<GameModel>;
  }

  static Future<dynamic> _getDataFromResponse(Future<Response> futureResponse) async {
    Response response = await futureResponse;
    return response.data;
  }

  // Set folder path for game installation
  void setGameInstallationPath(String gameId, String path) {
    GameModel game;
    try {
      game = _libraryGames.firstWhere(
        (game) => game.gameId == gameId,
      );
    } catch (e) {
      debugPrint('Game with ID $gameId not found in repository.');
      return;
    }
    
    _libraryGames.remove(game);
    _libraryGames.add(game.copyWith(path: path));
  }

  // Check if the game is isInstalled, if yes, set the isInstalled field to true
  Future<bool> setGameInstallation(String pathGame, String gameId) async {
    // Try to find the game in the set
    GameModel? game;
    try {
      game = _libraryGames.firstWhere((g) => g.gameId == gameId);
    } catch (e) {
      // Game not found in the set
      return false;
    }
    
    String state = await checkDownloadState(pathGame, game);
    _libraryGames.remove(game);
    _libraryGames.add(game.copyWith(
      downloadState: state,
    ));
    if (state == 'completed') {
      return true;
    }
    return false;
  }

  Future<String> checkDownloadState(String pathGame, GameModel game) async {   
    // Check if game directory exists but isn't fully installed
    final gameDirPath = path.join(pathGame, game.gameId);
    final gameDir = Directory(gameDirPath);
    if (await gameDir.exists()) {
      // Check if the game has any files downloaded
      final allUrl = [
        ...game.binaries!.map((binary) => binary.url),
        ...game.exes!.map((exe) => exe.url),
      ];

      int completedFiles = 0;
      final files = [];
      for (final url in allUrl) {
        final baseName = path.basename(url);
        final tokenIndex = baseName.indexOf('?token');
        final nameFile = tokenIndex != -1 
            ? baseName.substring(0, tokenIndex) 
            : baseName;
        files.add(nameFile);
      }

      for (final file in files) {
        final filePath = path.join(gameDirPath, file);
        final exists = await File(filePath).exists();
        if (exists) completedFiles++;
      }
      
      if (completedFiles > 0 && completedFiles < files.length) {
        return 'partial';
      }
      else if (completedFiles == files.length) {
        return 'completed';
      } else {
        return 'nothing';
      }
    } else {
      return 'nothing';
    }
  }

  
  Future<String> checkGameInstallation(String gamePath) async {
    final gameDir = Directory(gamePath);
    if (!await gameDir.exists()) return '';

    await for (final entity in gameDir.list(recursive: true)) {
      if (entity is File) {
        final extension = path.extension(entity.path).toLowerCase();
        if (extension == '.exe' || extension == '.app' || extension == '.deb') {
          return entity.path; // Return the first executable found
        }
      }
    }

    return ''; // No executable found
  }

  Future<bool> requestGamePublication(String token, GameRequestModel request) async {
    final Response response = await GameApiClient().addGame(
      token,
      request.gameName,
      request.description,
      request.briefDescription,
      request.requirements,
      request.price,
      request.binaries,
      request.media,
      [request.headerImage],
      request.exes,
      // Convert categories to a list of name strings and connect by ','
      request.categories.map((category) => category.name).toList().join(','),
    );

    if (response.code != 200) {
      debugPrint('Failed to request game publication: ${response.message}');
      return false;
    }

    return true;
  }

  Future<bool> recommendGame(String token, String gameId) async {
    final Response response = await GameApiClient().recommendGame(
      token,
      gameId,
    );
    if (response.code != 200) {
      debugPrint('Failed to recommend game: ${response.message}');
      return false;
    }
    return true;
  }

  Future<bool> isRecommended(String token, String gameId) async {
    final Response response = await GameApiClient().isRecommended(
      token,
      gameId,
    );
    if (response.code != 200) {
      debugPrint('Failed to check if game is recommended: ${response.message}');
      return false;
    }
    if (response.data == true) {
      return true;
    }
    return false;
  }

  Future<bool> toggleWishlist(String token, String gameId, bool isInWishlist) async {
    if (isInWishlist) {
      final Response response = await GameApiClient().removeGameWithStatus(token, gameId, 'In wishlist');
      if (response.code != 200) {
        debugPrint('Failed to remove game from wishlist: ${response.message}');
        return false;
      }
    } else {
      final Response response = await GameApiClient().addGameWithStatus(token, gameId, 'In wishlist');
      if (response.code != 200) {
        debugPrint('Failed to add game to wishlist: ${response.message}');
        return false;
      }
    }
    GameModel? game;
    try {
      game = _libraryGames.firstWhere((g) => g.gameId == gameId);
    } catch (e) {
      debugPrint('Game with ID $gameId not found in repository.');
      return false;
    }
    _libraryGames.remove(game);
    _libraryGames.add(game.copyWith(isInWishlist: !isInWishlist));
    return true;
  }

  // Clear the game cache
  Future<void> clearCache() async {
    _libraryGames.clear();
    _categories.clear();
  }
}