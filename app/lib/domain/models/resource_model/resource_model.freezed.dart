// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resource_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResourceModel {

 String get resourceId; String get type;// e.g., "image", "video", "audio"
 String get url;
/// Create a copy of ResourceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResourceModelCopyWith<ResourceModel> get copyWith => _$ResourceModelCopyWithImpl<ResourceModel>(this as ResourceModel, _$identity);

  /// Serializes this ResourceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResourceModel&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId)&&(identical(other.type, type) || other.type == type)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,resourceId,type,url);

@override
String toString() {
  return 'ResourceModel(resourceId: $resourceId, type: $type, url: $url)';
}


}

/// @nodoc
abstract mixin class $ResourceModelCopyWith<$Res>  {
  factory $ResourceModelCopyWith(ResourceModel value, $Res Function(ResourceModel) _then) = _$ResourceModelCopyWithImpl;
@useResult
$Res call({
 String resourceId, String type, String url
});




}
/// @nodoc
class _$ResourceModelCopyWithImpl<$Res>
    implements $ResourceModelCopyWith<$Res> {
  _$ResourceModelCopyWithImpl(this._self, this._then);

  final ResourceModel _self;
  final $Res Function(ResourceModel) _then;

/// Create a copy of ResourceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? resourceId = null,Object? type = null,Object? url = null,}) {
  return _then(_self.copyWith(
resourceId: null == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ResourceModel].
extension ResourceModelPatterns on ResourceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResourceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResourceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResourceModel value)  $default,){
final _that = this;
switch (_that) {
case _ResourceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResourceModel value)?  $default,){
final _that = this;
switch (_that) {
case _ResourceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String resourceId,  String type,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResourceModel() when $default != null:
return $default(_that.resourceId,_that.type,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String resourceId,  String type,  String url)  $default,) {final _that = this;
switch (_that) {
case _ResourceModel():
return $default(_that.resourceId,_that.type,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String resourceId,  String type,  String url)?  $default,) {final _that = this;
switch (_that) {
case _ResourceModel() when $default != null:
return $default(_that.resourceId,_that.type,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResourceModel implements ResourceModel {
  const _ResourceModel({required this.resourceId, required this.type, required this.url});
  factory _ResourceModel.fromJson(Map<String, dynamic> json) => _$ResourceModelFromJson(json);

@override final  String resourceId;
@override final  String type;
// e.g., "image", "video", "audio"
@override final  String url;

/// Create a copy of ResourceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResourceModelCopyWith<_ResourceModel> get copyWith => __$ResourceModelCopyWithImpl<_ResourceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResourceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResourceModel&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId)&&(identical(other.type, type) || other.type == type)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,resourceId,type,url);

@override
String toString() {
  return 'ResourceModel(resourceId: $resourceId, type: $type, url: $url)';
}


}

/// @nodoc
abstract mixin class _$ResourceModelCopyWith<$Res> implements $ResourceModelCopyWith<$Res> {
  factory _$ResourceModelCopyWith(_ResourceModel value, $Res Function(_ResourceModel) _then) = __$ResourceModelCopyWithImpl;
@override @useResult
$Res call({
 String resourceId, String type, String url
});




}
/// @nodoc
class __$ResourceModelCopyWithImpl<$Res>
    implements _$ResourceModelCopyWith<$Res> {
  __$ResourceModelCopyWithImpl(this._self, this._then);

  final _ResourceModel _self;
  final $Res Function(_ResourceModel) _then;

/// Create a copy of ResourceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? resourceId = null,Object? type = null,Object? url = null,}) {
  return _then(_ResourceModel(
resourceId: null == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
