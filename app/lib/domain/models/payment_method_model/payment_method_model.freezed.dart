// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_method_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentMethodModel {

@JsonKey(name: 'paymentmethodid') String get paymentMethodId; String get type;// e.g., "banking"
 String get information;
/// Create a copy of PaymentMethodModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentMethodModelCopyWith<PaymentMethodModel> get copyWith => _$PaymentMethodModelCopyWithImpl<PaymentMethodModel>(this as PaymentMethodModel, _$identity);

  /// Serializes this PaymentMethodModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentMethodModel&&(identical(other.paymentMethodId, paymentMethodId) || other.paymentMethodId == paymentMethodId)&&(identical(other.type, type) || other.type == type)&&(identical(other.information, information) || other.information == information));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,paymentMethodId,type,information);

@override
String toString() {
  return 'PaymentMethodModel(paymentMethodId: $paymentMethodId, type: $type, information: $information)';
}


}

/// @nodoc
abstract mixin class $PaymentMethodModelCopyWith<$Res>  {
  factory $PaymentMethodModelCopyWith(PaymentMethodModel value, $Res Function(PaymentMethodModel) _then) = _$PaymentMethodModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'paymentmethodid') String paymentMethodId, String type, String information
});




}
/// @nodoc
class _$PaymentMethodModelCopyWithImpl<$Res>
    implements $PaymentMethodModelCopyWith<$Res> {
  _$PaymentMethodModelCopyWithImpl(this._self, this._then);

  final PaymentMethodModel _self;
  final $Res Function(PaymentMethodModel) _then;

/// Create a copy of PaymentMethodModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? paymentMethodId = null,Object? type = null,Object? information = null,}) {
  return _then(_self.copyWith(
paymentMethodId: null == paymentMethodId ? _self.paymentMethodId : paymentMethodId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,information: null == information ? _self.information : information // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentMethodModel].
extension PaymentMethodModelPatterns on PaymentMethodModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentMethodModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentMethodModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentMethodModel value)  $default,){
final _that = this;
switch (_that) {
case _PaymentMethodModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentMethodModel value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentMethodModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'paymentmethodid')  String paymentMethodId,  String type,  String information)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentMethodModel() when $default != null:
return $default(_that.paymentMethodId,_that.type,_that.information);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'paymentmethodid')  String paymentMethodId,  String type,  String information)  $default,) {final _that = this;
switch (_that) {
case _PaymentMethodModel():
return $default(_that.paymentMethodId,_that.type,_that.information);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'paymentmethodid')  String paymentMethodId,  String type,  String information)?  $default,) {final _that = this;
switch (_that) {
case _PaymentMethodModel() when $default != null:
return $default(_that.paymentMethodId,_that.type,_that.information);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentMethodModel implements PaymentMethodModel {
  const _PaymentMethodModel({@JsonKey(name: 'paymentmethodid') required this.paymentMethodId, required this.type, required this.information});
  factory _PaymentMethodModel.fromJson(Map<String, dynamic> json) => _$PaymentMethodModelFromJson(json);

@override@JsonKey(name: 'paymentmethodid') final  String paymentMethodId;
@override final  String type;
// e.g., "banking"
@override final  String information;

/// Create a copy of PaymentMethodModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentMethodModelCopyWith<_PaymentMethodModel> get copyWith => __$PaymentMethodModelCopyWithImpl<_PaymentMethodModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentMethodModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentMethodModel&&(identical(other.paymentMethodId, paymentMethodId) || other.paymentMethodId == paymentMethodId)&&(identical(other.type, type) || other.type == type)&&(identical(other.information, information) || other.information == information));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,paymentMethodId,type,information);

@override
String toString() {
  return 'PaymentMethodModel(paymentMethodId: $paymentMethodId, type: $type, information: $information)';
}


}

/// @nodoc
abstract mixin class _$PaymentMethodModelCopyWith<$Res> implements $PaymentMethodModelCopyWith<$Res> {
  factory _$PaymentMethodModelCopyWith(_PaymentMethodModel value, $Res Function(_PaymentMethodModel) _then) = __$PaymentMethodModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'paymentmethodid') String paymentMethodId, String type, String information
});




}
/// @nodoc
class __$PaymentMethodModelCopyWithImpl<$Res>
    implements _$PaymentMethodModelCopyWith<$Res> {
  __$PaymentMethodModelCopyWithImpl(this._self, this._then);

  final _PaymentMethodModel _self;
  final $Res Function(_PaymentMethodModel) _then;

/// Create a copy of PaymentMethodModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? paymentMethodId = null,Object? type = null,Object? information = null,}) {
  return _then(_PaymentMethodModel(
paymentMethodId: null == paymentMethodId ? _self.paymentMethodId : paymentMethodId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,information: null == information ? _self.information : information // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
