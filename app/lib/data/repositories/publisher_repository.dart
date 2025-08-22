// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'dart:nativewrappers/_internal/vm/lib/ffi_dynamic_library_patch.dart';

import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:gameverse/domain/models/game_request_model/game_request_model.dart';
import 'package:gameverse/domain/models/notification_model/notification_model.dart';

import 'package:gameverse/data/services/publisher_api_client.dart';

import 'package:gameverse/data/services/game_api_client.dart';
// import 'package:gameverse/utils/response.dart';

class PublisherRepository {
  final PublisherApiClient _apiClient;

  PublisherRepository({PublisherApiClient? apiClient})
      : _apiClient = apiClient ?? PublisherApiClient();

  Future<bool> registerAsPublisher({
    required String token,
    required String userId,
    required String description,
    required String paymentMethodId,
    required String paymentCardNumber,
  }) async {
    return await _apiClient.registerAsPublisher(
      token: token,
      userId: userId,
      description: description,
      paymentMethodId: paymentMethodId,
      paymentCardNumber: paymentCardNumber,
    );
  }

  Future<dynamic> getPublisherProfile(String publisherId) async {
    return await _apiClient.getPublisherProfile(publisherId);
  }

  Future<List<GameRequestModel>> getPendingRequests(String publisherId) async {
    return await _apiClient.getPendingRequests(publisherId);
  }

  Future<bool> requestGamePublication({
    required String publisherId,
    required String gameName,
    required String description,
    required String categories,
    required double price,
  }) async {
    return await _apiClient.requestGamePublication(
      publisherId: publisherId,
      gameName: gameName,
      description: description,
      categories: categories,
      price: price,
    );
  }

  Future<bool> cancelGameRequest(String requestId) async {
    return await _apiClient.cancelGameRequest(requestId);
  }

  Future<bool> updatePublisherProfile({
    required String publisherId,
    String? description,
    String? paymentMethodId,
  }) async {
    return await _apiClient.updatePublisherProfile(
      publisherId: publisherId,
      description: description,
      paymentMethodId: paymentMethodId,
    );
  }

  Future<({List<GameModel> verifiedGames, List<GameModel> pendingGames, List<NotificationModel> rejectedGameNotifications})> getGamesOfPublisher(String publisherId) async {
    try {
      final response = await _apiClient.getGamesByPublisher(publisherId);

      if (response.code != 200) {
        throw Exception('Fail to get game of this publisher: ${response.message}');
      } else {
        final games = <GameModel>[];
        final responseGames = response.data['game'];
        for (final json in responseGames as List<dynamic>) {
          games.add(GameApiClient().jsonToGameModel(json as Map<String, dynamic>));
        }

        List<GameModel> verifiedGames = [];
        List<GameModel> pendingGames = [];

        List<NotificationModel> rejectedGameNotifications = await getGameMessages(publisherId);

        for (final game in games) {
          if (game.isVerified!) {
            verifiedGames.add(game);
          } else {
            pendingGames.add(game);
          }
        }

        return (
          verifiedGames: verifiedGames,
          pendingGames: pendingGames,
          rejectedGameNotifications: rejectedGameNotifications
        );
      }
    } catch (e) {
      throw Exception('Fail to get game of this publisher: $e');
    }
  }

  Future<List<NotificationModel>> getGameMessages(String publisherId) async {
    try {
      final response = await _apiClient.getGameMessages(publisherId);

      if (response.code != 200) {
        throw Exception('Fail to get game messages: ${response.message}');
      } else {
        final notifications = <NotificationModel>[];
        for (final json in response.data as List<dynamic>) {
          Map<String, dynamic> map = json as Map<String, dynamic>;
          map['approved'] = false;
          map['userid'] = map['publisherid'];
          notifications.add(NotificationModel.fromJson(map));
        }
        return notifications;
      }
    } catch (e) {
      throw Exception('Fail to get game messages: $e');
    }
  }

  Future<List<NotificationModel>> getRejectedRegistration(String userId) async {
    try {
      final response = await _apiClient.getRejectedRegistration(userId);

      if (response.code != 200) {
        throw Exception('Fail to get rejected registration attempts: ${response.message}');
      } else {
        final notifications = <NotificationModel>[];
        for (final json in response.data as List<dynamic>) {
          Map<String, dynamic> map = json as Map<String, dynamic>;
          map['approved'] = false;
          notifications.add(NotificationModel.fromJson(map));
        }
        return notifications;
      }

    } catch (e) {
      throw Exception('Fail to get rejected registration attempts: $e');
    }
  }
}