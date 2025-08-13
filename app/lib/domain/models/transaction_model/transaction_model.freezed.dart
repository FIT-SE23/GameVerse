// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionModel {

@JsonKey(name: 'transactionid') String? get transactionId;@JsonKey(name: 'senderid') String get senderId;@JsonKey(name: 'gameid') String get gameId; double get amount;@JsonKey(name: 'transactiondate') DateTime get transactionDate;@JsonKey(name: 'isrefundable') bool get isRefundable;@JsonKey(name: 'paymentmethodid') String get paymentMethodId; String? get status;
/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionModelCopyWith<TransactionModel> get copyWith => _$TransactionModelCopyWithImpl<TransactionModel>(this as TransactionModel, _$identity);

  /// Serializes this TransactionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionModel&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.isRefundable, isRefundable) || other.isRefundable == isRefundable)&&(identical(other.paymentMethodId, paymentMethodId) || other.paymentMethodId == paymentMethodId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transactionId,senderId,gameId,amount,transactionDate,isRefundable,paymentMethodId,status);

@override
String toString() {
  return 'TransactionModel(transactionId: $transactionId, senderId: $senderId, gameId: $gameId, amount: $amount, transactionDate: $transactionDate, isRefundable: $isRefundable, paymentMethodId: $paymentMethodId, status: $status)';
}


}

/// @nodoc
abstract mixin class $TransactionModelCopyWith<$Res>  {
  factory $TransactionModelCopyWith(TransactionModel value, $Res Function(TransactionModel) _then) = _$TransactionModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'transactionid') String? transactionId,@JsonKey(name: 'senderid') String senderId,@JsonKey(name: 'gameid') String gameId, double amount,@JsonKey(name: 'transactiondate') DateTime transactionDate,@JsonKey(name: 'isrefundable') bool isRefundable,@JsonKey(name: 'paymentmethodid') String paymentMethodId, String? status
});




}
/// @nodoc
class _$TransactionModelCopyWithImpl<$Res>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._self, this._then);

  final TransactionModel _self;
  final $Res Function(TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transactionId = freezed,Object? senderId = null,Object? gameId = null,Object? amount = null,Object? transactionDate = null,Object? isRefundable = null,Object? paymentMethodId = null,Object? status = freezed,}) {
  return _then(_self.copyWith(
transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,transactionDate: null == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime,isRefundable: null == isRefundable ? _self.isRefundable : isRefundable // ignore: cast_nullable_to_non_nullable
as bool,paymentMethodId: null == paymentMethodId ? _self.paymentMethodId : paymentMethodId // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionModel].
extension TransactionModelPatterns on TransactionModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionModel value)  $default,){
final _that = this;
switch (_that) {
case _TransactionModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionModel value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'transactionid')  String? transactionId, @JsonKey(name: 'senderid')  String senderId, @JsonKey(name: 'gameid')  String gameId,  double amount, @JsonKey(name: 'transactiondate')  DateTime transactionDate, @JsonKey(name: 'isrefundable')  bool isRefundable, @JsonKey(name: 'paymentmethodid')  String paymentMethodId,  String? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.transactionId,_that.senderId,_that.gameId,_that.amount,_that.transactionDate,_that.isRefundable,_that.paymentMethodId,_that.status);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'transactionid')  String? transactionId, @JsonKey(name: 'senderid')  String senderId, @JsonKey(name: 'gameid')  String gameId,  double amount, @JsonKey(name: 'transactiondate')  DateTime transactionDate, @JsonKey(name: 'isrefundable')  bool isRefundable, @JsonKey(name: 'paymentmethodid')  String paymentMethodId,  String? status)  $default,) {final _that = this;
switch (_that) {
case _TransactionModel():
return $default(_that.transactionId,_that.senderId,_that.gameId,_that.amount,_that.transactionDate,_that.isRefundable,_that.paymentMethodId,_that.status);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'transactionid')  String? transactionId, @JsonKey(name: 'senderid')  String senderId, @JsonKey(name: 'gameid')  String gameId,  double amount, @JsonKey(name: 'transactiondate')  DateTime transactionDate, @JsonKey(name: 'isrefundable')  bool isRefundable, @JsonKey(name: 'paymentmethodid')  String paymentMethodId,  String? status)?  $default,) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.transactionId,_that.senderId,_that.gameId,_that.amount,_that.transactionDate,_that.isRefundable,_that.paymentMethodId,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionModel implements TransactionModel {
  const _TransactionModel({@JsonKey(name: 'transactionid') this.transactionId, @JsonKey(name: 'senderid') required this.senderId, @JsonKey(name: 'gameid') required this.gameId, required this.amount, @JsonKey(name: 'transactiondate') required this.transactionDate, @JsonKey(name: 'isrefundable') required this.isRefundable, @JsonKey(name: 'paymentmethodid') required this.paymentMethodId, this.status = 'completed'});
  factory _TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);

@override@JsonKey(name: 'transactionid') final  String? transactionId;
@override@JsonKey(name: 'senderid') final  String senderId;
@override@JsonKey(name: 'gameid') final  String gameId;
@override final  double amount;
@override@JsonKey(name: 'transactiondate') final  DateTime transactionDate;
@override@JsonKey(name: 'isrefundable') final  bool isRefundable;
@override@JsonKey(name: 'paymentmethodid') final  String paymentMethodId;
@override@JsonKey() final  String? status;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionModelCopyWith<_TransactionModel> get copyWith => __$TransactionModelCopyWithImpl<_TransactionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionModel&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.isRefundable, isRefundable) || other.isRefundable == isRefundable)&&(identical(other.paymentMethodId, paymentMethodId) || other.paymentMethodId == paymentMethodId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transactionId,senderId,gameId,amount,transactionDate,isRefundable,paymentMethodId,status);

@override
String toString() {
  return 'TransactionModel(transactionId: $transactionId, senderId: $senderId, gameId: $gameId, amount: $amount, transactionDate: $transactionDate, isRefundable: $isRefundable, paymentMethodId: $paymentMethodId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$TransactionModelCopyWith<$Res> implements $TransactionModelCopyWith<$Res> {
  factory _$TransactionModelCopyWith(_TransactionModel value, $Res Function(_TransactionModel) _then) = __$TransactionModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'transactionid') String? transactionId,@JsonKey(name: 'senderid') String senderId,@JsonKey(name: 'gameid') String gameId, double amount,@JsonKey(name: 'transactiondate') DateTime transactionDate,@JsonKey(name: 'isrefundable') bool isRefundable,@JsonKey(name: 'paymentmethodid') String paymentMethodId, String? status
});




}
/// @nodoc
class __$TransactionModelCopyWithImpl<$Res>
    implements _$TransactionModelCopyWith<$Res> {
  __$TransactionModelCopyWithImpl(this._self, this._then);

  final _TransactionModel _self;
  final $Res Function(_TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transactionId = freezed,Object? senderId = null,Object? gameId = null,Object? amount = null,Object? transactionDate = null,Object? isRefundable = null,Object? paymentMethodId = null,Object? status = freezed,}) {
  return _then(_TransactionModel(
transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,transactionDate: null == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime,isRefundable: null == isRefundable ? _self.isRefundable : isRefundable // ignore: cast_nullable_to_non_nullable
as bool,paymentMethodId: null == paymentMethodId ? _self.paymentMethodId : paymentMethodId // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
