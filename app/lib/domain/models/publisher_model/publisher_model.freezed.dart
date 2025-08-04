// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'publisher_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PublisherModel {

 String get id; List<String>? get gamesPublishedID; String get description; String get name;
/// Create a copy of PublisherModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublisherModelCopyWith<PublisherModel> get copyWith => _$PublisherModelCopyWithImpl<PublisherModel>(this as PublisherModel, _$identity);

  /// Serializes this PublisherModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublisherModel&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.gamesPublishedID, gamesPublishedID)&&(identical(other.description, description) || other.description == description)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(gamesPublishedID),description,name);

@override
String toString() {
  return 'PublisherModel(id: $id, gamesPublishedID: $gamesPublishedID, description: $description, name: $name)';
}


}

/// @nodoc
abstract mixin class $PublisherModelCopyWith<$Res>  {
  factory $PublisherModelCopyWith(PublisherModel value, $Res Function(PublisherModel) _then) = _$PublisherModelCopyWithImpl;
@useResult
$Res call({
 String id, List<String>? gamesPublishedID, String description, String name
});




}
/// @nodoc
class _$PublisherModelCopyWithImpl<$Res>
    implements $PublisherModelCopyWith<$Res> {
  _$PublisherModelCopyWithImpl(this._self, this._then);

  final PublisherModel _self;
  final $Res Function(PublisherModel) _then;

/// Create a copy of PublisherModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? gamesPublishedID = freezed,Object? description = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,gamesPublishedID: freezed == gamesPublishedID ? _self.gamesPublishedID : gamesPublishedID // ignore: cast_nullable_to_non_nullable
as List<String>?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PublisherModel].
extension PublisherModelPatterns on PublisherModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublisherModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublisherModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublisherModel value)  $default,){
final _that = this;
switch (_that) {
case _PublisherModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublisherModel value)?  $default,){
final _that = this;
switch (_that) {
case _PublisherModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  List<String>? gamesPublishedID,  String description,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublisherModel() when $default != null:
return $default(_that.id,_that.gamesPublishedID,_that.description,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  List<String>? gamesPublishedID,  String description,  String name)  $default,) {final _that = this;
switch (_that) {
case _PublisherModel():
return $default(_that.id,_that.gamesPublishedID,_that.description,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  List<String>? gamesPublishedID,  String description,  String name)?  $default,) {final _that = this;
switch (_that) {
case _PublisherModel() when $default != null:
return $default(_that.id,_that.gamesPublishedID,_that.description,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PublisherModel implements PublisherModel {
  const _PublisherModel({required this.id, final  List<String>? gamesPublishedID, required this.description, required this.name}): _gamesPublishedID = gamesPublishedID;
  factory _PublisherModel.fromJson(Map<String, dynamic> json) => _$PublisherModelFromJson(json);

@override final  String id;
 final  List<String>? _gamesPublishedID;
@override List<String>? get gamesPublishedID {
  final value = _gamesPublishedID;
  if (value == null) return null;
  if (_gamesPublishedID is EqualUnmodifiableListView) return _gamesPublishedID;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String description;
@override final  String name;

/// Create a copy of PublisherModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublisherModelCopyWith<_PublisherModel> get copyWith => __$PublisherModelCopyWithImpl<_PublisherModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublisherModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublisherModel&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._gamesPublishedID, _gamesPublishedID)&&(identical(other.description, description) || other.description == description)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_gamesPublishedID),description,name);

@override
String toString() {
  return 'PublisherModel(id: $id, gamesPublishedID: $gamesPublishedID, description: $description, name: $name)';
}


}

/// @nodoc
abstract mixin class _$PublisherModelCopyWith<$Res> implements $PublisherModelCopyWith<$Res> {
  factory _$PublisherModelCopyWith(_PublisherModel value, $Res Function(_PublisherModel) _then) = __$PublisherModelCopyWithImpl;
@override @useResult
$Res call({
 String id, List<String>? gamesPublishedID, String description, String name
});




}
/// @nodoc
class __$PublisherModelCopyWithImpl<$Res>
    implements _$PublisherModelCopyWith<$Res> {
  __$PublisherModelCopyWithImpl(this._self, this._then);

  final _PublisherModel _self;
  final $Res Function(_PublisherModel) _then;

/// Create a copy of PublisherModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? gamesPublishedID = freezed,Object? description = null,Object? name = null,}) {
  return _then(_PublisherModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,gamesPublishedID: freezed == gamesPublishedID ? _self._gamesPublishedID : gamesPublishedID // ignore: cast_nullable_to_non_nullable
as List<String>?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
