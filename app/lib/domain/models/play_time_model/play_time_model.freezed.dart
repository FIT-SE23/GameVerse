// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'play_time_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayTimeModel {

@JsonKey(name: 'playtimeid') String? get playtimeId;@JsonKey(name: 'userid') String? get userId;@JsonKey(name: 'begin') DateTime get begin;@JsonKey(name: 'end') DateTime? get end;
/// Create a copy of PlayTimeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayTimeModelCopyWith<PlayTimeModel> get copyWith => _$PlayTimeModelCopyWithImpl<PlayTimeModel>(this as PlayTimeModel, _$identity);

  /// Serializes this PlayTimeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayTimeModel&&(identical(other.playtimeId, playtimeId) || other.playtimeId == playtimeId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.begin, begin) || other.begin == begin)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playtimeId,userId,begin,end);

@override
String toString() {
  return 'PlayTimeModel(playtimeId: $playtimeId, userId: $userId, begin: $begin, end: $end)';
}


}

/// @nodoc
abstract mixin class $PlayTimeModelCopyWith<$Res>  {
  factory $PlayTimeModelCopyWith(PlayTimeModel value, $Res Function(PlayTimeModel) _then) = _$PlayTimeModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'playtimeid') String? playtimeId,@JsonKey(name: 'userid') String? userId,@JsonKey(name: 'begin') DateTime begin,@JsonKey(name: 'end') DateTime? end
});




}
/// @nodoc
class _$PlayTimeModelCopyWithImpl<$Res>
    implements $PlayTimeModelCopyWith<$Res> {
  _$PlayTimeModelCopyWithImpl(this._self, this._then);

  final PlayTimeModel _self;
  final $Res Function(PlayTimeModel) _then;

/// Create a copy of PlayTimeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playtimeId = freezed,Object? userId = freezed,Object? begin = null,Object? end = freezed,}) {
  return _then(_self.copyWith(
playtimeId: freezed == playtimeId ? _self.playtimeId : playtimeId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,begin: null == begin ? _self.begin : begin // ignore: cast_nullable_to_non_nullable
as DateTime,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayTimeModel].
extension PlayTimeModelPatterns on PlayTimeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayTimeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayTimeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayTimeModel value)  $default,){
final _that = this;
switch (_that) {
case _PlayTimeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayTimeModel value)?  $default,){
final _that = this;
switch (_that) {
case _PlayTimeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'playtimeid')  String? playtimeId, @JsonKey(name: 'userid')  String? userId, @JsonKey(name: 'begin')  DateTime begin, @JsonKey(name: 'end')  DateTime? end)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayTimeModel() when $default != null:
return $default(_that.playtimeId,_that.userId,_that.begin,_that.end);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'playtimeid')  String? playtimeId, @JsonKey(name: 'userid')  String? userId, @JsonKey(name: 'begin')  DateTime begin, @JsonKey(name: 'end')  DateTime? end)  $default,) {final _that = this;
switch (_that) {
case _PlayTimeModel():
return $default(_that.playtimeId,_that.userId,_that.begin,_that.end);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'playtimeid')  String? playtimeId, @JsonKey(name: 'userid')  String? userId, @JsonKey(name: 'begin')  DateTime begin, @JsonKey(name: 'end')  DateTime? end)?  $default,) {final _that = this;
switch (_that) {
case _PlayTimeModel() when $default != null:
return $default(_that.playtimeId,_that.userId,_that.begin,_that.end);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayTimeModel implements PlayTimeModel {
  const _PlayTimeModel({@JsonKey(name: 'playtimeid') this.playtimeId, @JsonKey(name: 'userid') this.userId, @JsonKey(name: 'begin') required this.begin, @JsonKey(name: 'end') this.end});
  factory _PlayTimeModel.fromJson(Map<String, dynamic> json) => _$PlayTimeModelFromJson(json);

@override@JsonKey(name: 'playtimeid') final  String? playtimeId;
@override@JsonKey(name: 'userid') final  String? userId;
@override@JsonKey(name: 'begin') final  DateTime begin;
@override@JsonKey(name: 'end') final  DateTime? end;

/// Create a copy of PlayTimeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayTimeModelCopyWith<_PlayTimeModel> get copyWith => __$PlayTimeModelCopyWithImpl<_PlayTimeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayTimeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayTimeModel&&(identical(other.playtimeId, playtimeId) || other.playtimeId == playtimeId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.begin, begin) || other.begin == begin)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playtimeId,userId,begin,end);

@override
String toString() {
  return 'PlayTimeModel(playtimeId: $playtimeId, userId: $userId, begin: $begin, end: $end)';
}


}

/// @nodoc
abstract mixin class _$PlayTimeModelCopyWith<$Res> implements $PlayTimeModelCopyWith<$Res> {
  factory _$PlayTimeModelCopyWith(_PlayTimeModel value, $Res Function(_PlayTimeModel) _then) = __$PlayTimeModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'playtimeid') String? playtimeId,@JsonKey(name: 'userid') String? userId,@JsonKey(name: 'begin') DateTime begin,@JsonKey(name: 'end') DateTime? end
});




}
/// @nodoc
class __$PlayTimeModelCopyWithImpl<$Res>
    implements _$PlayTimeModelCopyWith<$Res> {
  __$PlayTimeModelCopyWithImpl(this._self, this._then);

  final _PlayTimeModel _self;
  final $Res Function(_PlayTimeModel) _then;

/// Create a copy of PlayTimeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playtimeId = freezed,Object? userId = freezed,Object? begin = null,Object? end = freezed,}) {
  return _then(_PlayTimeModel(
playtimeId: freezed == playtimeId ? _self.playtimeId : playtimeId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,begin: null == begin ? _self.begin : begin // ignore: cast_nullable_to_non_nullable
as DateTime,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
