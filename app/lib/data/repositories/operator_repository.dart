import 'package:gameverse/data/services/operator_api_client.dart';
import 'package:gameverse/domain/models/game_request_model/game_request_model.dart';
import 'package:gameverse/domain/models/publisher_request_model/publisher_request_model.dart';

class OperatorRepository {
  final OperatorApiClient _apiClient;
  
  OperatorRepository({OperatorApiClient? apiClient})
      : _apiClient = apiClient ?? OperatorApiClient();
  
  // Get all pending game requests
  Future<List<GameRequestModel>> getPendingGameRequests(String token) async {
    final response = await _apiClient.getPendingGameRequests(
      token
    );
    
    if (response.code != 200) {
      throw Exception(response.message);
    }
    print("Response Data: ${response.data}");
    return [];
    // final List<dynamic> requestsData = response.data;
    // return requestsData.map((data) => GameRequestModel.fromJson(data)).toList();
  }
  Future<List<PublisherRequestModel>> getPendingPublisherRequests(String token) async {
    final response = await _apiClient.getPendingPublisherRequests(
      token
    );
    
    if (response.code != 200) {
      throw Exception(response.message);
    }
    
    final List<dynamic> requestsData = response.data;
    return requestsData.map((data) => PublisherRequestModel.fromJson(data)).toList();
  }
  
  // Approve a game request
  Future<bool> approveGameRequest(String token, String requestId, {String? feedback}) async {
    final response = await _apiClient.approveGameRequest(
      token,
      requestId,
      feedback: feedback,
    );
    
    return response.code == 200;
  }
  // Approve a publisher request
  Future<bool> approvePublisherRequest(String token, String requestId, {String? feedback}) async {
    final response = await _apiClient.approvePublisherRequest(
      token,
      requestId,
      feedback: feedback,
    );
    
    return response.code == 200;
  }
  
  // Reject a game request
  Future<bool> rejectGameRequest(String token, String requestId, {required String feedback}) async {
    final response = await _apiClient.rejectGameRequest(
      token,
      requestId,
      feedback: feedback,
    );
    
    return response.code == 200;
  }
  // Reject a publisher request
  Future<bool> rejectPublisherRequest(String token, String requestId, {required String feedback}) async {
    final response = await _apiClient.rejectPublisherRequest(
      token,
      requestId,
      feedback: feedback,
    );
    
    return response.code == 200;
  }
}