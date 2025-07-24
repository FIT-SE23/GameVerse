// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forum_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ForumModel {

 String get id; String get relatedGameId; List<String>? get postsId;
/// Create a copy of ForumModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForumModelCopyWith<ForumModel> get copyWith => _$ForumModelCopyWithImpl<ForumModel>(this as ForumModel, _$identity);

  /// Serializes this ForumModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForumModel&&(identical(other.id, id) || other.id == id)&&(identical(other.relatedGameId, relatedGameId) || other.relatedGameId == relatedGameId)&&const DeepCollectionEquality().equals(other.postsId, postsId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,relatedGameId,const DeepCollectionEquality().hash(postsId));

@override
String toString() {
  return 'ForumModel(id: $id, relatedGameId: $relatedGameId, postsId: $postsId)';
}


}

/// @nodoc
abstract mixin class $ForumModelCopyWith<$Res>  {
  factory $ForumModelCopyWith(ForumModel value, $Res Function(ForumModel) _then) = _$ForumModelCopyWithImpl;
@useResult
$Res call({
 String id, String relatedGameId, List<String>? postsId
});




}
/// @nodoc
class _$ForumModelCopyWithImpl<$Res>
    implements $ForumModelCopyWith<$Res> {
  _$ForumModelCopyWithImpl(this._self, this._then);

  final ForumModel _self;
  final $Res Function(ForumModel) _then;

/// Create a copy of ForumModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? relatedGameId = null,Object? postsId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,relatedGameId: null == relatedGameId ? _self.relatedGameId : relatedGameId // ignore: cast_nullable_to_non_nullable
as String,postsId: freezed == postsId ? _self.postsId : postsId // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ForumModel implements ForumModel {
  const _ForumModel({required this.id, required this.relatedGameId, final  List<String>? postsId}): _postsId = postsId;
  factory _ForumModel.fromJson(Map<String, dynamic> json) => _$ForumModelFromJson(json);

@override final  String id;
@override final  String relatedGameId;
 final  List<String>? _postsId;
@override List<String>? get postsId {
  final value = _postsId;
  if (value == null) return null;
  if (_postsId is EqualUnmodifiableListView) return _postsId;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ForumModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForumModelCopyWith<_ForumModel> get copyWith => __$ForumModelCopyWithImpl<_ForumModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForumModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForumModel&&(identical(other.id, id) || other.id == id)&&(identical(other.relatedGameId, relatedGameId) || other.relatedGameId == relatedGameId)&&const DeepCollectionEquality().equals(other._postsId, _postsId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,relatedGameId,const DeepCollectionEquality().hash(_postsId));

@override
String toString() {
  return 'ForumModel(id: $id, relatedGameId: $relatedGameId, postsId: $postsId)';
}


}

/// @nodoc
abstract mixin class _$ForumModelCopyWith<$Res> implements $ForumModelCopyWith<$Res> {
  factory _$ForumModelCopyWith(_ForumModel value, $Res Function(_ForumModel) _then) = __$ForumModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String relatedGameId, List<String>? postsId
});




}
/// @nodoc
class __$ForumModelCopyWithImpl<$Res>
    implements _$ForumModelCopyWith<$Res> {
  __$ForumModelCopyWithImpl(this._self, this._then);

  final _ForumModel _self;
  final $Res Function(_ForumModel) _then;

/// Create a copy of ForumModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? relatedGameId = null,Object? postsId = freezed,}) {
  return _then(_ForumModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,relatedGameId: null == relatedGameId ? _self.relatedGameId : relatedGameId // ignore: cast_nullable_to_non_nullable
as String,postsId: freezed == postsId ? _self._postsId : postsId // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
