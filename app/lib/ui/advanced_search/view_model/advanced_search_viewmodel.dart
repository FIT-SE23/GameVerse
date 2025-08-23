import 'package:flutter/foundation.dart';
import 'package:gameverse/domain/models/category_model/category_model.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';
// import 'package:gameverse/domain/models/category_model/category_model.dart';
import 'package:gameverse/data/repositories/game_repository.dart';

enum AdvancedSearchState { initial, loading, success, error }

class AdvancedSearchViewmodel extends ChangeNotifier {
  final GameRepository _gameRepository;

  AdvancedSearchState _state = AdvancedSearchState.initial;
  AdvancedSearchState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  void setSearchQuery(String query) {
    _searchQuery = query.trim().toLowerCase();
  }

  bool _onlyDiscounted = false;
  bool get onlyDiscounted => _onlyDiscounted;
  void setOnlyDiscounted(bool discounted) {
    _onlyDiscounted = discounted;
  }

  String _sortCriteria = GameSortCriteria.popularity;
  String get sortCriteria => _sortCriteria;
  void setSortCriteria(String criteria) {
    _sortCriteria = criteria;
  }

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
    String titleQuery = '',
    bool onlyDiscounted = false,
    Set<String> selectedCategories = const {}
  }) async {
    _isLoading = true;
    notifyListeners();

    _searchQuery = titleQuery.toLowerCase();
    _onlyDiscounted = onlyDiscounted;
    _selectedCategories = selectedCategories;
    
    try {
      _games = await _gameRepository.searchGames(titleQuery, GameSortCriteria.popularity, 0, 30, selectedCategories.toList(), false);
      _categoryMap = await _getCategories();
      updateCategoryMap();
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
  Future<Map<String, bool>> _getCategories() async {
    Map<String, bool> categoryMap = {};
    List<CategoryModel> categories = await _gameRepository.getCategories();

    for (final category in categories) {
      categoryMap[category.name] = false;
    }
    return Map.fromEntries(
      categoryMap.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  void applyFilters() async {
    try {
      _state = AdvancedSearchState.loading;
      notifyListeners();
      updateSelectedCategories();
      _filteredGames = await _gameRepository.searchGames(_searchQuery, _sortCriteria, 0, 120, selectedCategories.toList(), onlyDiscounted);

      _state = AdvancedSearchState.success;

    } catch (e) {
      _state = AdvancedSearchState.error;
      _errorMessage = 'Failed to load data: $e';
    } finally {
      notifyListeners();
    }
  }
}