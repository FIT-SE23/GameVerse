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

 String get id; String get username; String get email; String? get avatar; String? get bio; String get type;// e.g., 'user', 'operator', 'publisher'
// Optional fields for user preferences
 List<String>? get ownedGamesID; List<String>? get favoriteGamesID; List<String>? get installedGamesID;// Optional fields for publisher
 String? get description; PaymentMethodModel? get paymentMethod; DateTime? get registrationDate; List<String>? get gamesPublishedID;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.ownedGamesID, ownedGamesID)&&const DeepCollectionEquality().equals(other.favoriteGamesID, favoriteGamesID)&&const DeepCollectionEquality().equals(other.installedGamesID, installedGamesID)&&(identical(other.description, description) || other.description == description)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.registrationDate, registrationDate) || other.registrationDate == registrationDate)&&const DeepCollectionEquality().equals(other.gamesPublishedID, gamesPublishedID));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,email,avatar,bio,type,const DeepCollectionEquality().hash(ownedGamesID),const DeepCollectionEquality().hash(favoriteGamesID),const DeepCollectionEquality().hash(installedGamesID),description,paymentMethod,registrationDate,const DeepCollectionEquality().hash(gamesPublishedID));

@override
String toString() {
  return 'UserModel(id: $id, username: $username, email: $email, avatar: $avatar, bio: $bio, type: $type, ownedGamesID: $ownedGamesID, favoriteGamesID: $favoriteGamesID, installedGamesID: $installedGamesID, description: $description, paymentMethod: $paymentMethod, registrationDate: $registrationDate, gamesPublishedID: $gamesPublishedID)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String id, String username, String email, String? avatar, String? bio, String type, List<String>? ownedGamesID, List<String>? favoriteGamesID, List<String>? installedGamesID, String? description, PaymentMethodModel? paymentMethod, DateTime? registrationDate, List<String>? gamesPublishedID
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? email = null,Object? avatar = freezed,Object? bio = freezed,Object? type = null,Object? ownedGamesID = freezed,Object? favoriteGamesID = freezed,Object? installedGamesID = freezed,Object? description = freezed,Object? paymentMethod = freezed,Object? registrationDate = freezed,Object? gamesPublishedID = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,ownedGamesID: freezed == ownedGamesID ? _self.ownedGamesID : ownedGamesID // ignore: cast_nullable_to_non_nullable
as List<String>?,favoriteGamesID: freezed == favoriteGamesID ? _self.favoriteGamesID : favoriteGamesID // ignore: cast_nullable_to_non_nullable
as List<String>?,installedGamesID: freezed == installedGamesID ? _self.installedGamesID : installedGamesID // ignore: cast_nullable_to_non_nullable
as List<String>?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethodModel?,registrationDate: freezed == registrationDate ? _self.registrationDate : registrationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,gamesPublishedID: freezed == gamesPublishedID ? _self.gamesPublishedID : gamesPublishedID // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String email,  String? avatar,  String? bio,  String type,  List<String>? ownedGamesID,  List<String>? favoriteGamesID,  List<String>? installedGamesID,  String? description,  PaymentMethodModel? paymentMethod,  DateTime? registrationDate,  List<String>? gamesPublishedID)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.username,_that.email,_that.avatar,_that.bio,_that.type,_that.ownedGamesID,_that.favoriteGamesID,_that.installedGamesID,_that.description,_that.paymentMethod,_that.registrationDate,_that.gamesPublishedID);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String email,  String? avatar,  String? bio,  String type,  List<String>? ownedGamesID,  List<String>? favoriteGamesID,  List<String>? installedGamesID,  String? description,  PaymentMethodModel? paymentMethod,  DateTime? registrationDate,  List<String>? gamesPublishedID)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.username,_that.email,_that.avatar,_that.bio,_that.type,_that.ownedGamesID,_that.favoriteGamesID,_that.installedGamesID,_that.description,_that.paymentMethod,_that.registrationDate,_that.gamesPublishedID);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String email,  String? avatar,  String? bio,  String type,  List<String>? ownedGamesID,  List<String>? favoriteGamesID,  List<String>? installedGamesID,  String? description,  PaymentMethodModel? paymentMethod,  DateTime? registrationDate,  List<String>? gamesPublishedID)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.username,_that.email,_that.avatar,_that.bio,_that.type,_that.ownedGamesID,_that.favoriteGamesID,_that.installedGamesID,_that.description,_that.paymentMethod,_that.registrationDate,_that.gamesPublishedID);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel implements UserModel {
  const _UserModel({required this.id, required this.username, required this.email, this.avatar, this.bio, this.type = 'publisher', final  List<String>? ownedGamesID, final  List<String>? favoriteGamesID, final  List<String>? installedGamesID, this.description, this.paymentMethod, this.registrationDate, final  List<String>? gamesPublishedID}): _ownedGamesID = ownedGamesID,_favoriteGamesID = favoriteGamesID,_installedGamesID = installedGamesID,_gamesPublishedID = gamesPublishedID;
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  String id;
@override final  String username;
@override final  String email;
@override final  String? avatar;
@override final  String? bio;
@override@JsonKey() final  String type;
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

 final  List<String>? _favoriteGamesID;
@override List<String>? get favoriteGamesID {
  final value = _favoriteGamesID;
  if (value == null) return null;
  if (_favoriteGamesID is EqualUnmodifiableListView) return _favoriteGamesID;
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
@override final  PaymentMethodModel? paymentMethod;
@override final  DateTime? registrationDate;
 final  List<String>? _gamesPublishedID;
@override List<String>? get gamesPublishedID {
  final value = _gamesPublishedID;
  if (value == null) return null;
  if (_gamesPublishedID is EqualUnmodifiableListView) return _gamesPublishedID;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._ownedGamesID, _ownedGamesID)&&const DeepCollectionEquality().equals(other._favoriteGamesID, _favoriteGamesID)&&const DeepCollectionEquality().equals(other._installedGamesID, _installedGamesID)&&(identical(other.description, description) || other.description == description)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.registrationDate, registrationDate) || other.registrationDate == registrationDate)&&const DeepCollectionEquality().equals(other._gamesPublishedID, _gamesPublishedID));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,email,avatar,bio,type,const DeepCollectionEquality().hash(_ownedGamesID),const DeepCollectionEquality().hash(_favoriteGamesID),const DeepCollectionEquality().hash(_installedGamesID),description,paymentMethod,registrationDate,const DeepCollectionEquality().hash(_gamesPublishedID));

@override
String toString() {
  return 'UserModel(id: $id, username: $username, email: $email, avatar: $avatar, bio: $bio, type: $type, ownedGamesID: $ownedGamesID, favoriteGamesID: $favoriteGamesID, installedGamesID: $installedGamesID, description: $description, paymentMethod: $paymentMethod, registrationDate: $registrationDate, gamesPublishedID: $gamesPublishedID)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String email, String? avatar, String? bio, String type, List<String>? ownedGamesID, List<String>? favoriteGamesID, List<String>? installedGamesID, String? description, PaymentMethodModel? paymentMethod, DateTime? registrationDate, List<String>? gamesPublishedID
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? email = null,Object? avatar = freezed,Object? bio = freezed,Object? type = null,Object? ownedGamesID = freezed,Object? favoriteGamesID = freezed,Object? installedGamesID = freezed,Object? description = freezed,Object? paymentMethod = freezed,Object? registrationDate = freezed,Object? gamesPublishedID = freezed,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,ownedGamesID: freezed == ownedGamesID ? _self._ownedGamesID : ownedGamesID // ignore: cast_nullable_to_non_nullable
as List<String>?,favoriteGamesID: freezed == favoriteGamesID ? _self._favoriteGamesID : favoriteGamesID // ignore: cast_nullable_to_non_nullable
as List<String>?,installedGamesID: freezed == installedGamesID ? _self._installedGamesID : installedGamesID // ignore: cast_nullable_to_non_nullable
as List<String>?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethodModel?,registrationDate: freezed == registrationDate ? _self.registrationDate : registrationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,gamesPublishedID: freezed == gamesPublishedID ? _self._gamesPublishedID : gamesPublishedID // ignore: cast_nullable_to_non_nullable
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
