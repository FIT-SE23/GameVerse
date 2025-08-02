import 'package:gameverse/domain/models/forum_model/forum_model.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';

class ForumRepository {
  
  Future<List<GameModel>> getGamesWithForums() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _getMockGamesWithForums();
  }

  Future<void> createForum(ForumModel forum) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In real app, save to database
  }

  Future<void> deleteForum(String forumId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In real app, delete from database
  }

  Future<void> updateForum(ForumModel forum) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In real app, update in database
  }

  List<GameModel> _getMockGamesWithForums() {
    return [
      GameModel(
        appId: '1',
        name: 'Cyberpunk 2077',
        recommended: 95,
        briefDescription: 'An open-world, action-adventure story set in Night City.',
        description: 'Cyberpunk 2077 is an open-world, action-adventure story.',
        requirements: 'Windows 10, 8GB RAM',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/1091500/header.jpg',
        categoriesID: ['RPG', 'Action'],
      ),
      GameModel(
        appId: '6',
        name: 'Counter-Strike 2',
        recommended: 89,
        briefDescription: 'The legendary FPS returns.',
        description: 'Counter-Strike 2 marks the beginning of a new chapter.',
        requirements: 'Windows 10, 8GB RAM',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/730/header.jpg',
        categoriesID: ['FPS', 'Competitive'],
      ),
      GameModel(
        appId: '5',
        name: 'Dota 2',
        recommended: 92,
        briefDescription: 'The ultimate MOBA experience.',
        description: 'Every day, millions of players worldwide enter battle.',
        requirements: 'Windows 10, 4GB RAM',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/570/header.jpg',
        categoriesID: ['MOBA', 'Strategy'],
      ),
    ];
  }
}