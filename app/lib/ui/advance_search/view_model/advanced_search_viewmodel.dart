import 'package:flutter/foundation.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';
// import 'package:gameverse/domain/models/category_model/category_model.dart';
import 'package:gameverse/data/repositories/game_repository.dart';

class AdvancedSearchViewmodel extends ChangeNotifier {
  final GameRepository _gameRepository;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  void setSearchQuery(String query) {
    _searchQuery = query.trim().toLowerCase();
  }

  bool _onlyDiscounted = false;
  bool get onlyDiscounted => _onlyDiscounted;

  Map<String, bool> _categoryMap = {};
  Map<String, bool> get categoryMap => _categoryMap;
  void switchCategorySelectState(String categoryName) {
    if (_categoryMap.containsKey(categoryName)) {
      if (_categoryMap[categoryName] == true) {
        _categoryMap[categoryName] = false;
      } else {
        _categoryMap[categoryName] = true;
      }
      notifyListeners();
    }
  }

  Set<String> _selectedCategories = {};
  Set<String> get selectedCategories => _selectedCategories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<GameModel> _games = [];
  List<GameModel> get games => _games;

  List<GameModel> _filteredGames = [];
  List<GameModel> get filteredGames => _filteredGames;

  AdvancedSearchViewmodel({
    required GameRepository gameRepository,
  }) : _gameRepository = gameRepository;

  void updateCategoryMap() {
    for (final categoryName in _categoryMap.keys) {
      if (_selectedCategories.contains(categoryName)) {
        _categoryMap[categoryName] = true;
      } else {
        _categoryMap[categoryName] = false;
      }
    }
  }
  void updateSelectedCategories() {
    _selectedCategories = {};
    for (final categoryName in _categoryMap.keys) {
      if (_categoryMap[categoryName] == true) {
        _selectedCategories.add(categoryName);
      }
    }
  }

  Future<void> loadData({
    String searchQuery = '',
    bool onlyDiscounted = false,
    Set<String> selectedCategories = const {}
  }) async {
    _isLoading = true;
    notifyListeners();

    _searchQuery = searchQuery.toLowerCase();
    _onlyDiscounted = onlyDiscounted;
    _selectedCategories = selectedCategories;
    updateCategoryMap();

    try {
      _games = await _gameRepository.searchGames([]);
      _categoryMap = _getCategories(_games);
      applyFilters();
    } catch (e) {
      debugPrint('Error loading advanced search: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // This method will be changed to getting the list of categories
  // from server instead of extracting from game list
  Map<String, bool> _getCategories(List<GameModel> games) {
    Map<String, bool> categoryMap = {};
    for (final game in games) {
      categoryMap.addAll({for (String name in game.categories.map((e) => e.name)) name: false});
    }
    return Map.fromEntries(
      categoryMap.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  void applyFilters() {
    updateSelectedCategories();
    _filteredGames = _games.where((game) {
      // Keyword filter
      if (_searchQuery.isNotEmpty) {
        if (!game.name.toLowerCase().contains(_searchQuery)) {
          return false;
        }
      }

      // Category filter
      if (_selectedCategories.isNotEmpty) {
        final gameCategories = game.categories.map((e) => e.name).toSet();
        if (!gameCategories.containsAll(_selectedCategories)) {
          return false;
        }
      }

      // Discount filter (will add later)

      return true;
    }).toList();

    notifyListeners();
  }
}