// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationModel {

@JsonKey(name: 'messageid') String? get notificationId;@JsonKey(name: 'userid') dynamic get userId;@JsonKey(name: 'approved') bool get approved;// has a game name if notification is related to a game
@JsonKey(name: 'gamename') String? get gameName;@JsonKey(name: 'date') DateTime get date;@JsonKey(name: 'message') String? get message;
/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationModelCopyWith<NotificationModel> get copyWith => _$NotificationModelCopyWithImpl<NotificationModel>(this as NotificationModel, _$identity);

  /// Serializes this NotificationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationModel&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&const DeepCollectionEquality().equals(other.userId, userId)&&(identical(other.approved, approved) || other.approved == approved)&&(identical(other.gameName, gameName) || other.gameName == gameName)&&(identical(other.date, date) || other.date == date)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notificationId,const DeepCollectionEquality().hash(userId),approved,gameName,date,message);

@override
String toString() {
  return 'NotificationModel(notificationId: $notificationId, userId: $userId, approved: $approved, gameName: $gameName, date: $date, message: $message)';
}


}

/// @nodoc
abstract mixin class $NotificationModelCopyWith<$Res>  {
  factory $NotificationModelCopyWith(NotificationModel value, $Res Function(NotificationModel) _then) = _$NotificationModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'messageid') String? notificationId,@JsonKey(name: 'userid') dynamic userId,@JsonKey(name: 'approved') bool approved,@JsonKey(name: 'gamename') String? gameName,@JsonKey(name: 'date') DateTime date,@JsonKey(name: 'message') String? message
});




}
/// @nodoc
class _$NotificationModelCopyWithImpl<$Res>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._self, this._then);

  final NotificationModel _self;
  final $Res Function(NotificationModel) _then;

/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notificationId = freezed,Object? userId = freezed,Object? approved = null,Object? gameName = freezed,Object? date = null,Object? message = freezed,}) {
  return _then(_self.copyWith(
notificationId: freezed == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as dynamic,approved: null == approved ? _self.approved : approved // ignore: cast_nullable_to_non_nullable
as bool,gameName: freezed == gameName ? _self.gameName : gameName // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationModel].
extension NotificationModelPatterns on NotificationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationModel value)  $default,){
final _that = this;
switch (_that) {
case _NotificationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationModel value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'messageid')  String? notificationId, @JsonKey(name: 'userid')  dynamic userId, @JsonKey(name: 'approved')  bool approved, @JsonKey(name: 'gamename')  String? gameName, @JsonKey(name: 'date')  DateTime date, @JsonKey(name: 'message')  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
return $default(_that.notificationId,_that.userId,_that.approved,_that.gameName,_that.date,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'messageid')  String? notificationId, @JsonKey(name: 'userid')  dynamic userId, @JsonKey(name: 'approved')  bool approved, @JsonKey(name: 'gamename')  String? gameName, @JsonKey(name: 'date')  DateTime date, @JsonKey(name: 'message')  String? message)  $default,) {final _that = this;
switch (_that) {
case _NotificationModel():
return $default(_that.notificationId,_that.userId,_that.approved,_that.gameName,_that.date,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'messageid')  String? notificationId, @JsonKey(name: 'userid')  dynamic userId, @JsonKey(name: 'approved')  bool approved, @JsonKey(name: 'gamename')  String? gameName, @JsonKey(name: 'date')  DateTime date, @JsonKey(name: 'message')  String? message)?  $default,) {final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
return $default(_that.notificationId,_that.userId,_that.approved,_that.gameName,_that.date,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationModel implements NotificationModel {
  const _NotificationModel({@JsonKey(name: 'messageid') this.notificationId, @JsonKey(name: 'userid') required this.userId, @JsonKey(name: 'approved') required this.approved, @JsonKey(name: 'gamename') this.gameName, @JsonKey(name: 'date') required this.date, @JsonKey(name: 'message') this.message});
  factory _NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

@override@JsonKey(name: 'messageid') final  String? notificationId;
@override@JsonKey(name: 'userid') final  dynamic userId;
@override@JsonKey(name: 'approved') final  bool approved;
// has a game name if notification is related to a game
@override@JsonKey(name: 'gamename') final  String? gameName;
@override@JsonKey(name: 'date') final  DateTime date;
@override@JsonKey(name: 'message') final  String? message;

/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationModelCopyWith<_NotificationModel> get copyWith => __$NotificationModelCopyWithImpl<_NotificationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationModel&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&const DeepCollectionEquality().equals(other.userId, userId)&&(identical(other.approved, approved) || other.approved == approved)&&(identical(other.gameName, gameName) || other.gameName == gameName)&&(identical(other.date, date) || other.date == date)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notificationId,const DeepCollectionEquality().hash(userId),approved,gameName,date,message);

@override
String toString() {
  return 'NotificationModel(notificationId: $notificationId, userId: $userId, approved: $approved, gameName: $gameName, date: $date, message: $message)';
}


}

/// @nodoc
abstract mixin class _$NotificationModelCopyWith<$Res> implements $NotificationModelCopyWith<$Res> {
  factory _$NotificationModelCopyWith(_NotificationModel value, $Res Function(_NotificationModel) _then) = __$NotificationModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'messageid') String? notificationId,@JsonKey(name: 'userid') dynamic userId,@JsonKey(name: 'approved') bool approved,@JsonKey(name: 'gamename') String? gameName,@JsonKey(name: 'date') DateTime date,@JsonKey(name: 'message') String? message
});




}
/// @nodoc
class __$NotificationModelCopyWithImpl<$Res>
    implements _$NotificationModelCopyWith<$Res> {
  __$NotificationModelCopyWithImpl(this._self, this._then);

  final _NotificationModel _self;
  final $Res Function(_NotificationModel) _then;

/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notificationId = freezed,Object? userId = freezed,Object? approved = null,Object? gameName = freezed,Object? date = null,Object? message = freezed,}) {
  return _then(_NotificationModel(
notificationId: freezed == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as dynamic,approved: null == approved ? _self.approved : approved // ignore: cast_nullable_to_non_nullable
as bool,gameName: freezed == gameName ? _self.gameName : gameName // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
