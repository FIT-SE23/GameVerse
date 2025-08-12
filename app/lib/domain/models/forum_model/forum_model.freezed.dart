// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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

@JsonKey(name: 'gameid') String get gameId; String get name;@JsonKey(name: 'briefdescription') String get briefDescription;@JsonKey(name: 'headerimage') String get headerImage;
/// Create a copy of ForumModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForumModelCopyWith<ForumModel> get copyWith => _$ForumModelCopyWithImpl<ForumModel>(this as ForumModel, _$identity);

  /// Serializes this ForumModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForumModel&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.name, name) || other.name == name)&&(identical(other.briefDescription, briefDescription) || other.briefDescription == briefDescription)&&(identical(other.headerImage, headerImage) || other.headerImage == headerImage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameId,name,briefDescription,headerImage);

@override
String toString() {
  return 'ForumModel(gameId: $gameId, name: $name, briefDescription: $briefDescription, headerImage: $headerImage)';
}


}

/// @nodoc
abstract mixin class $ForumModelCopyWith<$Res>  {
  factory $ForumModelCopyWith(ForumModel value, $Res Function(ForumModel) _then) = _$ForumModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'gameid') String gameId, String name,@JsonKey(name: 'briefdescription') String briefDescription,@JsonKey(name: 'headerimage') String headerImage
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
@pragma('vm:prefer-inline') @override $Res call({Object? gameId = null,Object? name = null,Object? briefDescription = null,Object? headerImage = null,}) {
  return _then(_self.copyWith(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,briefDescription: null == briefDescription ? _self.briefDescription : briefDescription // ignore: cast_nullable_to_non_nullable
as String,headerImage: null == headerImage ? _self.headerImage : headerImage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ForumModel].
extension ForumModelPatterns on ForumModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForumModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForumModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForumModel value)  $default,){
final _that = this;
switch (_that) {
case _ForumModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForumModel value)?  $default,){
final _that = this;
switch (_that) {
case _ForumModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'gameid')  String gameId,  String name, @JsonKey(name: 'briefdescription')  String briefDescription, @JsonKey(name: 'headerimage')  String headerImage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForumModel() when $default != null:
return $default(_that.gameId,_that.name,_that.briefDescription,_that.headerImage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'gameid')  String gameId,  String name, @JsonKey(name: 'briefdescription')  String briefDescription, @JsonKey(name: 'headerimage')  String headerImage)  $default,) {final _that = this;
switch (_that) {
case _ForumModel():
return $default(_that.gameId,_that.name,_that.briefDescription,_that.headerImage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'gameid')  String gameId,  String name, @JsonKey(name: 'briefdescription')  String briefDescription, @JsonKey(name: 'headerimage')  String headerImage)?  $default,) {final _that = this;
switch (_that) {
case _ForumModel() when $default != null:
return $default(_that.gameId,_that.name,_that.briefDescription,_that.headerImage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ForumModel implements ForumModel {
  const _ForumModel({@JsonKey(name: 'gameid') required this.gameId, required this.name, @JsonKey(name: 'briefdescription') required this.briefDescription, @JsonKey(name: 'headerimage') required this.headerImage});
  factory _ForumModel.fromJson(Map<String, dynamic> json) => _$ForumModelFromJson(json);

@override@JsonKey(name: 'gameid') final  String gameId;
@override final  String name;
@override@JsonKey(name: 'briefdescription') final  String briefDescription;
@override@JsonKey(name: 'headerimage') final  String headerImage;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForumModel&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.name, name) || other.name == name)&&(identical(other.briefDescription, briefDescription) || other.briefDescription == briefDescription)&&(identical(other.headerImage, headerImage) || other.headerImage == headerImage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameId,name,briefDescription,headerImage);

@override
String toString() {
  return 'ForumModel(gameId: $gameId, name: $name, briefDescription: $briefDescription, headerImage: $headerImage)';
}


}

/// @nodoc
abstract mixin class _$ForumModelCopyWith<$Res> implements $ForumModelCopyWith<$Res> {
  factory _$ForumModelCopyWith(_ForumModel value, $Res Function(_ForumModel) _then) = __$ForumModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'gameid') String gameId, String name,@JsonKey(name: 'briefdescription') String briefDescription,@JsonKey(name: 'headerimage') String headerImage
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
@override @pragma('vm:prefer-inline') $Res call({Object? gameId = null,Object? name = null,Object? briefDescription = null,Object? headerImage = null,}) {
  return _then(_ForumModel(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,briefDescription: null == briefDescription ? _self.briefDescription : briefDescription // ignore: cast_nullable_to_non_nullable
as String,headerImage: null == headerImage ? _self.headerImage : headerImage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
