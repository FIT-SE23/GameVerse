import 'package:flutter/foundation.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:gameverse/data/repositories/game_repository.dart';

enum LibraryViewMode { list, grid }

class LibraryViewModel extends ChangeNotifier {
  final GameRepository _gameRepository;
  
  LibraryViewModel({required GameRepository gameRepository})
      : _gameRepository = gameRepository;

  // State
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  LibraryViewMode _viewMode = LibraryViewMode.grid;
  LibraryViewMode get viewMode => _viewMode;

  int _activeCategory = 0;
  int get activeCategory => _activeCategory;

  // Games data
  List<GameModel> _games = [];
  List<GameModel> get games => _games;

  List<GameModel> _filteredGames = [];
  List<GameModel> get filteredGames => _filteredGames;

  // Filter data
  String _searchQuery = '';
  final Set<String> _selectedTags = {};
  Set<String> get selectedTags => _selectedTags;

  List<String> _availableTags = [];
  List<String> get availableTags => _availableTags;

  // Computed properties
  List<GameModel> get downloadedGames => 
      _games.where((game) => game.installed).toList();

  List<GameModel> get favoriteGames => 
      _games.where((game) => _isFavorite(game.appId)).toList();

  List<GameModel> get recentGames => 
      _games.where((game) => game.playtimeHours != null && game.playtimeHours! > 0)
           .toList()..sort((a, b) => (b.playtimeHours ?? 0).compareTo(a.playtimeHours ?? 0));

  int get downloadedCount => downloadedGames.length;

  // Favorite games storage (in a real app, this would be persistent)
  final Set<String> _favoriteGameIds = {};

  Future<void> loadLibrary() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load mock library data
      _games = await _gameRepository.searchGames('');
      _availableTags = _extractTags(_games);
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading library: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setViewMode(LibraryViewMode mode) {
    _viewMode = mode;
    notifyListeners();
  }

  void setActiveCategory(int index) {
    _activeCategory = index;
    notifyListeners();
  }

  void searchGames(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void toggleTag(String tag) {
    if (_selectedTags.contains(tag)) {
      _selectedTags.remove(tag);
    } else {
      _selectedTags.add(tag);
    }
    _applyFilters();
  }

  void clearTagFilters() {
    _selectedTags.clear();
    _applyFilters();
  }

  void toggleFavorite(String gameId) {
    if (_favoriteGameIds.contains(gameId)) {
      _favoriteGameIds.remove(gameId);
    } else {
      _favoriteGameIds.add(gameId);
    }
    notifyListeners();
  }

  void toggleInstalled(String gameId) {
    final gameIndex = _games.indexWhere((game) => game.appId == gameId);
    if (gameIndex != -1) {
      _games[gameIndex] = _games[gameIndex].copyWith(
        installed: !_games[gameIndex].installed,
      );
      _applyFilters();
    }
  }

  bool _isFavorite(String gameId) => _favoriteGameIds.contains(gameId);

  void _applyFilters() {
    _filteredGames = _games.where((game) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        if (!game.name.toLowerCase().contains(_searchQuery)) {
          return false;
        }
      }

      // Tag filter
      if (_selectedTags.isNotEmpty) {
        final gameTags = _getGameTags(game);
        if (!_selectedTags.every((tag) => gameTags.contains(tag))) {
          return false;
        }
      }

      return true;
    }).toList();

    notifyListeners();
  }

  List<String> _extractTags(List<GameModel> games) {
    final tags = <String>{};
    for (final game in games) {
      tags.addAll(_getGameTags(game));
    }
    return tags.toList()..sort();
  }

  List<String> _getGameTags(GameModel game) {
    // In a real app, games would have actual tags
    // For now, we'll generate some mock tags based on game properties
    final tags = <String>[];
    
    if (game.installed) tags.add('Downloaded');
    if (game.playtimeHours != null && game.playtimeHours! > 50) tags.add('Favorite');
    if (game.playtimeHours != null && game.playtimeHours! > 0) tags.add('Played');
    if (game.price == null) tags.add('Free to Play');
    
    // Mock genre tags
    final gameNameLower = game.name.toLowerCase();
    if (gameNameLower.contains('counter') || gameNameLower.contains('shooter')) {
      tags.add('FPS');
    }
    if (gameNameLower.contains('dota') || gameNameLower.contains('strategy')) {
      tags.add('Strategy');
    }
    if (gameNameLower.contains('rpg') || gameNameLower.contains('adventure')) {
      tags.add('RPG');
    }
    
    return tags;
  }
}