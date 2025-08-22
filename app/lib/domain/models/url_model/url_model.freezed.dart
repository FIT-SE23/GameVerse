// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'url_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UrlModel {

@JsonKey(name: 'urlid') String? get urlId;@JsonKey(name: 'url') String get url;@JsonKey(name: 'checksum') String? get checksum;
/// Create a copy of UrlModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UrlModelCopyWith<UrlModel> get copyWith => _$UrlModelCopyWithImpl<UrlModel>(this as UrlModel, _$identity);

  /// Serializes this UrlModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UrlModel&&(identical(other.urlId, urlId) || other.urlId == urlId)&&(identical(other.url, url) || other.url == url)&&(identical(other.checksum, checksum) || other.checksum == checksum));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,urlId,url,checksum);

@override
String toString() {
  return 'UrlModel(urlId: $urlId, url: $url, checksum: $checksum)';
}


}

/// @nodoc
abstract mixin class $UrlModelCopyWith<$Res>  {
  factory $UrlModelCopyWith(UrlModel value, $Res Function(UrlModel) _then) = _$UrlModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'urlid') String? urlId,@JsonKey(name: 'url') String url,@JsonKey(name: 'checksum') String? checksum
});




}
/// @nodoc
class _$UrlModelCopyWithImpl<$Res>
    implements $UrlModelCopyWith<$Res> {
  _$UrlModelCopyWithImpl(this._self, this._then);

  final UrlModel _self;
  final $Res Function(UrlModel) _then;

/// Create a copy of UrlModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? urlId = freezed,Object? url = null,Object? checksum = freezed,}) {
  return _then(_self.copyWith(
urlId: freezed == urlId ? _self.urlId : urlId // ignore: cast_nullable_to_non_nullable
as String?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,checksum: freezed == checksum ? _self.checksum : checksum // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UrlModel].
extension UrlModelPatterns on UrlModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UrlModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UrlModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UrlModel value)  $default,){
final _that = this;
switch (_that) {
case _UrlModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UrlModel value)?  $default,){
final _that = this;
switch (_that) {
case _UrlModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'urlid')  String? urlId, @JsonKey(name: 'url')  String url, @JsonKey(name: 'checksum')  String? checksum)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UrlModel() when $default != null:
return $default(_that.urlId,_that.url,_that.checksum);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'urlid')  String? urlId, @JsonKey(name: 'url')  String url, @JsonKey(name: 'checksum')  String? checksum)  $default,) {final _that = this;
switch (_that) {
case _UrlModel():
return $default(_that.urlId,_that.url,_that.checksum);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'urlid')  String? urlId, @JsonKey(name: 'url')  String url, @JsonKey(name: 'checksum')  String? checksum)?  $default,) {final _that = this;
switch (_that) {
case _UrlModel() when $default != null:
return $default(_that.urlId,_that.url,_that.checksum);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UrlModel implements UrlModel {
  const _UrlModel({@JsonKey(name: 'urlid') this.urlId, @JsonKey(name: 'url') required this.url, @JsonKey(name: 'checksum') this.checksum});
  factory _UrlModel.fromJson(Map<String, dynamic> json) => _$UrlModelFromJson(json);

@override@JsonKey(name: 'urlid') final  String? urlId;
@override@JsonKey(name: 'url') final  String url;
@override@JsonKey(name: 'checksum') final  String? checksum;

/// Create a copy of UrlModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UrlModelCopyWith<_UrlModel> get copyWith => __$UrlModelCopyWithImpl<_UrlModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UrlModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UrlModel&&(identical(other.urlId, urlId) || other.urlId == urlId)&&(identical(other.url, url) || other.url == url)&&(identical(other.checksum, checksum) || other.checksum == checksum));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,urlId,url,checksum);

@override
String toString() {
  return 'UrlModel(urlId: $urlId, url: $url, checksum: $checksum)';
}


}

/// @nodoc
abstract mixin class _$UrlModelCopyWith<$Res> implements $UrlModelCopyWith<$Res> {
  factory _$UrlModelCopyWith(_UrlModel value, $Res Function(_UrlModel) _then) = __$UrlModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'urlid') String? urlId,@JsonKey(name: 'url') String url,@JsonKey(name: 'checksum') String? checksum
});




}
/// @nodoc
class __$UrlModelCopyWithImpl<$Res>
    implements _$UrlModelCopyWith<$Res> {
  __$UrlModelCopyWithImpl(this._self, this._then);

  final _UrlModel _self;
  final $Res Function(_UrlModel) _then;

/// Create a copy of UrlModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? urlId = freezed,Object? url = null,Object? checksum = freezed,}) {
  return _then(_UrlModel(
urlId: freezed == urlId ? _self.urlId : urlId // ignore: cast_nullable_to_non_nullable
as String?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,checksum: freezed == checksum ? _self.checksum : checksum // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
