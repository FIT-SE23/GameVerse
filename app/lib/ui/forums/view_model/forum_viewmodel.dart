import 'package:flutter/material.dart';
import 'package:gameverse/data/repositories/forum_repository.dart';
import 'package:gameverse/domain/models/forum_model/forum_model.dart';

enum ForumsState { initial, loading, success, error }

class ForumsViewModel extends ChangeNotifier {
  final ForumRepository _forumRepository;
  
  ForumsViewModel({required ForumRepository forumRepository})
      : _forumRepository = forumRepository;

  ForumsState _state = ForumsState.initial;
  ForumsState get state => _state;

  List<ForumModel> _gamesWithForums = [];
  List<ForumModel> get gamesWithForums => _gamesWithForums;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> loadGamesWithForums() async {
    try {
      _state = ForumsState.loading;
      notifyListeners();

      _gamesWithForums = await _forumRepository.getGamesWithForums();
      _state = ForumsState.success;
    } catch (e) {
      _state = ForumsState.error;
      _errorMessage = 'Failed to load forums: $e';
    } finally {
      notifyListeners();
    }
  }
}