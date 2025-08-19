import 'package:flutter/widgets.dart';
import 'package:gameverse/domain/models/category_model/category_model.dart';
import 'package:gameverse/domain/models/game_request_model/game_request_model.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:gameverse/data/services/game_api_client.dart';
import 'package:gameverse/utils/response.dart';


class GameSortCriteria {
  static final popularity = 'popularity';
  static final price = 'price';
  static final date = 'date';
  static final recommend = 'recommend';
}

class GameRepository {
  final http.Client client;
  static late GameApiClient gameApiClient;

  static Set<GameModel> _allGames = {};
  Set<GameModel> get allGames => _allGames;

  static List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  static Future<GameRepository> fromService() async {
    gameApiClient = GameApiClient();
    var featuredGames = await _getMockFeaturedGames();
    _allGames.addAll(featuredGames);
    return GameRepository();
  }

  GameRepository({http.Client? httpClient}) : client = httpClient ?? http.Client();
  
  Future<List<GameModel>> searchGames(
    String title,
    String sortBy,
    int start,
    int cnt,
    List<String> categories,
    bool onSale
  ) async {
    return await _getDataFromResponse(gameApiClient.listGames(title, sortBy, start, cnt, categories.join(','), onSale)) as List<GameModel>;
  }

  Future<List<CategoryModel>> getCategories() async {
    _categories = await _getDataFromResponse(gameApiClient.getCategories()) as List<CategoryModel>;

    return _categories;
  }

  Future<List<GameModel>> getLibraryGames(String token, String userId) async {
    final Response response = await gameApiClient.getLibraryGames(token, userId);

    if (response.code != 200) {
      return Future.error(response.message);
    }
    for (var gameData in response.data) {
      // Update the game with isOwned
      GameModel game;
      try {
        game = _allGames.firstWhere((g) => g.gameId == gameData.gameId);
        _allGames.remove(game);
      } catch (e) {
        game = gameData as GameModel;
      }
      game = game.copyWith(isOwned: true);
      // Check if the game is already downloaded
      bool isInstalled = await setGameInstallation(game.gameId);
      game = game.copyWith(isInstalled: isInstalled);
      // If the game is not installed, get download url
      if (!isInstalled) {
        final response = await gameApiClient.downloadGame(token, game.gameId);
        List<String> binaries = [];
        List<String> exes = [];
        if (response.code == 200) {
          for (final item in response.data as List<dynamic>) {{
            if (item['type'] == 'binary') {
              binaries.add(item['url']);
            } else if (item['type'] == 'executable') {
              exes.add(item['url']);
            }
          }}
          game = game.copyWith(
            binaries: binaries,
            exes: exes,
          );
          setGameInstallation(game.gameId);
        } else {
          debugPrint('Failed to get download URL for ${game.gameId}: ${response.message}');
        }
      }
      _allGames.add(game);
    }
    final libraryGames = _allGames.where((game) => game.isOwned).toList();
    return libraryGames;
  }

  Future<List<GameModel>> getWishlistGames(String token, String userId) async {
    final Response response = await gameApiClient.getWishlistGames(token, userId);

    if (response.code != 200) {
      return Future.error(response.message);
    }
    for (var gameData in response.data) {
      GameModel game;
      try {
        game = _allGames.firstWhere((g) => g.gameId == gameData.gameId);
        _allGames.remove(game);
      } catch (e) {
        game = gameData as GameModel;
      }
      game = game.copyWith(isInWishlist: true);
      _allGames.add(game);
    }
    final wishlistGames = _allGames.where((game) => game.isInWishlist).toList();
    return wishlistGames;
  }

  GameModel? getGameDetails(String gameId) {
    GameModel existingGame;
    try {
      existingGame = _allGames.firstWhere((game) => game.gameId == gameId);
    } catch (e) {
      debugPrint('Game with ID $gameId not found in repository.');
      return null;
    }
    return existingGame;
  }

  Future<String> getPublisherName(String publisherId) async {
    return await _getDataFromResponse(gameApiClient.getPublisherName(publisherId)) as String;
  }

  Future<List<GameModel>> getDiscountededGames() async {
    return await _getDataFromResponse(gameApiClient.listGames('', GameSortCriteria.popularity, 0, 10, '', true)) as List<GameModel>;
  }

  Future<List<GameModel>> getNewGames() async {
    return await _getDataFromResponse(gameApiClient.listGames('', GameSortCriteria.date, 0, 10, '', false)) as List<GameModel>;
  }

  Future<List<GameModel>> getPopularGames() async {
    return await _getDataFromResponse(gameApiClient.listGames('', GameSortCriteria.popularity, 0, 5, '', false)) as List<GameModel>;
  }

  Future<List<GameModel>> getTopRecommendedGames() async {
    return await _getDataFromResponse(gameApiClient.listGames('', GameSortCriteria.recommend, 0, 10, '', false)) as List<GameModel>;
  }

  Future<List<GameModel>> getGamesByCategory(String category) async {
    return await _getDataFromResponse(gameApiClient.listGames('', GameSortCriteria.popularity, 0, 5, category, false)) as List<GameModel>;
  }

  static Future<dynamic> _getDataFromResponse(Future<Response> futureResponse) async {
    Response response = await futureResponse;
    return response.data;
  }

  static Future<List<GameModel>> _getMockFeaturedGames() async {
    return [
      await _getDataFromResponse(gameApiClient.getGame('', 'b5e14fbb-0b28-4e34-9848-7403175d5a48')) as GameModel,
      await _getDataFromResponse(gameApiClient.getGame('', 'c0ea830e-6081-4086-9392-0a968d425128')) as GameModel,
      await _getDataFromResponse(gameApiClient.getGame('', '0f1f4c69-1f25-4770-ab25-ed553388330a')) as GameModel,
      await _getDataFromResponse(gameApiClient.getGame('', 'bca0264f-f451-489e-9e19-0378c56d4c18')) as GameModel,
      await _getDataFromResponse(gameApiClient.getGame('', '60ce4bab-c05d-4d71-9f4a-028f545c6cb0')) as GameModel,
    ];
  }

  // Set folder path for game installation
  void setGameInstallationPath(String gameId, String path) {
    GameModel game;
    try {
      game = _allGames.firstWhere(
        (game) => game.gameId == gameId,
      );
    } catch (e) {
      debugPrint('Game with ID $gameId not found in repository.');
      return;
    }
    
    _allGames.remove(game);
    _allGames.add(game.copyWith(path: path));
  }

  // Check if the game is isInstalled, if yes, set the isInstalled field to true
  Future<bool> setGameInstallation(String gameId) async {
    // Try to find the game in the set
    GameModel? game;
    try {
      game = _allGames.firstWhere((g) => g.gameId == gameId);
    } catch (e) {
      // Game not found in the set
      return false;
    }
    
    if (game.path != null) {
      String executablePath = await checkGameInstallation(game.path!);
      if (executablePath.isNotEmpty) {
        _allGames.remove(game);
        _allGames.add(game.copyWith(isInstalled: true));
        return true;
      } else {
        _allGames.remove(game);
        _allGames.add(game.copyWith(
          isInstalled: false,
          path: null,
        ));
      }
    }
    return false;
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
    final Response response = await gameApiClient.addGame(
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
    final Response response = await gameApiClient.recommendGame(
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
    final Response response = await gameApiClient.isRecommended(
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
      game = _allGames.firstWhere((g) => g.gameId == gameId);
    } catch (e) {
      debugPrint('Game with ID $gameId not found in repository.');
      return false;
    }
    _allGames.remove(game);
    _allGames.add(game.copyWith(isInWishlist: !isInWishlist));
    return true;
  }

  // Update specific game details
  Future<void> updateGameDetails(GameModel updatedGame) async {
    GameModel? existingGame;
    try {
      existingGame = _allGames.firstWhere((game) => game.gameId == updatedGame.gameId);
    } catch (e) {
      debugPrint('Game with ID ${updatedGame.gameId} not found in repository.');
      return;
    }
    _allGames.remove(existingGame);
    _allGames.add(updatedGame);
  }

}