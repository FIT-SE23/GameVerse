import 'package:flutter/material.dart';
import 'package:gameverse/data/services/transaction_service.dart';
import 'package:gameverse/data/services/paypal_service.dart';
import 'package:gameverse/domain/models/transaction_model/transaction_model.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';

enum TransactionState { initial, loading, success, error }

class TransactionViewModel extends ChangeNotifier {
  final TransactionService _transactionService;

  TransactionViewModel({required TransactionService transactionService})
      : _transactionService = transactionService;

  TransactionState _state = TransactionState.initial;
  TransactionState get state => _state;

  double _balance = 0.0;
  double get balance => _balance;

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isProcessingTransaction = false;
  bool get isProcessingTransaction => _isProcessingTransaction;

  Future<void> loadUserData() async {
    try {
      _state = TransactionState.loading;
      notifyListeners();

      _balance = await _transactionService.getUserBalance();
      _transactions = await _transactionService.getTransactionHistory();
      
      _state = TransactionState.success;
    } catch (e) {
      _state = TransactionState.error;
      _errorMessage = 'Failed to load transaction data: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<bool> purchaseGame(GameModel game) async {
    try {
      _isProcessingTransaction = true;
      notifyListeners();

      final result = await _transactionService.processGamePurchase(
        game: game,
        userId: 'current_user',
      );

      if (result.success) {
        _balance = await _transactionService.getUserBalance();
        _transactions = await _transactionService.getTransactionHistory();
        _state = TransactionState.success;
      } else {
        _errorMessage = result.message;
        _state = TransactionState.error;
      }

      return result.success;
    } catch (e) {
      _errorMessage = 'Purchase failed: $e';
      _state = TransactionState.error;
      return false;
    } finally {
      _isProcessingTransaction = false;
      notifyListeners();
    }
  }

  Future<void> resetBalance() async {
    await _transactionService.resetBalance();
    await loadUserData();
  }

  void clearError() {
    _errorMessage = '';
    if (_state == TransactionState.error) {
      _state = TransactionState.success;
    }
    notifyListeners();
  }
}