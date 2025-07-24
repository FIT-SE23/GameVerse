// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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

 String get id; String get name; String get email; String? get avatarUrl; String? get bio; String? get typeUser; List<String>? get ownedGamesID; List<String>? get favoriteGamesID; List<String>? get installedGamesID;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.typeUser, typeUser) || other.typeUser == typeUser)&&const DeepCollectionEquality().equals(other.ownedGamesID, ownedGamesID)&&const DeepCollectionEquality().equals(other.favoriteGamesID, favoriteGamesID)&&const DeepCollectionEquality().equals(other.installedGamesID, installedGamesID));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,avatarUrl,bio,typeUser,const DeepCollectionEquality().hash(ownedGamesID),const DeepCollectionEquality().hash(favoriteGamesID),const DeepCollectionEquality().hash(installedGamesID));

@override
String toString() {
  return 'UserModel(id: $id, name: $name, email: $email, avatarUrl: $avatarUrl, bio: $bio, typeUser: $typeUser, ownedGamesID: $ownedGamesID, favoriteGamesID: $favoriteGamesID, installedGamesID: $installedGamesID)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String email, String? avatarUrl, String? bio, String? typeUser, List<String>? ownedGamesID, List<String>? favoriteGamesID, List<String>? installedGamesID
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? avatarUrl = freezed,Object? bio = freezed,Object? typeUser = freezed,Object? ownedGamesID = freezed,Object? favoriteGamesID = freezed,Object? installedGamesID = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,typeUser: freezed == typeUser ? _self.typeUser : typeUser // ignore: cast_nullable_to_non_nullable
as String?,ownedGamesID: freezed == ownedGamesID ? _self.ownedGamesID : ownedGamesID // ignore: cast_nullable_to_non_nullable
as List<String>?,favoriteGamesID: freezed == favoriteGamesID ? _self.favoriteGamesID : favoriteGamesID // ignore: cast_nullable_to_non_nullable
as List<String>?,installedGamesID: freezed == installedGamesID ? _self.installedGamesID : installedGamesID // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _UserModel implements UserModel {
  const _UserModel({required this.id, required this.name, required this.email, this.avatarUrl, this.bio, this.typeUser, final  List<String>? ownedGamesID, final  List<String>? favoriteGamesID, final  List<String>? installedGamesID}): _ownedGamesID = ownedGamesID,_favoriteGamesID = favoriteGamesID,_installedGamesID = installedGamesID;
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String email;
@override final  String? avatarUrl;
@override final  String? bio;
@override final  String? typeUser;
 final  List<String>? _ownedGamesID;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.typeUser, typeUser) || other.typeUser == typeUser)&&const DeepCollectionEquality().equals(other._ownedGamesID, _ownedGamesID)&&const DeepCollectionEquality().equals(other._favoriteGamesID, _favoriteGamesID)&&const DeepCollectionEquality().equals(other._installedGamesID, _installedGamesID));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,avatarUrl,bio,typeUser,const DeepCollectionEquality().hash(_ownedGamesID),const DeepCollectionEquality().hash(_favoriteGamesID),const DeepCollectionEquality().hash(_installedGamesID));

@override
String toString() {
  return 'UserModel(id: $id, name: $name, email: $email, avatarUrl: $avatarUrl, bio: $bio, typeUser: $typeUser, ownedGamesID: $ownedGamesID, favoriteGamesID: $favoriteGamesID, installedGamesID: $installedGamesID)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String email, String? avatarUrl, String? bio, String? typeUser, List<String>? ownedGamesID, List<String>? favoriteGamesID, List<String>? installedGamesID
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? avatarUrl = freezed,Object? bio = freezed,Object? typeUser = freezed,Object? ownedGamesID = freezed,Object? favoriteGamesID = freezed,Object? installedGamesID = freezed,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,typeUser: freezed == typeUser ? _self.typeUser : typeUser // ignore: cast_nullable_to_non_nullable
as String?,ownedGamesID: freezed == ownedGamesID ? _self._ownedGamesID : ownedGamesID // ignore: cast_nullable_to_non_nullable
as List<String>?,favoriteGamesID: freezed == favoriteGamesID ? _self._favoriteGamesID : favoriteGamesID // ignore: cast_nullable_to_non_nullable
as List<String>?,installedGamesID: freezed == installedGamesID ? _self._installedGamesID : installedGamesID // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
