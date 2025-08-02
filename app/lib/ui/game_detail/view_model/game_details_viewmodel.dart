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

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // User interactions
  bool _isInLibrary = false;
  bool get isInLibrary => _isInLibrary;

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  // Reviews and ratings (mock data)
  final List<GameReview> _reviews = [];
  List<GameReview> get reviews => _reviews;

  double _averageRating = 0.0;
  double get averageRating => _averageRating;

  int _totalReviews = 0;
  int get totalReviews => _totalReviews;

  Future<void> loadGameDetails(String gameId) async {
    try {
      _state = GameDetailsState.loading;
      notifyListeners();

      _gameDetail = await _gameRepository.getGameDetails(gameId);
      
      if (_gameDetail != null) {
        _isInLibrary = _gameDetail!.isOwned;
        _isFavorite = _gameDetail!.favorite;
        _loadMockReviews();
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
      _gameDetail = _gameDetail!.copyWith(installed: !_gameDetail!.installed);
      notifyListeners();
    }
  }

  void _loadMockReviews() {
    _reviews.clear();
    _reviews.addAll([
      GameReview(
        author: 'GameMaster2024',
        rating: 5,
        date: DateTime.now().subtract(const Duration(days: 2)),
        content: 'Amazing game! The graphics are stunning and the gameplay is incredibly smooth. Highly recommended for anyone who loves adventure games. The story keeps you engaged throughout.',
        helpful: 23,
        totalVotes: 28,
      ),
      GameReview(
        author: 'ProGamer',
        rating: 4,
        date: DateTime.now().subtract(const Duration(days: 7)),
        content: 'Great game overall, but could use some optimization. The story is engaging and the characters are well-developed. Some minor bugs but nothing game-breaking.',
        helpful: 18,
        totalVotes: 22,
      ),
      GameReview(
        author: 'CasualPlayer',
        rating: 5,
        date: DateTime.now().subtract(const Duration(days: 14)),
        content: 'Perfect for casual gaming sessions. Easy to pick up and play, but also has depth for those who want to dive deeper. Great value for money!',
        helpful: 31,
        totalVotes: 35,
      ),
      GameReview(
        author: 'HardcoreGamer',
        rating: 3,
        date: DateTime.now().subtract(const Duration(days: 21)),
        content: 'Decent game but not groundbreaking. Some good moments but feels like it could have been more. Worth playing if you\'re a fan of the genre.',
        helpful: 12,
        totalVotes: 19,
      ),
      GameReview(
        author: 'IndieGameLover',
        rating: 4,
        date: DateTime.now().subtract(const Duration(days: 28)),
        content: 'Solid indie title with unique mechanics. The art style is beautiful and the sound design is top-notch. Minor issues with pacing but overall enjoyable.',
        helpful: 15,
        totalVotes: 17,
      ),
    ]);

    // Calculate average rating
    _totalReviews = _reviews.length;
    _averageRating = _reviews.fold(0.0, (sum, review) => sum + review.rating) / _totalReviews;
  }
}

class GameReview {
  final String author;
  final int rating;
  final DateTime date;
  final String content;
  final int helpful;
  final int totalVotes;

  GameReview({
    required this.author,
    required this.rating,
    required this.date,
    required this.content,
    required this.helpful,
    required this.totalVotes,
  });

  String get timeAgo {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    }
  }

  double get helpfulPercentage => totalVotes > 0 ? (helpful / totalVotes) * 100 : 0;
}