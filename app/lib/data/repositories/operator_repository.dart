import 'package:gameverse/data/services/operator_api_client.dart';
import 'package:gameverse/domain/models/game_request_model/game_request_model.dart';
import 'package:gameverse/domain/models/payment_method_model/payment_method_model.dart';
import 'package:gameverse/domain/models/publisher_request_model/publisher_request_model.dart';
import 'package:gameverse/domain/models/category_model/category_model.dart';

class OperatorRepository {
  final OperatorApiClient _apiClient;
  
  OperatorRepository({OperatorApiClient? apiClient})
      : _apiClient = apiClient ?? OperatorApiClient();

  CategoryModel convertToCategoryModel(Map<String, dynamic> json) {
    final categoryid = (json["categoryid"] ?? '') as String;
    final categoryName = (json["categoryname"] ?? '') as String;
    final isSensitive = json["issensitive"].toString().toLowerCase() as String?;
    return CategoryModel(categoryId: categoryid, name: categoryName, isSensitive: isSensitive == 'true');
  }

  GameRequestModel convertToGameRequest(Map<String, dynamic> json) {
    List<CategoryModel> categories = [];
    for (var list in json["Category"] as List<dynamic>) {     
      categories.add(convertToCategoryModel(list));
    }

    final raw = json["Resource"] as List<dynamic>;
    final rawHeader = raw.firstWhere(
      (list) => list["type"] as String == "media_header",
      orElse: () => <dynamic>[],
    );
    final rawMedia = raw.where(
      (list) => list["type"] as String == "media",
    ).toList();
    final rawBinaries = raw.where(
      (list) => list["type"] as String == "binary",
    ).toList();
    final rawExecutables = raw.where(
      (list) => list["type"] as String == "executable",
    ).toList();

    List<String> media = [for (final m in rawMedia) m["url"]];

    return GameRequestModel(
      requestId: (json["gameid"] ?? '') as String,
      publisherId: (json["publisherid"] ?? '') as String,
      gameName: (json["name"] ?? '') as String,
      description: (json["description"] ?? '') as String,
      briefDescription: (json["briefdescription"] ?? '') as String,
      requirements: (json["requirement"] ?? '') as String,
      price: json["price"].toDouble() as double,
      submissionDate: DateTime.parse(json["releasedate"] as String? ?? ""),
      categories: categories,
      media: media,
      headerImage: (rawHeader.isNotEmpty ? rawHeader["url"] : '') as String,
      binaries: rawBinaries.map((b) => b["url"] as String).toList(),
      exes: rawExecutables.map((e) => e["url"] as String).toList(),
    );
  }

  PublisherRequestModel convertToPublisherRequest(Map<String, dynamic> json) {
    return PublisherRequestModel(
      requestId: (json["publisherid"] ?? '') as String,
      userId: (json["publisherid"] ?? '') as String,
      username: (json["User"]["username"] ?? '') as String,
      email: (json["User"]["email"] ?? '') as String,
      description: (json["description"] ?? '') as String,
      paymentMethod: PaymentMethodModel.fromJson(json["PaymentMethod"]),
      paymentCardNumber: (json["paymentcardnumber"] ?? '') as String,
      submissionDate: DateTime.parse(json["date"] as String? ?? ""),
    );
  }
  
  // Get all pending game requests
  Future<List<GameRequestModel>> getPendingGameRequests(String token) async {
    final response = await _apiClient.getPendingGameRequests(
      token
    );
    
    if (response.code != 200) {
      throw Exception(response.message);
    }
    final List<dynamic> requestsData = response.data;
    return requestsData.map((data) => convertToGameRequest(data)).toList();
  }
  Future<List<PublisherRequestModel>> getPendingPublisherRequests(String token) async {
    final response = await _apiClient.getPendingPublisherRequests(
      token
    );
    
    if (response.code != 200) {
      throw Exception(response.message);
    }
    final List<dynamic> requestsData = response.data;
    return requestsData.map((data) => convertToPublisherRequest(data)).toList();
  }
  
  // Approve a game request
  Future<bool> approveGameRequest(String token, String requestId, {String? feedback}) async {
    final response = await _apiClient.approveGameRequest(
      token,
      requestId,
    );
    
    return response.code == 200;
  }
  // Approve a publisher request
  Future<bool> approvePublisherRequest(String token, String requestId, {String? feedback}) async {
    final response = await _apiClient.approvePublisherRequest(
      token,
      requestId,
    );
    
    return response.code == 200;
  }
  
  // Reject a game request
  Future<bool> rejectGameRequest(String token, String publisherId, String requestId, {
    required String gameName,
    required String feedback}) async {
    final response = await _apiClient.rejectGameRequest(
      token,
      publisherId,
      requestId,
      gameName: gameName,
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