// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

@JsonKey(name: 'userid') String get id; String get username; String get email; String get type;// e.g., 'user', 'operator', 'publisher'
// Optional fields for user preferences
 List<String>? get ownedGamesID; List<String>? get wishlistGamesID; List<String>? get installedGamesID;// Optional fields for publisher
 String? get description;@JsonKey(name: 'paymentmethod') PaymentMethodModel? get paymentMethod; List<String>? get publishedGamesID;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.ownedGamesID, ownedGamesID)&&const DeepCollectionEquality().equals(other.wishlistGamesID, wishlistGamesID)&&const DeepCollectionEquality().equals(other.installedGamesID, installedGamesID)&&(identical(other.description, description) || other.description == description)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&const DeepCollectionEquality().equals(other.publishedGamesID, publishedGamesID));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,email,type,const DeepCollectionEquality().hash(ownedGamesID),const DeepCollectionEquality().hash(wishlistGamesID),const DeepCollectionEquality().hash(installedGamesID),description,paymentMethod,const DeepCollectionEquality().hash(publishedGamesID));

@override
String toString() {
  return 'UserModel(id: $id, username: $username, email: $email, type: $type, ownedGamesID: $ownedGamesID, wishlistGamesID: $wishlistGamesID, installedGamesID: $installedGamesID, description: $description, paymentMethod: $paymentMethod, publishedGamesID: $publishedGamesID)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'userid') String id, String username, String email, String type, List<String>? ownedGamesID, List<String>? wishlistGamesID, List<String>? installedGamesID, String? description,@JsonKey(name: 'paymentmethod') PaymentMethodModel? paymentMethod, List<String>? publishedGamesID
});


$PaymentMethodModelCopyWith<$Res>? get paymentMethod;

}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? email = null,Object? type = null,Object? ownedGamesID = freezed,Object? wishlistGamesID = freezed,Object? installedGamesID = freezed,Object? description = freezed,Object? paymentMethod = freezed,Object? publishedGamesID = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,ownedGamesID: freezed == ownedGamesID ? _self.ownedGamesID : ownedGamesID // ignore: cast_nullable_to_non_nullable
as List<String>?,wishlistGamesID: freezed == wishlistGamesID ? _self.wishlistGamesID : wishlistGamesID // ignore: cast_nullable_to_non_nullable
as List<String>?,installedGamesID: freezed == installedGamesID ? _self.installedGamesID : installedGamesID // ignore: cast_nullable_to_non_nullable
as List<String>?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethodModel?,publishedGamesID: freezed == publishedGamesID ? _self.publishedGamesID : publishedGamesID // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentMethodModelCopyWith<$Res>? get paymentMethod {
    if (_self.paymentMethod == null) {
    return null;
  }

  return $PaymentMethodModelCopyWith<$Res>(_self.paymentMethod!, (value) {
    return _then(_self.copyWith(paymentMethod: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'userid')  String id,  String username,  String email,  String type,  List<String>? ownedGamesID,  List<String>? wishlistGamesID,  List<String>? installedGamesID,  String? description, @JsonKey(name: 'paymentmethod')  PaymentMethodModel? paymentMethod,  List<String>? publishedGamesID)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.username,_that.email,_that.type,_that.ownedGamesID,_that.wishlistGamesID,_that.installedGamesID,_that.description,_that.paymentMethod,_that.publishedGamesID);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'userid')  String id,  String username,  String email,  String type,  List<String>? ownedGamesID,  List<String>? wishlistGamesID,  List<String>? installedGamesID,  String? description, @JsonKey(name: 'paymentmethod')  PaymentMethodModel? paymentMethod,  List<String>? publishedGamesID)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.username,_that.email,_that.type,_that.ownedGamesID,_that.wishlistGamesID,_that.installedGamesID,_that.description,_that.paymentMethod,_that.publishedGamesID);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'userid')  String id,  String username,  String email,  String type,  List<String>? ownedGamesID,  List<String>? wishlistGamesID,  List<String>? installedGamesID,  String? description, @JsonKey(name: 'paymentmethod')  PaymentMethodModel? paymentMethod,  List<String>? publishedGamesID)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.username,_that.email,_that.type,_that.ownedGamesID,_that.wishlistGamesID,_that.installedGamesID,_that.description,_that.paymentMethod,_that.publishedGamesID);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel implements UserModel {
  const _UserModel({@JsonKey(name: 'userid') required this.id, required this.username, required this.email, required this.type, final  List<String>? ownedGamesID, final  List<String>? wishlistGamesID, final  List<String>? installedGamesID, this.description, @JsonKey(name: 'paymentmethod') this.paymentMethod, final  List<String>? publishedGamesID}): _ownedGamesID = ownedGamesID,_wishlistGamesID = wishlistGamesID,_installedGamesID = installedGamesID,_publishedGamesID = publishedGamesID;
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override@JsonKey(name: 'userid') final  String id;
@override final  String username;
@override final  String email;
@override final  String type;
// e.g., 'user', 'operator', 'publisher'
// Optional fields for user preferences
 final  List<String>? _ownedGamesID;
// e.g., 'user', 'operator', 'publisher'
// Optional fields for user preferences
@override List<String>? get ownedGamesID {
  final value = _ownedGamesID;
  if (value == null) return null;
  if (_ownedGamesID is EqualUnmodifiableListView) return _ownedGamesID;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _wishlistGamesID;
@override List<String>? get wishlistGamesID {
  final value = _wishlistGamesID;
  if (value == null) return null;
  if (_wishlistGamesID is EqualUnmodifiableListView) return _wishlistGamesID;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _installedGamesID;
@override List<String>? get installedGamesID {
  final value = _installedGamesID;
  if (value == null) return null;
  if (_installedGamesID is EqualUnmodifiableListView) return _installedGamesID;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// Optional fields for publisher
@override final  String? description;
@override@JsonKey(name: 'paymentmethod') final  PaymentMethodModel? paymentMethod;
 final  List<String>? _publishedGamesID;
@override List<String>? get publishedGamesID {
  final value = _publishedGamesID;
  if (value == null) return null;
  if (_publishedGamesID is EqualUnmodifiableListView) return _publishedGamesID;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._ownedGamesID, _ownedGamesID)&&const DeepCollectionEquality().equals(other._wishlistGamesID, _wishlistGamesID)&&const DeepCollectionEquality().equals(other._installedGamesID, _installedGamesID)&&(identical(other.description, description) || other.description == description)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&const DeepCollectionEquality().equals(other._publishedGamesID, _publishedGamesID));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,email,type,const DeepCollectionEquality().hash(_ownedGamesID),const DeepCollectionEquality().hash(_wishlistGamesID),const DeepCollectionEquality().hash(_installedGamesID),description,paymentMethod,const DeepCollectionEquality().hash(_publishedGamesID));

@override
String toString() {
  return 'UserModel(id: $id, username: $username, email: $email, type: $type, ownedGamesID: $ownedGamesID, wishlistGamesID: $wishlistGamesID, installedGamesID: $installedGamesID, description: $description, paymentMethod: $paymentMethod, publishedGamesID: $publishedGamesID)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'userid') String id, String username, String email, String type, List<String>? ownedGamesID, List<String>? wishlistGamesID, List<String>? installedGamesID, String? description,@JsonKey(name: 'paymentmethod') PaymentMethodModel? paymentMethod, List<String>? publishedGamesID
});


@override $PaymentMethodModelCopyWith<$Res>? get paymentMethod;

}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? email = null,Object? type = null,Object? ownedGamesID = freezed,Object? wishlistGamesID = freezed,Object? installedGamesID = freezed,Object? description = freezed,Object? paymentMethod = freezed,Object? publishedGamesID = freezed,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,ownedGamesID: freezed == ownedGamesID ? _self._ownedGamesID : ownedGamesID // ignore: cast_nullable_to_non_nullable
as List<String>?,wishlistGamesID: freezed == wishlistGamesID ? _self._wishlistGamesID : wishlistGamesID // ignore: cast_nullable_to_non_nullable
as List<String>?,installedGamesID: freezed == installedGamesID ? _self._installedGamesID : installedGamesID // ignore: cast_nullable_to_non_nullable
as List<String>?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethodModel?,publishedGamesID: freezed == publishedGamesID ? _self._publishedGamesID : publishedGamesID // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentMethodModelCopyWith<$Res>? get paymentMethod {
    if (_self.paymentMethod == null) {
    return null;
  }

  return $PaymentMethodModelCopyWith<$Res>(_self.paymentMethod!, (value) {
    return _then(_self.copyWith(paymentMethod: value));
  });
}
}

// dart format on
