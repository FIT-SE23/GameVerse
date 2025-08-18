import 'package:flutter/material.dart';
import 'package:gameverse/data/repositories/game_repository.dart';
import 'package:gameverse/domain/models/category_model/category_model.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';


enum HomeViewState { initial, loading, success, error }

class HomeViewModel extends ChangeNotifier {
  final GameRepository _gameRepository;
  
  HomeViewModel({required GameRepository gameRepository}) 
      : _gameRepository = gameRepository;
  
  // State management
  HomeViewState _state = HomeViewState.initial;
  HomeViewState get state => _state;
  
  // Data
  List<GameModel> _featuredDiscount = [];
  List<GameModel> get featuredDiscount => _featuredDiscount;
  
  List<GameModel> _newReleases = [];
  List<GameModel> get newReleases => _newReleases;

  List<GameModel> _popularGames = [];
  List<GameModel> get popularGames => _popularGames;

  List<GameModel> _topRecommendedGames = [];
  List<GameModel> get topRecommendedGames => _topRecommendedGames;

  Map<String, List<GameModel>> _gamesByCategories = {};
  Map<String, List<GameModel>> get gamesByCategories => _gamesByCategories;

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;
  
  // Error handling
  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  
  Future<void> loadHomePageData() async {
    try {
      _state = HomeViewState.loading;
      notifyListeners();
      
      _featuredDiscount = await _gameRepository.getDiscountededGames();
      _newReleases = await _gameRepository.getNewGames();
      _popularGames = await _gameRepository.getPopularGames();
      _topRecommendedGames = await _gameRepository.getTopRecommendedGames();
      _categories = await _gameRepository.getCategories();

      for (final category in _categories) {
        final games = await _gameRepository.getGamesByCategory(category.name);
        if (games.isNotEmpty) {
          _gamesByCategories[category.name] = games;
        }
      }
      
      _state = HomeViewState.success;
    } catch (e) {
      _state = HomeViewState.error;
      _errorMessage = 'Failed to load home page data: $e';
    } finally {
      notifyListeners();
    }
  }
  
  void refreshData() {
    loadHomePageData();
  }
}