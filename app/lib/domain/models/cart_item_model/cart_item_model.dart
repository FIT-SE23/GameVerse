import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

@freezed
abstract class CartItemModel with _$CartItemModel {
  const factory CartItemModel({
    required String cartItemId,
    required String userId,
    required GameModel game,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);
}