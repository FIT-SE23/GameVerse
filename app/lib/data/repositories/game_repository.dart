import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:gameverse/config/api_endpoints.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';

class GameRepository {
  final http.Client client;

  GameRepository({http.Client? httpClient}) : client = httpClient ?? http.Client();

  Future<List<GameModel>> getFeaturedGames() async {
    try {
      final response = await client.get(
        Uri.parse('${ApiEndpoint.storefrontUrl}/featured'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<GameModel> games = [];

        // Extract featured games
        if (data['featured_win'] != null) {
          for (var item in data['featured_win']) {
            games.add(GameModel(
              appId: item['id'] ?? 0,
              name: item['name'] ?? 'Unknown Game',
              headerImage: item['large_capsule_image'] ?? '',
              price: item['final_price'] != null ? 
                {'final': item['final_price'], 'discount_percent': item['discount_percent']} : null,
              description: item['discount_percent'] != null ? 
                'Save ${item['discount_percent']}%' : null,
            ));
          }
        }
        
        // Extract specials (discounted games)
        if (data['specials'] != null) {
          for (var item in data['specials']) {
            games.add(GameModel(
              appId: item['id'] ?? 0,
              name: item['name'] ?? 'Special Offer',
              headerImage: item['large_capsule_image'] ?? '',
              price: item['discounted'] ? 
                {'final': item['final_price'], 'original': item['original_price'], 
                 'discount_percent': item['discount_percent']} : null,
              description: item['discount_percent'] != null ? 
                'Save ${item['discount_percent']}%' : null,
            ));
          }
        }
        
        return games;
      } else {
        throw Exception('Failed to load featured games: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching featured games: $e');
    }
  }

  Future<List<GameModel>> getOwnedGames(String userId) async {
    // This would require authentication in a real app
    // For now we'll return mock data
    
    return [
      GameModel(
        appId: 570,
        name: 'Dota 2',
        headerImage: 'https://steamcdn-a.akamaihd.net/steam/apps/570/header.jpg',
        installed: true,
        playtimeHours: 120.5,
      ),
      GameModel(
        appId: 730,
        name: 'Counter-Strike 2',
        headerImage: 'https://steamcdn-a.akamaihd.net/steam/apps/730/header.jpg',
        installed: true,
        playtimeHours: 400.2,
      ),
    ];
  }
}