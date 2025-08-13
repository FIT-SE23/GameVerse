import 'package:flutter/foundation.dart';
import 'package:gameverse/domain/models/transaction_model/transaction_model.dart';
import 'package:gameverse/domain/models/cart_item_model/cart_item_model.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:gameverse/domain/models/payment_method_model/payment_method_model.dart';
import 'package:gameverse/data/services/transaction_api_client.dart';

enum TransactionViewState { initial, loading, success, error }

class TransactionViewModel extends ChangeNotifier {
  final TransactionApiClient _transactionApiClient = TransactionApiClient();
  
  TransactionViewState _state = TransactionViewState.initial;
  TransactionViewState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  
  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;
  
  
  List<CartItemModel> _cartItems = [];
  List<CartItemModel> get cartItems => _cartItems;
  
  bool _isProcessingCheckout = false;
  bool get isProcessingCheckout => _isProcessingCheckout;

  List<PaymentMethodModel> _paymentMethods = [];
  List<PaymentMethodModel> get paymentMethods => _paymentMethods;

  // Check if game is in cart
  bool isGameInCart(String gameId) {
    return _cartItems.any((item) => item.game.gameId == gameId);
  }

  // Add game to cart
  void addToCart(GameModel game) {
    // Only add if not already in cart
    if (!isGameInCart(game.gameId)) {
      final cartItem = CartItemModel(
        userId: '', // Will be set when sending to server
        game: game,
        addedAt: DateTime.now(),
      );
      
      _cartItems.add(cartItem);
      notifyListeners();
    }
  }

  // Remove game from cart
  void removeFromCart(String gameId) {
    _cartItems.removeWhere((item) => item.game.gameId == gameId);
    notifyListeners();
  }

  // Clear cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Calculate cart totals
  double calculateSubtotal() {
    return _cartItems.fold(0.0, (sum, item) => sum + item.game.price);
  }

  double calculateDiscount() {
    return _cartItems.fold(0.0, (sum, item) {
      if (item.game.isSale == true && item.game.discountPercent != null) {
        return sum + (item.game.price * item.game.discountPercent! / 100);
      }
      return sum;
    });
  }

  double calculateTotal() {
    return _cartItems.fold(0.0, (sum, item) => sum + item.price);
  }

  // Load user's transactions
  Future<void> loadUserTransactions(String userId) async {
    try {
      _state = TransactionViewState.loading;
      notifyListeners();

      final transactions = await _transactionApiClient.getUserTransactions(userId);
      _transactions = transactions;
      
      _state = TransactionViewState.success;
    } catch (e) {
      _state = TransactionViewState.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // Process checkout (creates a transaction for each game)
  Future<bool> processCheckout({
    required String userId,
    required String paymentMethodId,
  }) async {
    if (_cartItems.isEmpty) return false;

    try {
      _isProcessingCheckout = true;
      notifyListeners();

      // Create a transaction for each game in cart
      final newTransactions = <TransactionModel>[];
      
      for (final item in _cartItems) {
        final transaction = TransactionModel(
          senderId: userId,
          amount: item.price,
          status: 'completed',
          transactionDate: DateTime.now(),
          paymentMethodId: paymentMethodId,
          gameId: item.game.gameId,
          isRefundable: true, // Assuming all transactions are refundable
        );
        
        // Send transaction to server
        await _transactionApiClient.saveTransaction(transaction);
        
        // Add to local transactions list
        newTransactions.add(transaction);
      }
      
      // Update transactions list with new transactions
      _transactions.insertAll(0, newTransactions);
      
      // Clear cart after successful purchase
      clearCart();
      
      return true;
    } catch (e) {
      _errorMessage = 'Checkout failed: $e';
      return false;
    } finally {
      _isProcessingCheckout = false;
      notifyListeners();
    }
  }
}