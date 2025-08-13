import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

@freezed
abstract class CartItemModel with _$CartItemModel {
  const factory CartItemModel({
    @JsonKey(name: 'cartitemid') String? cartItemId,
    @JsonKey(name: 'userid') required String userId,
    required GameModel game,
    @JsonKey(name: 'addedat') DateTime? addedAt,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);
}

extension CartItemModelExtension on CartItemModel {
  double get price {
    if (game.isSale == true && game.discountPercent != null) {
      return game.price * (1 - (game.discountPercent! / 100));
    }
    return game.price;
  }
}