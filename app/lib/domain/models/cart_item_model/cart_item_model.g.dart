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
      addedAt: json['addedat'] == null
          ? null
          : DateTime.parse(json['addedat'] as String),
    );

Map<String, dynamic> _$CartItemModelToJson(_CartItemModel instance) =>
    <String, dynamic>{
      'cartitemid': instance.cartItemId,
      'userid': instance.userId,
      'game': instance.game,
      'addedat': instance.addedAt?.toIso8601String(),
    };
