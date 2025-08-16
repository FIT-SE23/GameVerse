import 'package:gameverse/data/services/game_api_client.dart';
import 'package:gameverse/domain/models/cart_item_model/cart_item_model.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:gameverse/domain/models/transaction_model/transaction_model.dart';
import 'package:gameverse/data/services/transaction_api_client.dart';


class TransactionRepository {

  Future<List<TransactionModel>> getUserTransactions(String userId) async {
    final response = await TransactionApiClient().getUserTransactions(userId);
    if (response.code == 200) {
      // To do: Handle response data
      // return response.data as List<TransactionModel>;
      return _getMockTransactions(userId);
    } else {
      throw Exception('Failed to fetch transactions: ${response.message}');
    }
  }

  Future<bool> addToCart(String token, String gameId) async {
    final response = await GameApiClient().addGameWithStatus(token, gameId, 'In cart');
    if (response.code == 200) {
      return true;
    } else {
      throw Exception('Failed to add game to cart: ${response.message}');
    }
  }
  Future<bool> removeFromCart(String token, String gameId) async {
    final response = await GameApiClient().removeGameWithStatus(token, gameId, 'In cart');
    if (response.code == 200) {
      return true;
    } else {
      throw Exception('Failed to remove game from cart: ${response.message}');
    }
  }
  Future<bool> addToWishList(String token, String gameId) async {
    final response = await GameApiClient().addGameWithStatus(token, gameId, 'In wishlist');
    if (response.code == 200) {
      return true;
    } else {
      throw Exception('Failed to add game to wishlist: ${response.message}');
    }
  }
  Future<bool> removeFromWishList(String token, String gameId) async {
    final response = await GameApiClient().removeGameWithStatus(token, gameId, 'In wishlist');
    if (response.code == 200) {
      return true;
    } else {
      throw Exception('Failed to remove game from wishlist: ${response.message}');
    }
  }
  Future<List<CartItemModel>> getCartItems(String token) async {
    final response = await GameApiClient().getCartItems(token);
    if (response.code == 200) {
      List<CartItemModel> cartItems = [];
      for (final item in response.data) {
        final cartItem = CartItemModel(
          game: item as GameModel,
        );
        cartItems.add(cartItem);
      }
      return cartItems;
    } else {
      throw Exception('Failed to fetch cart items: ${response.message}');
    }
  }
  Future<List<GameModel>> getWishlistItems(String userId) async {
    final response = await GameApiClient().getWishListGames(userId);
    if (response.code == 200) {
      // Assuming the response data is a list of games
      return (response.data as List<dynamic>)
          .map((item) => GameModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch wishlist items: ${response.message}');
    }
  }

  Future<String> getPayPalPaymentGatewayUrl(String token) async {
    final response = await TransactionApiClient().getPayPalPaymentGatewayUrl(token);
    if (response.code == 200) {
      print(response.data);
      return response.data as String;
    } else {
      throw Exception('Failed to fetch PayPal payment gateway URL: ${response.message}');
    }
  }
  Future<String> getVNPayPaymentGatewayUrl(String token) async {
    final response = await TransactionApiClient().getVNPayPaymentGatewayUrl(token);
    if (response.code == 200) {
      print(response.data);
      return response.data as String;
    } else {
      throw Exception('Failed to fetch PayPal payment gateway URL: ${response.message}');
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