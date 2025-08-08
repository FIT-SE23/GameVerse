import 'package:flutter/foundation.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';
// import 'package:gameverse/domain/models/category_model/category_model.dart';
import 'package:gameverse/data/repositories/game_repository.dart';

class AdvancedSearchViewmodel extends ChangeNotifier {
  final GameRepository _gameRepository;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool _onlyDiscounted = false;
  bool get onlyDiscounted => _onlyDiscounted;

  Map<String, bool> _categoryMap = {};
  Map<String, bool> get categoryMap => _categoryMap;

  Set<String> _selectedCategories = {};
  Set<String> get selectedCategories => _selectedCategories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<GameModel> _games = [];
  List<GameModel> get games => _games;

  List<GameModel> _filteredGames = [];
  List<GameModel> get filterGames => _filteredGames;

  AdvancedSearchViewmodel({
    required GameRepository gameRepository,
    String searchQuery = '',
    bool onlyDiscounted = false,
    Set<String> selectedCategories = const {}
  }) : _gameRepository = gameRepository {
    _searchQuery = searchQuery.toLowerCase();
    _onlyDiscounted = onlyDiscounted;

    _selectedCategories = selectedCategories;

    updateCategoryMap();
  }

  void updateCategoryMap() {
    for (final categoryName in _selectedCategories) {
      _categoryMap[categoryName] = true;
    }
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _games = await _gameRepository.searchGames('');
      _categoryMap = _getCategories(_games);
      _applyFilters();
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

  void _applyFilters() {
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