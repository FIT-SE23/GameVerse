import 'package:flutter/foundation.dart';

import 'package:gameverse/data/repositories/transaction_repository.dart';
import 'package:gameverse/data/repositories/auth_repository.dart';
import 'package:gameverse/domain/models/transaction_model/transaction_model.dart';
import 'package:gameverse/domain/models/cart_item_model/cart_item_model.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:gameverse/domain/models/payment_method_model/payment_method_model.dart';

enum TransactionViewState { initial, loading, success, error }

class TransactionViewModel extends ChangeNotifier {
  final TransactionRepository _transactionRepository;
  final AuthRepository _authRepository;

  TransactionViewModel({
    required TransactionRepository transactionRepository,
    required AuthRepository authRepository,
  })  : _transactionRepository = transactionRepository,
        _authRepository = authRepository {
    if (_authRepository.currentUser != null) {
      loadCartItems(_authRepository.currentUser!.id);
      loadUserTransactions(_authRepository.currentUser!.id);
    }
  }

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
        userId: _authRepository.currentUser!.id,
        game: game,
        addedAt: DateTime.now(),
      );
      
      _cartItems.add(cartItem);
      _transactionRepository.addToCart(_authRepository.accessToken!, game.gameId);
      notifyListeners();
    }
  }

  // Remove game from cart
  void removeFromCart(String gameId) {
    _cartItems.removeWhere((item) => item.game.gameId == gameId);
    _transactionRepository.removeFromCart(_authRepository.accessToken!, gameId);
    notifyListeners();
  }

  // Clear cart
  void clearCart() {
    _cartItems.clear();
    for (var item in _cartItems) {
      _transactionRepository.removeFromCart(_authRepository.accessToken!, item.game.gameId);
    }
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

      final transactions = await _transactionRepository.getUserTransactions(userId);
      _transactions = transactions;
      
      _state = TransactionViewState.success;
    } catch (e) {
      _state = TransactionViewState.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadCartItems(String userId) async {
    try {
      _state = TransactionViewState.loading;
      notifyListeners();

      // Assuming the repository has a method to get cart items
      _cartItems = await _transactionRepository.getCartItems(userId);
      
      _state = TransactionViewState.success;
    } catch (e) {
      _state = TransactionViewState.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // Load payment methods
  // Future<void> loadPaymentMethods() async {
  //   try {
  //     _state = TransactionViewState.loading;
  //     notifyListeners();

  //     // Assuming the repository has a method to get payment methods
  //     _paymentMethods = await _transactionRepository.getPaymentMethods();
      
  //     _state = TransactionViewState.success;
  //   } catch (e) {
  //     _state = TransactionViewState.error;
  //     _errorMessage = e.toString();
  //   } finally {
  //     notifyListeners();
  //   }
  // }
}