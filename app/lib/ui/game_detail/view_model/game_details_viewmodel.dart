import 'package:flutter/material.dart';
import 'package:gameverse/data/repositories/auth_repository.dart';
import 'package:gameverse/data/repositories/game_repository.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';

enum GameDetailsState { initial, loading, success, error }

class GameDetailsViewModel extends ChangeNotifier {
  final GameRepository _gameRepository;
  final AuthRepository _authRepository;
  
  GameDetailsViewModel({required GameRepository gameRepository, required AuthRepository authRepository}) 
      : _gameRepository = gameRepository,
        _authRepository = authRepository;

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

  bool _isInWishlist = false;
  bool get isInWishlist => _isInWishlist;

  bool _isRecommended = false;
  bool get isRecommended => _isRecommended;

  Future<void> loadGameDetails(String gameId, {String gamePath = ''}) async {
    try {
      _state = GameDetailsState.loading;
      notifyListeners();

      _gameDetail = _gameRepository.getGameDetails(gameId);
      _gameDetail = _gameDetail?.copyWith(
        isInstalled: await _gameRepository.setGameInstallation(gameId),
        isInWishlist: checkInWishlist(gameId),
        path: gamePath.isNotEmpty ? gamePath : _gameDetail?.path,
      );
      _isRecommended = _authRepository.accessToken != null 
          ? await _gameRepository.isRecommended(
              _authRepository.accessToken!,
              gameId,
            )
          : false;
      _publisherName = _gameDetail != null ? await _gameRepository.getPublisherName(_gameDetail!.publisherId) : '';
      
      if (_gameDetail != null) {
        _isInLibrary = _gameDetail!.isOwned;
        _isInWishlist = _gameDetail!.isInWishlist;
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

  Future<bool> recommendGame(String gameId) async {
    try {
      final success = await _gameRepository.recommendGame(
        _authRepository.accessToken!,
        gameId,
      );
      if (success) {
        _isRecommended = !_isRecommended;
        // Update the recommended number in the game detail
        if (_gameDetail != null) {
          _gameDetail = _gameDetail!.copyWith(
            recommended: _isRecommended ? (_gameDetail!.recommended + 1) : (_gameDetail!.recommended - 1),
          );
          // Update the game detail in the repository
          await _gameRepository.updateGameDetails(_gameDetail!);
        }
        notifyListeners();
      }
      return success;
    } catch (e) {
      debugPrint('Failed to recommend game: $e');
      return false;
    }
  }

  Future<bool> toggleWishlist(String gameId) async {
    try {
      final success = await _gameRepository.toggleWishlist(
        _authRepository.accessToken!,
        gameId,
        _isInWishlist
      );
      if (success) {
        _isInWishlist = !_isInWishlist;
        notifyListeners();
      }
      return success;
    } catch (e) {
      debugPrint('Failed to toggle wishlist: $e');
      return false;
    }
  }

  Future<bool> checkRecommended(String gameId) async {
    try {
      return await _gameRepository.isRecommended(
        _authRepository.accessToken!,
        gameId,
      );
    } catch (e) {
      debugPrint('Failed to check if game is recommended: $e');
      return false;
    }
  }

  bool checkInWishlist(String gameId) {
    try {
      _isInWishlist = _gameRepository.allGames
          .any((game) => game.gameId == gameId && game.isInWishlist);
      return _isInWishlist;
    } catch (e) {
      debugPrint('Failed to check if game is in wishlist: $e');
      return false;
    }
  }
}