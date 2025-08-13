import 'package:dio/dio.dart';
import 'package:gameverse/config/api_endpoints.dart';
import 'package:gameverse/domain/models/transaction_model/transaction_model.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';

class TransactionApiClient {
  final Dio _dio = Dio();

  TransactionApiClient() {
    _dio.options.baseUrl = ApiEndpoints.baseUrl;
    // Add interceptors for auth tokens if needed
  }

  // Get user transactions
  Future<List<TransactionModel>> getUserTransactions(String userId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.transactionUrl}/$userId');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => TransactionModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      // For development, return mock data
      return _getMockTransactions(userId);
    }
  }

  // Save transaction
  Future<void> saveTransaction(TransactionModel transaction) async {
    try {
      await _dio.post(
        ApiEndpoints.transactionUrl,
        data: transaction.toJson(),
      );
    } catch (e) {
      // For development, simulate success
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  // Mock data for development
  List<TransactionModel> _getMockTransactions(String userId) {
    return [
      TransactionModel(
        transactionId: 'txn_123456789',
        senderId: userId,
        amount: 19.99,
        status: 'completed',
        transactionDate: DateTime.now().subtract(const Duration(days: 3)),
        paymentMethodId: 'pm_123456789',
        gameId: 'game_1',
        isRefundable: true,
      ),
      TransactionModel(
        transactionId: 'txn_987654321',
        senderId: userId,
        amount: 24.99,
        status: 'completed',
        transactionDate: DateTime.now().subtract(const Duration(days: 10)),
        paymentMethodId: 'pm_987654321',
        gameId: 'game_2',
        isRefundable: false,
      ),
    ];
  }
}