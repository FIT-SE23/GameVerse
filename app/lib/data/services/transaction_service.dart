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
      transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      senderId: userId,
      gameId: game.gameId,
      amount: price,
      transactionDate: DateTime.now(),
      status: 'completed',
      isRefundable: true,
    );

    _userBalance -= price;
    _transactions.insert(0, transaction);

    return TransactionResult(
      success: true,
      message: 'Game purchased successfully!',
      transaction: transaction,
    );
  }

  double _getGamePrice(GameModel game) {
    return game.isSale == true && game.discountPercent != null
        ? game.price * (1 - (game.discountPercent! / 100))
        : game.price;
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