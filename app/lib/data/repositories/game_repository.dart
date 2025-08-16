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

  static List<GameModel> _allGames = [];
  List<GameModel> get allGames => _allGames;

  static List<GameModel> _libraryGames = [];
  List<GameModel> get libraryGames => _libraryGames;

  static List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  static Future<GameRepository> fromService() async {
    gameApiClient = GameApiClient();
    var featuredGames = await _getMockFeaturedGames();
    _allGames = featuredGames;
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
    _libraryGames = [];
    for (var gameData in response.data) {
      // Update the game with isOwned
      GameModel game = gameData as GameModel;
      game = game.copyWith(isOwned: true);
      _libraryGames.add(game);
    }
    return _libraryGames;
  }

  Future<GameModel?> getGameDetails(String gameId) async {
    // First check in library games and then in all games
    GameModel? game = _libraryGames.firstWhere(
      (game) => game.gameId == gameId,
      orElse: () => _allGames.firstWhere(
        (game) => game.gameId == gameId,
      ),
    );
    if (game.gameId != gameId) {
      return null;
    }
    return game;
  }

  Future<String> getPublisherName(String publisherId) async {
    return await _getDataFromResponse(gameApiClient.getPublisherName(publisherId)) as String;
  }

  Future<List<GameModel>> getDiscountededGames() async {
    return await _getDataFromResponse(gameApiClient.listGames('', GameSortCriteria.price, 0, 10, '', true)) as List<GameModel>;
  }

  Future<List<GameModel>> getNewGames() async {
    return await _getDataFromResponse(gameApiClient.listGames('', GameSortCriteria.date, 0, 10, '', false)) as List<GameModel>;
  }

  Future<List<GameModel>> getPopularGames() async {
    return await _getDataFromResponse(gameApiClient.listGames('', GameSortCriteria.popularity, 0, 5, '', false)) as List<GameModel>;
  }

  Future<List<GameModel>> getTopRecommendedGames() async {
    return await _getDataFromResponse(gameApiClient.listGames('', GameSortCriteria.recommend, 0, 5, '', false)) as List<GameModel>;
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
    final gameIndex = _allGames.indexWhere((game) => game.gameId == gameId);
    if (gameIndex != -1) {
      final game = _allGames[gameIndex];
      _allGames[gameIndex] = game.copyWith(path: path);
    }
  }

  // Check if the game is isInstalled, if yes, set the isInstalled field to true
  Future<bool> setGameInstallation(String gameId) async {
    final gameIndex = _allGames.indexWhere((game) => game.gameId == gameId);
    // debugPrint('Checking game: ${_allGames[gameIndex]}');
    if (gameIndex != -1 && _allGames[gameIndex].path != null) {
      if (await checkGameInstallation(_allGames[gameIndex].path!)) {
        final game = _allGames[gameIndex];
        _allGames[gameIndex] = game.copyWith(isInstalled: true);
        return true;
      } else {
        final game = _allGames[gameIndex];
        _allGames[gameIndex] = game.copyWith(
          isInstalled: false,
          path: null,
        );
      }
    }
    return false;
  }

  
  Future<bool> checkGameInstallation(String gamePath) async {
    final gameDir = Directory(gamePath);
    if (!await gameDir.exists()) return false;

    await for (final entity in gameDir.list(recursive: true)) {
      if (entity is File) {
        final extension = path.extension(entity.path).toLowerCase();
        if (extension == '.exe' || extension == '.app' || extension == '.deb') {
          return true; // Found an executable
        }
      }
    }

    return false; // No executables found
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
      return false;
    }

    return true;
  }
}