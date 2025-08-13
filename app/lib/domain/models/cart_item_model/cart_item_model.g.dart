// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    _CartItemModel(
      cartItemId: json['cartitemid'] as String?,
      userId: json['userid'] as String,
      game: GameModel.fromJson(json['game'] as Map<String, dynamic>),
      addedAt: DateTime.parse(json['added_at'] as String),
    );

Map<String, dynamic> _$CartItemModelToJson(_CartItemModel instance) =>
    <String, dynamic>{
      'cartitemid': instance.cartItemId,
      'userid': instance.userId,
      'game': instance.game,
      'added_at': instance.addedAt.toIso8601String(),
    };
