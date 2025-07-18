import 'package:flutter/material.dart';
import 'package:gameverse/data/repositories/game_repository.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';

enum GameDataStatus { initial, loading, success, error }

class GameViewModel extends ChangeNotifier {
  // final GameRepository _gameRepository;
  
  GameViewModel({required GameRepository gameRepository});
      // : _gameRepository = gameRepository;

  GameModel? _gameDetail;
  GameModel? get gameDetail => _gameDetail;
}