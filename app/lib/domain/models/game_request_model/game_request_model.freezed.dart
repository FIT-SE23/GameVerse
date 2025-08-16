// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameRequestModel {

@JsonKey(name: 'publisherid') String get publisherId;@JsonKey(name: 'gamename') String get gameName;@JsonKey(name: 'briefdescription') String get briefDescription; String get description; String get requirements;@JsonKey(name: 'headerimage') String get headerImage; double get price; List<CategoryModel> get categories; List<String> get media;// Request related fields
@JsonKey(name: 'status') String get requestStatus;// e.g., 'pending', 'approved', 'rejected
// Upload related fields
 List<String> get binaries; List<String> get exes;
/// Create a copy of GameRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameRequestModelCopyWith<GameRequestModel> get copyWith => _$GameRequestModelCopyWithImpl<GameRequestModel>(this as GameRequestModel, _$identity);

  /// Serializes this GameRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameRequestModel&&(identical(other.publisherId, publisherId) || other.publisherId == publisherId)&&(identical(other.gameName, gameName) || other.gameName == gameName)&&(identical(other.briefDescription, briefDescription) || other.briefDescription == briefDescription)&&(identical(other.description, description) || other.description == description)&&(identical(other.requirements, requirements) || other.requirements == requirements)&&(identical(other.headerImage, headerImage) || other.headerImage == headerImage)&&(identical(other.price, price) || other.price == price)&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.media, media)&&(identical(other.requestStatus, requestStatus) || other.requestStatus == requestStatus)&&const DeepCollectionEquality().equals(other.binaries, binaries)&&const DeepCollectionEquality().equals(other.exes, exes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publisherId,gameName,briefDescription,description,requirements,headerImage,price,const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(media),requestStatus,const DeepCollectionEquality().hash(binaries),const DeepCollectionEquality().hash(exes));

@override
String toString() {
  return 'GameRequestModel(publisherId: $publisherId, gameName: $gameName, briefDescription: $briefDescription, description: $description, requirements: $requirements, headerImage: $headerImage, price: $price, categories: $categories, media: $media, requestStatus: $requestStatus, binaries: $binaries, exes: $exes)';
}


}

/// @nodoc
abstract mixin class $GameRequestModelCopyWith<$Res>  {
  factory $GameRequestModelCopyWith(GameRequestModel value, $Res Function(GameRequestModel) _then) = _$GameRequestModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'publisherid') String publisherId,@JsonKey(name: 'gamename') String gameName,@JsonKey(name: 'briefdescription') String briefDescription, String description, String requirements,@JsonKey(name: 'headerimage') String headerImage, double price, List<CategoryModel> categories, List<String> media,@JsonKey(name: 'status') String requestStatus, List<String> binaries, List<String> exes
});




}
/// @nodoc
class _$GameRequestModelCopyWithImpl<$Res>
    implements $GameRequestModelCopyWith<$Res> {
  _$GameRequestModelCopyWithImpl(this._self, this._then);

  final GameRequestModel _self;
  final $Res Function(GameRequestModel) _then;

/// Create a copy of GameRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? publisherId = null,Object? gameName = null,Object? briefDescription = null,Object? description = null,Object? requirements = null,Object? headerImage = null,Object? price = null,Object? categories = null,Object? media = null,Object? requestStatus = null,Object? binaries = null,Object? exes = null,}) {
  return _then(_self.copyWith(
publisherId: null == publisherId ? _self.publisherId : publisherId // ignore: cast_nullable_to_non_nullable
as String,gameName: null == gameName ? _self.gameName : gameName // ignore: cast_nullable_to_non_nullable
as String,briefDescription: null == briefDescription ? _self.briefDescription : briefDescription // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,requirements: null == requirements ? _self.requirements : requirements // ignore: cast_nullable_to_non_nullable
as String,headerImage: null == headerImage ? _self.headerImage : headerImage // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryModel>,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as List<String>,requestStatus: null == requestStatus ? _self.requestStatus : requestStatus // ignore: cast_nullable_to_non_nullable
as String,binaries: null == binaries ? _self.binaries : binaries // ignore: cast_nullable_to_non_nullable
as List<String>,exes: null == exes ? _self.exes : exes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [GameRequestModel].
extension GameRequestModelPatterns on GameRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _GameRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _GameRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'publisherid')  String publisherId, @JsonKey(name: 'gamename')  String gameName, @JsonKey(name: 'briefdescription')  String briefDescription,  String description,  String requirements, @JsonKey(name: 'headerimage')  String headerImage,  double price,  List<CategoryModel> categories,  List<String> media, @JsonKey(name: 'status')  String requestStatus,  List<String> binaries,  List<String> exes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameRequestModel() when $default != null:
return $default(_that.publisherId,_that.gameName,_that.briefDescription,_that.description,_that.requirements,_that.headerImage,_that.price,_that.categories,_that.media,_that.requestStatus,_that.binaries,_that.exes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'publisherid')  String publisherId, @JsonKey(name: 'gamename')  String gameName, @JsonKey(name: 'briefdescription')  String briefDescription,  String description,  String requirements, @JsonKey(name: 'headerimage')  String headerImage,  double price,  List<CategoryModel> categories,  List<String> media, @JsonKey(name: 'status')  String requestStatus,  List<String> binaries,  List<String> exes)  $default,) {final _that = this;
switch (_that) {
case _GameRequestModel():
return $default(_that.publisherId,_that.gameName,_that.briefDescription,_that.description,_that.requirements,_that.headerImage,_that.price,_that.categories,_that.media,_that.requestStatus,_that.binaries,_that.exes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'publisherid')  String publisherId, @JsonKey(name: 'gamename')  String gameName, @JsonKey(name: 'briefdescription')  String briefDescription,  String description,  String requirements, @JsonKey(name: 'headerimage')  String headerImage,  double price,  List<CategoryModel> categories,  List<String> media, @JsonKey(name: 'status')  String requestStatus,  List<String> binaries,  List<String> exes)?  $default,) {final _that = this;
switch (_that) {
case _GameRequestModel() when $default != null:
return $default(_that.publisherId,_that.gameName,_that.briefDescription,_that.description,_that.requirements,_that.headerImage,_that.price,_that.categories,_that.media,_that.requestStatus,_that.binaries,_that.exes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameRequestModel implements GameRequestModel {
  const _GameRequestModel({@JsonKey(name: 'publisherid') required this.publisherId, @JsonKey(name: 'gamename') required this.gameName, @JsonKey(name: 'briefdescription') required this.briefDescription, required this.description, required this.requirements, @JsonKey(name: 'headerimage') required this.headerImage, required this.price, required final  List<CategoryModel> categories, required final  List<String> media, @JsonKey(name: 'status') required this.requestStatus, required final  List<String> binaries, required final  List<String> exes}): _categories = categories,_media = media,_binaries = binaries,_exes = exes;
  factory _GameRequestModel.fromJson(Map<String, dynamic> json) => _$GameRequestModelFromJson(json);

@override@JsonKey(name: 'publisherid') final  String publisherId;
@override@JsonKey(name: 'gamename') final  String gameName;
@override@JsonKey(name: 'briefdescription') final  String briefDescription;
@override final  String description;
@override final  String requirements;
@override@JsonKey(name: 'headerimage') final  String headerImage;
@override final  double price;
 final  List<CategoryModel> _categories;
@override List<CategoryModel> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<String> _media;
@override List<String> get media {
  if (_media is EqualUnmodifiableListView) return _media;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_media);
}

// Request related fields
@override@JsonKey(name: 'status') final  String requestStatus;
// e.g., 'pending', 'approved', 'rejected
// Upload related fields
 final  List<String> _binaries;
// e.g., 'pending', 'approved', 'rejected
// Upload related fields
@override List<String> get binaries {
  if (_binaries is EqualUnmodifiableListView) return _binaries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_binaries);
}

 final  List<String> _exes;
@override List<String> get exes {
  if (_exes is EqualUnmodifiableListView) return _exes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exes);
}


/// Create a copy of GameRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameRequestModelCopyWith<_GameRequestModel> get copyWith => __$GameRequestModelCopyWithImpl<_GameRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameRequestModel&&(identical(other.publisherId, publisherId) || other.publisherId == publisherId)&&(identical(other.gameName, gameName) || other.gameName == gameName)&&(identical(other.briefDescription, briefDescription) || other.briefDescription == briefDescription)&&(identical(other.description, description) || other.description == description)&&(identical(other.requirements, requirements) || other.requirements == requirements)&&(identical(other.headerImage, headerImage) || other.headerImage == headerImage)&&(identical(other.price, price) || other.price == price)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._media, _media)&&(identical(other.requestStatus, requestStatus) || other.requestStatus == requestStatus)&&const DeepCollectionEquality().equals(other._binaries, _binaries)&&const DeepCollectionEquality().equals(other._exes, _exes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publisherId,gameName,briefDescription,description,requirements,headerImage,price,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_media),requestStatus,const DeepCollectionEquality().hash(_binaries),const DeepCollectionEquality().hash(_exes));

@override
String toString() {
  return 'GameRequestModel(publisherId: $publisherId, gameName: $gameName, briefDescription: $briefDescription, description: $description, requirements: $requirements, headerImage: $headerImage, price: $price, categories: $categories, media: $media, requestStatus: $requestStatus, binaries: $binaries, exes: $exes)';
}


}

/// @nodoc
abstract mixin class _$GameRequestModelCopyWith<$Res> implements $GameRequestModelCopyWith<$Res> {
  factory _$GameRequestModelCopyWith(_GameRequestModel value, $Res Function(_GameRequestModel) _then) = __$GameRequestModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'publisherid') String publisherId,@JsonKey(name: 'gamename') String gameName,@JsonKey(name: 'briefdescription') String briefDescription, String description, String requirements,@JsonKey(name: 'headerimage') String headerImage, double price, List<CategoryModel> categories, List<String> media,@JsonKey(name: 'status') String requestStatus, List<String> binaries, List<String> exes
});




}
/// @nodoc
class __$GameRequestModelCopyWithImpl<$Res>
    implements _$GameRequestModelCopyWith<$Res> {
  __$GameRequestModelCopyWithImpl(this._self, this._then);

  final _GameRequestModel _self;
  final $Res Function(_GameRequestModel) _then;

/// Create a copy of GameRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? publisherId = null,Object? gameName = null,Object? briefDescription = null,Object? description = null,Object? requirements = null,Object? headerImage = null,Object? price = null,Object? categories = null,Object? media = null,Object? requestStatus = null,Object? binaries = null,Object? exes = null,}) {
  return _then(_GameRequestModel(
publisherId: null == publisherId ? _self.publisherId : publisherId // ignore: cast_nullable_to_non_nullable
as String,gameName: null == gameName ? _self.gameName : gameName // ignore: cast_nullable_to_non_nullable
as String,briefDescription: null == briefDescription ? _self.briefDescription : briefDescription // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,requirements: null == requirements ? _self.requirements : requirements // ignore: cast_nullable_to_non_nullable
as String,headerImage: null == headerImage ? _self.headerImage : headerImage // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryModel>,media: null == media ? _self._media : media // ignore: cast_nullable_to_non_nullable
as List<String>,requestStatus: null == requestStatus ? _self.requestStatus : requestStatus // ignore: cast_nullable_to_non_nullable
as String,binaries: null == binaries ? _self._binaries : binaries // ignore: cast_nullable_to_non_nullable
as List<String>,exes: null == exes ? _self._exes : exes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
