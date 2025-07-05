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
  List<GameModel> _featuredGames = [];
  List<GameModel> get featuredGames => _featuredGames;
  
  List<GameModel> _newReleases = [];
  List<GameModel> get newReleases => _newReleases;
  
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
      _featuredGames = await _gameRepository.getFeaturedGames();
      
      // In a real app, we would have more API calls for different sections
      _newReleases = _featuredGames.take(4).toList();
      
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