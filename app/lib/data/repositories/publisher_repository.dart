import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:gameverse/domain/models/game_request_model/game_request_model.dart';
import 'package:gameverse/data/services/publisher_api_client.dart';

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

  Future<List<GameModel>> getPublishedGames(String publisherId) async {
    return await _apiClient.getPublishedGames(publisherId);
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
}