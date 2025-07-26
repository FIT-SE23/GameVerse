import 'package:flutter/material.dart';
import 'package:gameverse/data/repositories/game_repository.dart';
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
  
  // Error handling
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Selected game for details
  GameModel? _selectedGame;
  GameModel? get selectedGame => _selectedGame;
  
  Future<void> loadHomePageData() async {
    try {
      _state = HomeViewState.loading;
      notifyListeners();
      
      // Load featured games
      _featuredDiscount = await _gameRepository.getFeaturedGames();
      
      // In a real app, we would have more API calls for different sections
      _newReleases = _featuredDiscount;

      // Same as new releases, currently just taking 5 featured discount games to demo
      _popularGames = _featuredDiscount.take(5).toList();
      
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

  void selectGame(GameModel game) {
    _selectedGame = game;
    notifyListeners();
  }
}