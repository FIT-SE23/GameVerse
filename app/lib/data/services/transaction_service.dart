import 'dart:developer';

import 'package:gameverse/domain/models/transaction_model/transaction_model.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';

class TransactionService {
  // Mock user balance
  static double _userBalance = 1000.0;
  static final List<TransactionModel> _transactions = [];

  Future<double> getUserBalance() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _userBalance;
  }

  Future<List<TransactionModel>> getTransactionHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_transactions);
  }

  Future<TransactionResult> processGamePurchase({
    required GameModel game,
    required String userId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final price = _getGamePrice(game);
    
    if (_userBalance < price) {
      return TransactionResult(
        success: false,
        message: 'Insufficient balance. You need \$${price.toStringAsFixed(2)} but only have \$${_userBalance.toStringAsFixed(2)}',
      );
    }

    final transaction = TransactionModel(
      id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      senderId: userId,
      receiverId: 'gameverse_store',
      amount: price,
      transactionDate: DateTime.now(),
      status: 'completed',
      description: 'Purchase: ${game.name}',
    );

    _userBalance -= price;
    _transactions.insert(0, transaction);

    return TransactionResult(
      success: true,
      message: 'Game purchased successfully!',
      transaction: transaction,
    );
  }

  Future<TransactionResult> addFundsWithPayPal({
    required double amount,
    required String userId,
    required Map<dynamic, dynamic> paypalData,
  }) async {
    // Simulate processing time
    await Future.delayed(const Duration(milliseconds: 500));

    // Extract payment details from PayPal response
    String paymentId = 'N/A';
    String payerId = 'N/A';
    
    try {
      if (paypalData.containsKey('paymentId')) {
        paymentId = paypalData['paymentId'].toString();
      }
      if (paypalData.containsKey('payerID')) {
        payerId = paypalData['payerID'].toString();
      }
    } catch (e) {
      log('Error extracting PayPal data: $e');
    }

    if (paymentId.length > 8) {
      paymentId = '${paymentId.substring(0, 8)}...';
    }

    final transaction = TransactionModel(
      id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      senderId: payerId,
      receiverId: userId,
      amount: amount,
      transactionDate: DateTime.now(),
      status: 'completed',
      description: 'Add Funds via PayPal (ID: $paymentId...)',
    );

    // Update balance and add transaction
    _userBalance += amount;
    _transactions.insert(0, transaction);

    return TransactionResult(
      success: true,
      message: 'Funds added successfully via PayPal!',
      transaction: transaction,
    );
  }

  Future<TransactionResult> addFunds({
    required double amount,
    required String userId,
    required String method,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (amount <= 0) {
      return TransactionResult(
        success: false,
        message: 'Invalid amount. Please enter a positive value.',
      );
    }

    if (amount > 10000) {
      return TransactionResult(
        success: false,
        message: 'Maximum add funds limit is \$10,000',
      );
    }

    final transaction = TransactionModel(
      id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'gameverse_store',
      receiverId: userId,
      amount: amount,
      transactionDate: DateTime.now(),
      status: 'completed',
      description: 'Add Funds via $method',
    );

    _userBalance += amount;
    _transactions.insert(0, transaction);

    return TransactionResult(
      success: true,
      message: 'Funds added successfully!',
      transaction: transaction,
    );
  }

  double _getGamePrice(GameModel game) {
    if (game.price != null) {
      return (game.price!['final'] as int) / 100.0;
    }
    return 0.0;
  }

  Future<void> resetBalance() async {
    _userBalance = 1000.0;
    _transactions.clear();
  }
}

class TransactionResult {
  final bool success;
  final String message;
  final TransactionModel? transaction;

  TransactionResult({
    required this.success,
    required this.message,
    this.transaction,
  });
}