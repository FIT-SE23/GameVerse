// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    _CartItemModel(
      cartItemId: json['cartItemId'] as String,
      userId: json['userId'] as String,
      game: GameModel.fromJson(json['game'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CartItemModelToJson(_CartItemModel instance) =>
    <String, dynamic>{
      'cartItemId': instance.cartItemId,
      'userId': instance.userId,
      'game': instance.game,
    };
