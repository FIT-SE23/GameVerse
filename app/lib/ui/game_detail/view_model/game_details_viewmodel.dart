import 'package:flutter/material.dart';
import 'package:gameverse/data/repositories/game_repository.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';

enum GameDetailsState { initial, loading, success, error }

class GameDetailsViewModel extends ChangeNotifier {
  final GameRepository _gameRepository;
  
  GameDetailsViewModel({required GameRepository gameRepository}) 
      : _gameRepository = gameRepository;

  // State management
  GameDetailsState _state = GameDetailsState.initial;
  GameDetailsState get state => _state;

  GameModel? _gameDetail;
  GameModel? get gameDetail => _gameDetail;

  String _publisherName = '';
  String get publisherName => _publisherName;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // User interactions
  bool _isInLibrary = false;
  bool get isInLibrary => _isInLibrary;

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  Future<void> loadGameDetails(String gameId) async {
    try {
      _state = GameDetailsState.loading;
      notifyListeners();

      _gameDetail = await _gameRepository.getGameDetails(gameId);

      _publisherName = _gameDetail != null ? await _gameRepository.getPublisherName(_gameDetail!.publisherId) : '';
      
      if (_gameDetail != null) {
        _isInLibrary = _gameDetail!.isOwned;
        _isFavorite = _gameDetail!.favorite;
        _state = GameDetailsState.success;
      } else {
        _state = GameDetailsState.error;
        _errorMessage = 'Game not found';
      }
    } catch (e) {
      _state = GameDetailsState.error;
      _errorMessage = 'Failed to load game details: $e';
    } finally {
      notifyListeners();
    }
  }

  void toggleLibrary() {
    if (_gameDetail != null) {
      _isInLibrary = !_isInLibrary;
      _gameDetail = _gameDetail!.copyWith(isOwned: _isInLibrary);
      notifyListeners();
    }
  }

  void toggleFavorite() {
    if (_gameDetail != null) {
      _isFavorite = !_isFavorite;
      _gameDetail = _gameDetail!.copyWith(favorite: _isFavorite);
      notifyListeners();
    }
  }

  void toggleInstalled() {
    if (_gameDetail != null && _isInLibrary) {
      _gameDetail = _gameDetail!.copyWith(isInstalled: !_gameDetail!.isInstalled);
      notifyListeners();
    }
  }
}