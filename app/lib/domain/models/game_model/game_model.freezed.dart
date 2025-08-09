// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameModel implements DiagnosticableTreeMixin {

 String get gameId; String get publisherId; String get name; String get description; double get price; int get recommended; DateTime get releaseDate; List<CategoryModel> get categories; List<String>? get media; String get headerImage;// Request related fields
 String? get requestStatus;// e.g., 'pending', 'approved', 'rejected'
// Sale related fields
 bool? get isSale; double? get discountPercent; DateTime? get saleStartDate; DateTime? get saleEndDate;// Download related fields
 String? get path; List<String>? get binaries; List<String>? get exes;// Field for User only
 bool get isOwned; bool get isInstalled; bool get favorite; double? get playtimeHours;
/// Create a copy of GameModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameModelCopyWith<GameModel> get copyWith => _$GameModelCopyWithImpl<GameModel>(this as GameModel, _$identity);

  /// Serializes this GameModel to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'GameModel'))
    ..add(DiagnosticsProperty('gameId', gameId))..add(DiagnosticsProperty('publisherId', publisherId))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('description', description))..add(DiagnosticsProperty('price', price))..add(DiagnosticsProperty('recommended', recommended))..add(DiagnosticsProperty('releaseDate', releaseDate))..add(DiagnosticsProperty('categories', categories))..add(DiagnosticsProperty('media', media))..add(DiagnosticsProperty('headerImage', headerImage))..add(DiagnosticsProperty('requestStatus', requestStatus))..add(DiagnosticsProperty('isSale', isSale))..add(DiagnosticsProperty('discountPercent', discountPercent))..add(DiagnosticsProperty('saleStartDate', saleStartDate))..add(DiagnosticsProperty('saleEndDate', saleEndDate))..add(DiagnosticsProperty('path', path))..add(DiagnosticsProperty('binaries', binaries))..add(DiagnosticsProperty('exes', exes))..add(DiagnosticsProperty('isOwned', isOwned))..add(DiagnosticsProperty('isInstalled', isInstalled))..add(DiagnosticsProperty('favorite', favorite))..add(DiagnosticsProperty('playtimeHours', playtimeHours));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameModel&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.publisherId, publisherId) || other.publisherId == publisherId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.recommended, recommended) || other.recommended == recommended)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.media, media)&&(identical(other.headerImage, headerImage) || other.headerImage == headerImage)&&(identical(other.requestStatus, requestStatus) || other.requestStatus == requestStatus)&&(identical(other.isSale, isSale) || other.isSale == isSale)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&(identical(other.saleStartDate, saleStartDate) || other.saleStartDate == saleStartDate)&&(identical(other.saleEndDate, saleEndDate) || other.saleEndDate == saleEndDate)&&(identical(other.path, path) || other.path == path)&&const DeepCollectionEquality().equals(other.binaries, binaries)&&const DeepCollectionEquality().equals(other.exes, exes)&&(identical(other.isOwned, isOwned) || other.isOwned == isOwned)&&(identical(other.isInstalled, isInstalled) || other.isInstalled == isInstalled)&&(identical(other.favorite, favorite) || other.favorite == favorite)&&(identical(other.playtimeHours, playtimeHours) || other.playtimeHours == playtimeHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,gameId,publisherId,name,description,price,recommended,releaseDate,const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(media),headerImage,requestStatus,isSale,discountPercent,saleStartDate,saleEndDate,path,const DeepCollectionEquality().hash(binaries),const DeepCollectionEquality().hash(exes),isOwned,isInstalled,favorite,playtimeHours]);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'GameModel(gameId: $gameId, publisherId: $publisherId, name: $name, description: $description, price: $price, recommended: $recommended, releaseDate: $releaseDate, categories: $categories, media: $media, headerImage: $headerImage, requestStatus: $requestStatus, isSale: $isSale, discountPercent: $discountPercent, saleStartDate: $saleStartDate, saleEndDate: $saleEndDate, path: $path, binaries: $binaries, exes: $exes, isOwned: $isOwned, isInstalled: $isInstalled, favorite: $favorite, playtimeHours: $playtimeHours)';
}


}

/// @nodoc
abstract mixin class $GameModelCopyWith<$Res>  {
  factory $GameModelCopyWith(GameModel value, $Res Function(GameModel) _then) = _$GameModelCopyWithImpl;
@useResult
$Res call({
 String gameId, String publisherId, String name, String description, double price, int recommended, DateTime releaseDate, List<CategoryModel> categories, List<String>? media, String headerImage, String? requestStatus, bool? isSale, double? discountPercent, DateTime? saleStartDate, DateTime? saleEndDate, String? path, List<String>? binaries, List<String>? exes, bool isOwned, bool isInstalled, bool favorite, double? playtimeHours
});




}
/// @nodoc
class _$GameModelCopyWithImpl<$Res>
    implements $GameModelCopyWith<$Res> {
  _$GameModelCopyWithImpl(this._self, this._then);

  final GameModel _self;
  final $Res Function(GameModel) _then;

/// Create a copy of GameModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gameId = null,Object? publisherId = null,Object? name = null,Object? description = null,Object? price = null,Object? recommended = null,Object? releaseDate = null,Object? categories = null,Object? media = freezed,Object? headerImage = null,Object? requestStatus = freezed,Object? isSale = freezed,Object? discountPercent = freezed,Object? saleStartDate = freezed,Object? saleEndDate = freezed,Object? path = freezed,Object? binaries = freezed,Object? exes = freezed,Object? isOwned = null,Object? isInstalled = null,Object? favorite = null,Object? playtimeHours = freezed,}) {
  return _then(_self.copyWith(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,publisherId: null == publisherId ? _self.publisherId : publisherId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,recommended: null == recommended ? _self.recommended : recommended // ignore: cast_nullable_to_non_nullable
as int,releaseDate: null == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryModel>,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as List<String>?,headerImage: null == headerImage ? _self.headerImage : headerImage // ignore: cast_nullable_to_non_nullable
as String,requestStatus: freezed == requestStatus ? _self.requestStatus : requestStatus // ignore: cast_nullable_to_non_nullable
as String?,isSale: freezed == isSale ? _self.isSale : isSale // ignore: cast_nullable_to_non_nullable
as bool?,discountPercent: freezed == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as double?,saleStartDate: freezed == saleStartDate ? _self.saleStartDate : saleStartDate // ignore: cast_nullable_to_non_nullable
as DateTime?,saleEndDate: freezed == saleEndDate ? _self.saleEndDate : saleEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,binaries: freezed == binaries ? _self.binaries : binaries // ignore: cast_nullable_to_non_nullable
as List<String>?,exes: freezed == exes ? _self.exes : exes // ignore: cast_nullable_to_non_nullable
as List<String>?,isOwned: null == isOwned ? _self.isOwned : isOwned // ignore: cast_nullable_to_non_nullable
as bool,isInstalled: null == isInstalled ? _self.isInstalled : isInstalled // ignore: cast_nullable_to_non_nullable
as bool,favorite: null == favorite ? _self.favorite : favorite // ignore: cast_nullable_to_non_nullable
as bool,playtimeHours: freezed == playtimeHours ? _self.playtimeHours : playtimeHours // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [GameModel].
extension GameModelPatterns on GameModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameModel value)  $default,){
final _that = this;
switch (_that) {
case _GameModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameModel value)?  $default,){
final _that = this;
switch (_that) {
case _GameModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String gameId,  String publisherId,  String name,  String description,  double price,  int recommended,  DateTime releaseDate,  List<CategoryModel> categories,  List<String>? media,  String headerImage,  String? requestStatus,  bool? isSale,  double? discountPercent,  DateTime? saleStartDate,  DateTime? saleEndDate,  String? path,  List<String>? binaries,  List<String>? exes,  bool isOwned,  bool isInstalled,  bool favorite,  double? playtimeHours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameModel() when $default != null:
return $default(_that.gameId,_that.publisherId,_that.name,_that.description,_that.price,_that.recommended,_that.releaseDate,_that.categories,_that.media,_that.headerImage,_that.requestStatus,_that.isSale,_that.discountPercent,_that.saleStartDate,_that.saleEndDate,_that.path,_that.binaries,_that.exes,_that.isOwned,_that.isInstalled,_that.favorite,_that.playtimeHours);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String gameId,  String publisherId,  String name,  String description,  double price,  int recommended,  DateTime releaseDate,  List<CategoryModel> categories,  List<String>? media,  String headerImage,  String? requestStatus,  bool? isSale,  double? discountPercent,  DateTime? saleStartDate,  DateTime? saleEndDate,  String? path,  List<String>? binaries,  List<String>? exes,  bool isOwned,  bool isInstalled,  bool favorite,  double? playtimeHours)  $default,) {final _that = this;
switch (_that) {
case _GameModel():
return $default(_that.gameId,_that.publisherId,_that.name,_that.description,_that.price,_that.recommended,_that.releaseDate,_that.categories,_that.media,_that.headerImage,_that.requestStatus,_that.isSale,_that.discountPercent,_that.saleStartDate,_that.saleEndDate,_that.path,_that.binaries,_that.exes,_that.isOwned,_that.isInstalled,_that.favorite,_that.playtimeHours);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String gameId,  String publisherId,  String name,  String description,  double price,  int recommended,  DateTime releaseDate,  List<CategoryModel> categories,  List<String>? media,  String headerImage,  String? requestStatus,  bool? isSale,  double? discountPercent,  DateTime? saleStartDate,  DateTime? saleEndDate,  String? path,  List<String>? binaries,  List<String>? exes,  bool isOwned,  bool isInstalled,  bool favorite,  double? playtimeHours)?  $default,) {final _that = this;
switch (_that) {
case _GameModel() when $default != null:
return $default(_that.gameId,_that.publisherId,_that.name,_that.description,_that.price,_that.recommended,_that.releaseDate,_that.categories,_that.media,_that.headerImage,_that.requestStatus,_that.isSale,_that.discountPercent,_that.saleStartDate,_that.saleEndDate,_that.path,_that.binaries,_that.exes,_that.isOwned,_that.isInstalled,_that.favorite,_that.playtimeHours);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameModel with DiagnosticableTreeMixin implements GameModel {
  const _GameModel({required this.gameId, required this.publisherId, required this.name, required this.description, required this.price, required this.recommended, required this.releaseDate, required final  List<CategoryModel> categories, required final  List<String>? media, required this.headerImage, this.requestStatus, this.isSale, this.discountPercent, this.saleStartDate, this.saleEndDate, this.path, final  List<String>? binaries, final  List<String>? exes, this.isOwned = false, this.isInstalled = false, this.favorite = false, this.playtimeHours}): _categories = categories,_media = media,_binaries = binaries,_exes = exes;
  factory _GameModel.fromJson(Map<String, dynamic> json) => _$GameModelFromJson(json);

@override final  String gameId;
@override final  String publisherId;
@override final  String name;
@override final  String description;
@override final  double price;
@override final  int recommended;
@override final  DateTime releaseDate;
 final  List<CategoryModel> _categories;
@override List<CategoryModel> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<String>? _media;
@override List<String>? get media {
  final value = _media;
  if (value == null) return null;
  if (_media is EqualUnmodifiableListView) return _media;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String headerImage;
// Request related fields
@override final  String? requestStatus;
// e.g., 'pending', 'approved', 'rejected'
// Sale related fields
@override final  bool? isSale;
@override final  double? discountPercent;
@override final  DateTime? saleStartDate;
@override final  DateTime? saleEndDate;
// Download related fields
@override final  String? path;
 final  List<String>? _binaries;
@override List<String>? get binaries {
  final value = _binaries;
  if (value == null) return null;
  if (_binaries is EqualUnmodifiableListView) return _binaries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _exes;
@override List<String>? get exes {
  final value = _exes;
  if (value == null) return null;
  if (_exes is EqualUnmodifiableListView) return _exes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// Field for User only
@override@JsonKey() final  bool isOwned;
@override@JsonKey() final  bool isInstalled;
@override@JsonKey() final  bool favorite;
@override final  double? playtimeHours;

/// Create a copy of GameModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameModelCopyWith<_GameModel> get copyWith => __$GameModelCopyWithImpl<_GameModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameModelToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'GameModel'))
    ..add(DiagnosticsProperty('gameId', gameId))..add(DiagnosticsProperty('publisherId', publisherId))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('description', description))..add(DiagnosticsProperty('price', price))..add(DiagnosticsProperty('recommended', recommended))..add(DiagnosticsProperty('releaseDate', releaseDate))..add(DiagnosticsProperty('categories', categories))..add(DiagnosticsProperty('media', media))..add(DiagnosticsProperty('headerImage', headerImage))..add(DiagnosticsProperty('requestStatus', requestStatus))..add(DiagnosticsProperty('isSale', isSale))..add(DiagnosticsProperty('discountPercent', discountPercent))..add(DiagnosticsProperty('saleStartDate', saleStartDate))..add(DiagnosticsProperty('saleEndDate', saleEndDate))..add(DiagnosticsProperty('path', path))..add(DiagnosticsProperty('binaries', binaries))..add(DiagnosticsProperty('exes', exes))..add(DiagnosticsProperty('isOwned', isOwned))..add(DiagnosticsProperty('isInstalled', isInstalled))..add(DiagnosticsProperty('favorite', favorite))..add(DiagnosticsProperty('playtimeHours', playtimeHours));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameModel&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.publisherId, publisherId) || other.publisherId == publisherId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.recommended, recommended) || other.recommended == recommended)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._media, _media)&&(identical(other.headerImage, headerImage) || other.headerImage == headerImage)&&(identical(other.requestStatus, requestStatus) || other.requestStatus == requestStatus)&&(identical(other.isSale, isSale) || other.isSale == isSale)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&(identical(other.saleStartDate, saleStartDate) || other.saleStartDate == saleStartDate)&&(identical(other.saleEndDate, saleEndDate) || other.saleEndDate == saleEndDate)&&(identical(other.path, path) || other.path == path)&&const DeepCollectionEquality().equals(other._binaries, _binaries)&&const DeepCollectionEquality().equals(other._exes, _exes)&&(identical(other.isOwned, isOwned) || other.isOwned == isOwned)&&(identical(other.isInstalled, isInstalled) || other.isInstalled == isInstalled)&&(identical(other.favorite, favorite) || other.favorite == favorite)&&(identical(other.playtimeHours, playtimeHours) || other.playtimeHours == playtimeHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,gameId,publisherId,name,description,price,recommended,releaseDate,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_media),headerImage,requestStatus,isSale,discountPercent,saleStartDate,saleEndDate,path,const DeepCollectionEquality().hash(_binaries),const DeepCollectionEquality().hash(_exes),isOwned,isInstalled,favorite,playtimeHours]);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'GameModel(gameId: $gameId, publisherId: $publisherId, name: $name, description: $description, price: $price, recommended: $recommended, releaseDate: $releaseDate, categories: $categories, media: $media, headerImage: $headerImage, requestStatus: $requestStatus, isSale: $isSale, discountPercent: $discountPercent, saleStartDate: $saleStartDate, saleEndDate: $saleEndDate, path: $path, binaries: $binaries, exes: $exes, isOwned: $isOwned, isInstalled: $isInstalled, favorite: $favorite, playtimeHours: $playtimeHours)';
}


}

/// @nodoc
abstract mixin class _$GameModelCopyWith<$Res> implements $GameModelCopyWith<$Res> {
  factory _$GameModelCopyWith(_GameModel value, $Res Function(_GameModel) _then) = __$GameModelCopyWithImpl;
@override @useResult
$Res call({
 String gameId, String publisherId, String name, String description, double price, int recommended, DateTime releaseDate, List<CategoryModel> categories, List<String>? media, String headerImage, String? requestStatus, bool? isSale, double? discountPercent, DateTime? saleStartDate, DateTime? saleEndDate, String? path, List<String>? binaries, List<String>? exes, bool isOwned, bool isInstalled, bool favorite, double? playtimeHours
});




}
/// @nodoc
class __$GameModelCopyWithImpl<$Res>
    implements _$GameModelCopyWith<$Res> {
  __$GameModelCopyWithImpl(this._self, this._then);

  final _GameModel _self;
  final $Res Function(_GameModel) _then;

/// Create a copy of GameModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gameId = null,Object? publisherId = null,Object? name = null,Object? description = null,Object? price = null,Object? recommended = null,Object? releaseDate = null,Object? categories = null,Object? media = freezed,Object? headerImage = null,Object? requestStatus = freezed,Object? isSale = freezed,Object? discountPercent = freezed,Object? saleStartDate = freezed,Object? saleEndDate = freezed,Object? path = freezed,Object? binaries = freezed,Object? exes = freezed,Object? isOwned = null,Object? isInstalled = null,Object? favorite = null,Object? playtimeHours = freezed,}) {
  return _then(_GameModel(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,publisherId: null == publisherId ? _self.publisherId : publisherId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,recommended: null == recommended ? _self.recommended : recommended // ignore: cast_nullable_to_non_nullable
as int,releaseDate: null == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryModel>,media: freezed == media ? _self._media : media // ignore: cast_nullable_to_non_nullable
as List<String>?,headerImage: null == headerImage ? _self.headerImage : headerImage // ignore: cast_nullable_to_non_nullable
as String,requestStatus: freezed == requestStatus ? _self.requestStatus : requestStatus // ignore: cast_nullable_to_non_nullable
as String?,isSale: freezed == isSale ? _self.isSale : isSale // ignore: cast_nullable_to_non_nullable
as bool?,discountPercent: freezed == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as double?,saleStartDate: freezed == saleStartDate ? _self.saleStartDate : saleStartDate // ignore: cast_nullable_to_non_nullable
as DateTime?,saleEndDate: freezed == saleEndDate ? _self.saleEndDate : saleEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,binaries: freezed == binaries ? _self._binaries : binaries // ignore: cast_nullable_to_non_nullable
as List<String>?,exes: freezed == exes ? _self._exes : exes // ignore: cast_nullable_to_non_nullable
as List<String>?,isOwned: null == isOwned ? _self.isOwned : isOwned // ignore: cast_nullable_to_non_nullable
as bool,isInstalled: null == isInstalled ? _self.isInstalled : isInstalled // ignore: cast_nullable_to_non_nullable
as bool,favorite: null == favorite ? _self.favorite : favorite // ignore: cast_nullable_to_non_nullable
as bool,playtimeHours: freezed == playtimeHours ? _self.playtimeHours : playtimeHours // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
