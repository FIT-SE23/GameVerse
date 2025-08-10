import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:gameverse/domain/models/category_model/category_model.dart';
import 'package:gameverse/domain/models/game_request_model/game_request_model.dart';
import 'package:http/http.dart' as http;
import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:gameverse/config/api_endpoints.dart';

class PublisherApiClient {
  final http.Client _client;
  
  PublisherApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<bool> registerAsPublisher({
    required String userId,
    required String description,
    required String paymentMethodId,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiEndpoint.baseUrl}/publisher'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'userid': userId,
          'description': description,
          'paymentmethodid': paymentMethodId,
        },
      );
      
      debugPrint('Register publisher response status: ${response.statusCode}');
      debugPrint('Register publisher response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['code'] == 200;
      }
      return false;
    } catch (e) {
      debugPrint('Register publisher error: $e');
      return false;
    }
  }

  Future<dynamic> getPublisherProfile(String publisherId) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiEndpoint.baseUrl}/publisher/$publisherId'),
      );
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['code'] == 200) {
          final data = jsonData['data'];
          return (
            id: publisherId,
            description: data['description'] ?? '',
            paymentMethodId: data['paymentmethodid'] ?? '',
            registrationDate: DateTime.now(), // You might want to add this to your server response
          );
        }
      }
      return null;
    } catch (e) {
      debugPrint('Get publisher profile error: $e');
      return null;
    }
  }

  Future<List<GameModel>> getPublishedGames(String publisherId) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiEndpoint.baseUrl}/publisher/$publisherId'),
      );
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['code'] == 200) {
          final data = jsonData['data'];
          final List<dynamic> gamesData = data['Game'] ?? [];
          return gamesData.map((gameJson) => GameModel.fromJson(gameJson)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('Get published games error: $e');
      return [];
    }
  }

  Future<List<GameRequestModel>> getPendingRequests(String publisherId) async {
    try {
      // This would need to be implemented on your server
      // For now, return mock data
      return [
        GameRequestModel(
          gameName: 'My Awesome Game',
          publisherId: publisherId,
          briefDescription: 'A brief description of my awesome game',
          description: 'An epic adventure game',
          requirements: 'Minimum requirements: 8GB RAM, 2GB VRAM',
          categories: [
            CategoryModel(categoryId: '1', name: 'Adventure', isSensitive: false),
            CategoryModel(categoryId: '2', name: 'Action', isSensitive: false),

          ],
          price: 29.99,
          requestStatus: 'pending',
          headerImage: 'https://example.com/header.jpg',
          media: [
            'https://example.com/media1.jpg',
            'https://example.com/media2.jpg',
          ],
          binaries: [
            'https://example.com/binaries/my_awesome_game_v1.0.bin',
          ],
          exes: [
            'https://example.com/exes/my_awesome_game_v1.0.exe',
          ],
        ),
      ];
    } catch (e) {
      debugPrint('Get pending requests error: $e');
      return [];
    }
  }

  Future<bool> requestGamePublication({
    required String publisherId,
    required String gameName,
    required String description,
    required String categories,
    required double price,
  }) async {
    try {
      // This would need to be implemented on your server
      // For now, simulate success
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      debugPrint('Request game publication error: $e');
      return false;
    }
  }

  Future<bool> cancelGameRequest(String requestId) async {
    try {
      // This would need to be implemented on your server
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    } catch (e) {
      debugPrint('Cancel game request error: $e');
      return false;
    }
  }

  Future<bool> updatePublisherProfile({
    required String publisherId,
    String? description,
    String? paymentMethodId,
  }) async {
    try {
      final body = <String, String>{};
      if (description != null) body['description'] = description;
      if (paymentMethodId != null) body['paymentmethodid'] = paymentMethodId;

      final response = await _client.patch(
        Uri.parse('${ApiEndpoint.baseUrl}/publisher/$publisherId'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['code'] == 200;
      }
      return false;
    } catch (e) {
      debugPrint('Update publisher profile error: $e');
      return false;
    }
  }
}