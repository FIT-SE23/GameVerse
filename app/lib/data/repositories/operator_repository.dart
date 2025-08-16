import 'package:gameverse/data/services/operator_api_client.dart';
import 'package:gameverse/domain/models/game_request_model/game_request_model.dart';

class OperatorRepository {
  final OperatorApiClient _apiClient;
  
  OperatorRepository({OperatorApiClient? apiClient})
      : _apiClient = apiClient ?? OperatorApiClient();
  
  // Get all pending game requests
  Future<List<GameRequestModel>> getPendingRequests(String token) async {
    final response = await _apiClient.getPendingRequests(
      token
    );
    
    if (response.code != 200) {
      throw Exception(response.message);
    }
    
    final List<dynamic> requestsData = response.data;
    return requestsData.map((data) => GameRequestModel.fromJson(data)).toList();
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
  
  // Reject a game request
  Future<bool> rejectGameRequest(String token, String requestId, {required String feedback}) async {
    final response = await _apiClient.rejectGameRequest(
      token,
      requestId,
      feedback: feedback,
    );
    
    return response.code == 200;
  }
}