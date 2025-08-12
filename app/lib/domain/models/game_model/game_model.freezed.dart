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

@JsonKey(name: 'gameid') String get gameId;@JsonKey(name: 'publisherid') String get publisherId; String get name; String get description;@JsonKey(name: 'briefdescription') String get briefDescription; String get requirement; double get price;@JsonKey(name: 'recommend') int get recommended;@JsonKey(name: 'releasedate') DateTime get releaseDate; List<CategoryModel> get categories; List<String>? get media;@JsonKey(name: 'headerimage') String get headerImage;// Request related fields
@JsonKey(name: 'requeststatus') String? get requestStatus;// e.g., 'pending', 'approved', 'rejected'
// Sale related fields
@JsonKey(name: 'issale') bool? get isSale;@JsonKey(name: 'discountpercent') double? get discountPercent;@JsonKey(name: 'salestartdate') DateTime? get saleStartDate;@JsonKey(name: 'saleenddate') DateTime? get saleEndDate;// Download related fields
 String? get path; List<String>? get binaries; List<String>? get exes;// Field for User only
@JsonKey(name: 'isowned') bool get isOwned;@JsonKey(name: 'isinstalled') bool get isInstalled; bool get favorite;@JsonKey(name: 'playtimehours') double? get playtimeHours;
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
    ..add(DiagnosticsProperty('gameId', gameId))..add(DiagnosticsProperty('publisherId', publisherId))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('description', description))..add(DiagnosticsProperty('briefDescription', briefDescription))..add(DiagnosticsProperty('requirement', requirement))..add(DiagnosticsProperty('price', price))..add(DiagnosticsProperty('recommended', recommended))..add(DiagnosticsProperty('releaseDate', releaseDate))..add(DiagnosticsProperty('categories', categories))..add(DiagnosticsProperty('media', media))..add(DiagnosticsProperty('headerImage', headerImage))..add(DiagnosticsProperty('requestStatus', requestStatus))..add(DiagnosticsProperty('isSale', isSale))..add(DiagnosticsProperty('discountPercent', discountPercent))..add(DiagnosticsProperty('saleStartDate', saleStartDate))..add(DiagnosticsProperty('saleEndDate', saleEndDate))..add(DiagnosticsProperty('path', path))..add(DiagnosticsProperty('binaries', binaries))..add(DiagnosticsProperty('exes', exes))..add(DiagnosticsProperty('isOwned', isOwned))..add(DiagnosticsProperty('isInstalled', isInstalled))..add(DiagnosticsProperty('favorite', favorite))..add(DiagnosticsProperty('playtimeHours', playtimeHours));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameModel&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.publisherId, publisherId) || other.publisherId == publisherId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.briefDescription, briefDescription) || other.briefDescription == briefDescription)&&(identical(other.requirement, requirement) || other.requirement == requirement)&&(identical(other.price, price) || other.price == price)&&(identical(other.recommended, recommended) || other.recommended == recommended)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.media, media)&&(identical(other.headerImage, headerImage) || other.headerImage == headerImage)&&(identical(other.requestStatus, requestStatus) || other.requestStatus == requestStatus)&&(identical(other.isSale, isSale) || other.isSale == isSale)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&(identical(other.saleStartDate, saleStartDate) || other.saleStartDate == saleStartDate)&&(identical(other.saleEndDate, saleEndDate) || other.saleEndDate == saleEndDate)&&(identical(other.path, path) || other.path == path)&&const DeepCollectionEquality().equals(other.binaries, binaries)&&const DeepCollectionEquality().equals(other.exes, exes)&&(identical(other.isOwned, isOwned) || other.isOwned == isOwned)&&(identical(other.isInstalled, isInstalled) || other.isInstalled == isInstalled)&&(identical(other.favorite, favorite) || other.favorite == favorite)&&(identical(other.playtimeHours, playtimeHours) || other.playtimeHours == playtimeHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,gameId,publisherId,name,description,briefDescription,requirement,price,recommended,releaseDate,const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(media),headerImage,requestStatus,isSale,discountPercent,saleStartDate,saleEndDate,path,const DeepCollectionEquality().hash(binaries),const DeepCollectionEquality().hash(exes),isOwned,isInstalled,favorite,playtimeHours]);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'GameModel(gameId: $gameId, publisherId: $publisherId, name: $name, description: $description, briefDescription: $briefDescription, requirement: $requirement, price: $price, recommended: $recommended, releaseDate: $releaseDate, categories: $categories, media: $media, headerImage: $headerImage, requestStatus: $requestStatus, isSale: $isSale, discountPercent: $discountPercent, saleStartDate: $saleStartDate, saleEndDate: $saleEndDate, path: $path, binaries: $binaries, exes: $exes, isOwned: $isOwned, isInstalled: $isInstalled, favorite: $favorite, playtimeHours: $playtimeHours)';
}


}

/// @nodoc
abstract mixin class $GameModelCopyWith<$Res>  {
  factory $GameModelCopyWith(GameModel value, $Res Function(GameModel) _then) = _$GameModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'gameid') String gameId,@JsonKey(name: 'publisherid') String publisherId, String name, String description,@JsonKey(name: 'briefdescription') String briefDescription, String requirement, double price,@JsonKey(name: 'recommend') int recommended,@JsonKey(name: 'releasedate') DateTime releaseDate, List<CategoryModel> categories, List<String>? media,@JsonKey(name: 'headerimage') String headerImage,@JsonKey(name: 'requeststatus') String? requestStatus,@JsonKey(name: 'issale') bool? isSale,@JsonKey(name: 'discountpercent') double? discountPercent,@JsonKey(name: 'salestartdate') DateTime? saleStartDate,@JsonKey(name: 'saleenddate') DateTime? saleEndDate, String? path, List<String>? binaries, List<String>? exes,@JsonKey(name: 'isowned') bool isOwned,@JsonKey(name: 'isinstalled') bool isInstalled, bool favorite,@JsonKey(name: 'playtimehours') double? playtimeHours
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
@pragma('vm:prefer-inline') @override $Res call({Object? gameId = null,Object? publisherId = null,Object? name = null,Object? description = null,Object? briefDescription = null,Object? requirement = null,Object? price = null,Object? recommended = null,Object? releaseDate = null,Object? categories = null,Object? media = freezed,Object? headerImage = null,Object? requestStatus = freezed,Object? isSale = freezed,Object? discountPercent = freezed,Object? saleStartDate = freezed,Object? saleEndDate = freezed,Object? path = freezed,Object? binaries = freezed,Object? exes = freezed,Object? isOwned = null,Object? isInstalled = null,Object? favorite = null,Object? playtimeHours = freezed,}) {
  return _then(_self.copyWith(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,publisherId: null == publisherId ? _self.publisherId : publisherId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,briefDescription: null == briefDescription ? _self.briefDescription : briefDescription // ignore: cast_nullable_to_non_nullable
as String,requirement: null == requirement ? _self.requirement : requirement // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'gameid')  String gameId, @JsonKey(name: 'publisherid')  String publisherId,  String name,  String description, @JsonKey(name: 'briefdescription')  String briefDescription,  String requirement,  double price, @JsonKey(name: 'recommend')  int recommended, @JsonKey(name: 'releasedate')  DateTime releaseDate,  List<CategoryModel> categories,  List<String>? media, @JsonKey(name: 'headerimage')  String headerImage, @JsonKey(name: 'requeststatus')  String? requestStatus, @JsonKey(name: 'issale')  bool? isSale, @JsonKey(name: 'discountpercent')  double? discountPercent, @JsonKey(name: 'salestartdate')  DateTime? saleStartDate, @JsonKey(name: 'saleenddate')  DateTime? saleEndDate,  String? path,  List<String>? binaries,  List<String>? exes, @JsonKey(name: 'isowned')  bool isOwned, @JsonKey(name: 'isinstalled')  bool isInstalled,  bool favorite, @JsonKey(name: 'playtimehours')  double? playtimeHours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameModel() when $default != null:
return $default(_that.gameId,_that.publisherId,_that.name,_that.description,_that.briefDescription,_that.requirement,_that.price,_that.recommended,_that.releaseDate,_that.categories,_that.media,_that.headerImage,_that.requestStatus,_that.isSale,_that.discountPercent,_that.saleStartDate,_that.saleEndDate,_that.path,_that.binaries,_that.exes,_that.isOwned,_that.isInstalled,_that.favorite,_that.playtimeHours);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'gameid')  String gameId, @JsonKey(name: 'publisherid')  String publisherId,  String name,  String description, @JsonKey(name: 'briefdescription')  String briefDescription,  String requirement,  double price, @JsonKey(name: 'recommend')  int recommended, @JsonKey(name: 'releasedate')  DateTime releaseDate,  List<CategoryModel> categories,  List<String>? media, @JsonKey(name: 'headerimage')  String headerImage, @JsonKey(name: 'requeststatus')  String? requestStatus, @JsonKey(name: 'issale')  bool? isSale, @JsonKey(name: 'discountpercent')  double? discountPercent, @JsonKey(name: 'salestartdate')  DateTime? saleStartDate, @JsonKey(name: 'saleenddate')  DateTime? saleEndDate,  String? path,  List<String>? binaries,  List<String>? exes, @JsonKey(name: 'isowned')  bool isOwned, @JsonKey(name: 'isinstalled')  bool isInstalled,  bool favorite, @JsonKey(name: 'playtimehours')  double? playtimeHours)  $default,) {final _that = this;
switch (_that) {
case _GameModel():
return $default(_that.gameId,_that.publisherId,_that.name,_that.description,_that.briefDescription,_that.requirement,_that.price,_that.recommended,_that.releaseDate,_that.categories,_that.media,_that.headerImage,_that.requestStatus,_that.isSale,_that.discountPercent,_that.saleStartDate,_that.saleEndDate,_that.path,_that.binaries,_that.exes,_that.isOwned,_that.isInstalled,_that.favorite,_that.playtimeHours);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'gameid')  String gameId, @JsonKey(name: 'publisherid')  String publisherId,  String name,  String description, @JsonKey(name: 'briefdescription')  String briefDescription,  String requirement,  double price, @JsonKey(name: 'recommend')  int recommended, @JsonKey(name: 'releasedate')  DateTime releaseDate,  List<CategoryModel> categories,  List<String>? media, @JsonKey(name: 'headerimage')  String headerImage, @JsonKey(name: 'requeststatus')  String? requestStatus, @JsonKey(name: 'issale')  bool? isSale, @JsonKey(name: 'discountpercent')  double? discountPercent, @JsonKey(name: 'salestartdate')  DateTime? saleStartDate, @JsonKey(name: 'saleenddate')  DateTime? saleEndDate,  String? path,  List<String>? binaries,  List<String>? exes, @JsonKey(name: 'isowned')  bool isOwned, @JsonKey(name: 'isinstalled')  bool isInstalled,  bool favorite, @JsonKey(name: 'playtimehours')  double? playtimeHours)?  $default,) {final _that = this;
switch (_that) {
case _GameModel() when $default != null:
return $default(_that.gameId,_that.publisherId,_that.name,_that.description,_that.briefDescription,_that.requirement,_that.price,_that.recommended,_that.releaseDate,_that.categories,_that.media,_that.headerImage,_that.requestStatus,_that.isSale,_that.discountPercent,_that.saleStartDate,_that.saleEndDate,_that.path,_that.binaries,_that.exes,_that.isOwned,_that.isInstalled,_that.favorite,_that.playtimeHours);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameModel with DiagnosticableTreeMixin implements GameModel {
  const _GameModel({@JsonKey(name: 'gameid') required this.gameId, @JsonKey(name: 'publisherid') required this.publisherId, required this.name, required this.description, @JsonKey(name: 'briefdescription') required this.briefDescription, required this.requirement, required this.price, @JsonKey(name: 'recommend') required this.recommended, @JsonKey(name: 'releasedate') required this.releaseDate, required final  List<CategoryModel> categories, required final  List<String>? media, @JsonKey(name: 'headerimage') required this.headerImage, @JsonKey(name: 'requeststatus') this.requestStatus, @JsonKey(name: 'issale') this.isSale, @JsonKey(name: 'discountpercent') this.discountPercent, @JsonKey(name: 'salestartdate') this.saleStartDate, @JsonKey(name: 'saleenddate') this.saleEndDate, this.path, final  List<String>? binaries, final  List<String>? exes, @JsonKey(name: 'isowned') this.isOwned = false, @JsonKey(name: 'isinstalled') this.isInstalled = false, this.favorite = false, @JsonKey(name: 'playtimehours') this.playtimeHours}): _categories = categories,_media = media,_binaries = binaries,_exes = exes;
  factory _GameModel.fromJson(Map<String, dynamic> json) => _$GameModelFromJson(json);

@override@JsonKey(name: 'gameid') final  String gameId;
@override@JsonKey(name: 'publisherid') final  String publisherId;
@override final  String name;
@override final  String description;
@override@JsonKey(name: 'briefdescription') final  String briefDescription;
@override final  String requirement;
@override final  double price;
@override@JsonKey(name: 'recommend') final  int recommended;
@override@JsonKey(name: 'releasedate') final  DateTime releaseDate;
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

@override@JsonKey(name: 'headerimage') final  String headerImage;
// Request related fields
@override@JsonKey(name: 'requeststatus') final  String? requestStatus;
// e.g., 'pending', 'approved', 'rejected'
// Sale related fields
@override@JsonKey(name: 'issale') final  bool? isSale;
@override@JsonKey(name: 'discountpercent') final  double? discountPercent;
@override@JsonKey(name: 'salestartdate') final  DateTime? saleStartDate;
@override@JsonKey(name: 'saleenddate') final  DateTime? saleEndDate;
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
@override@JsonKey(name: 'isowned') final  bool isOwned;
@override@JsonKey(name: 'isinstalled') final  bool isInstalled;
@override@JsonKey() final  bool favorite;
@override@JsonKey(name: 'playtimehours') final  double? playtimeHours;

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
    ..add(DiagnosticsProperty('gameId', gameId))..add(DiagnosticsProperty('publisherId', publisherId))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('description', description))..add(DiagnosticsProperty('briefDescription', briefDescription))..add(DiagnosticsProperty('requirement', requirement))..add(DiagnosticsProperty('price', price))..add(DiagnosticsProperty('recommended', recommended))..add(DiagnosticsProperty('releaseDate', releaseDate))..add(DiagnosticsProperty('categories', categories))..add(DiagnosticsProperty('media', media))..add(DiagnosticsProperty('headerImage', headerImage))..add(DiagnosticsProperty('requestStatus', requestStatus))..add(DiagnosticsProperty('isSale', isSale))..add(DiagnosticsProperty('discountPercent', discountPercent))..add(DiagnosticsProperty('saleStartDate', saleStartDate))..add(DiagnosticsProperty('saleEndDate', saleEndDate))..add(DiagnosticsProperty('path', path))..add(DiagnosticsProperty('binaries', binaries))..add(DiagnosticsProperty('exes', exes))..add(DiagnosticsProperty('isOwned', isOwned))..add(DiagnosticsProperty('isInstalled', isInstalled))..add(DiagnosticsProperty('favorite', favorite))..add(DiagnosticsProperty('playtimeHours', playtimeHours));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameModel&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.publisherId, publisherId) || other.publisherId == publisherId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.briefDescription, briefDescription) || other.briefDescription == briefDescription)&&(identical(other.requirement, requirement) || other.requirement == requirement)&&(identical(other.price, price) || other.price == price)&&(identical(other.recommended, recommended) || other.recommended == recommended)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._media, _media)&&(identical(other.headerImage, headerImage) || other.headerImage == headerImage)&&(identical(other.requestStatus, requestStatus) || other.requestStatus == requestStatus)&&(identical(other.isSale, isSale) || other.isSale == isSale)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&(identical(other.saleStartDate, saleStartDate) || other.saleStartDate == saleStartDate)&&(identical(other.saleEndDate, saleEndDate) || other.saleEndDate == saleEndDate)&&(identical(other.path, path) || other.path == path)&&const DeepCollectionEquality().equals(other._binaries, _binaries)&&const DeepCollectionEquality().equals(other._exes, _exes)&&(identical(other.isOwned, isOwned) || other.isOwned == isOwned)&&(identical(other.isInstalled, isInstalled) || other.isInstalled == isInstalled)&&(identical(other.favorite, favorite) || other.favorite == favorite)&&(identical(other.playtimeHours, playtimeHours) || other.playtimeHours == playtimeHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,gameId,publisherId,name,description,briefDescription,requirement,price,recommended,releaseDate,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_media),headerImage,requestStatus,isSale,discountPercent,saleStartDate,saleEndDate,path,const DeepCollectionEquality().hash(_binaries),const DeepCollectionEquality().hash(_exes),isOwned,isInstalled,favorite,playtimeHours]);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'GameModel(gameId: $gameId, publisherId: $publisherId, name: $name, description: $description, briefDescription: $briefDescription, requirement: $requirement, price: $price, recommended: $recommended, releaseDate: $releaseDate, categories: $categories, media: $media, headerImage: $headerImage, requestStatus: $requestStatus, isSale: $isSale, discountPercent: $discountPercent, saleStartDate: $saleStartDate, saleEndDate: $saleEndDate, path: $path, binaries: $binaries, exes: $exes, isOwned: $isOwned, isInstalled: $isInstalled, favorite: $favorite, playtimeHours: $playtimeHours)';
}


}

/// @nodoc
abstract mixin class _$GameModelCopyWith<$Res> implements $GameModelCopyWith<$Res> {
  factory _$GameModelCopyWith(_GameModel value, $Res Function(_GameModel) _then) = __$GameModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'gameid') String gameId,@JsonKey(name: 'publisherid') String publisherId, String name, String description,@JsonKey(name: 'briefdescription') String briefDescription, String requirement, double price,@JsonKey(name: 'recommend') int recommended,@JsonKey(name: 'releasedate') DateTime releaseDate, List<CategoryModel> categories, List<String>? media,@JsonKey(name: 'headerimage') String headerImage,@JsonKey(name: 'requeststatus') String? requestStatus,@JsonKey(name: 'issale') bool? isSale,@JsonKey(name: 'discountpercent') double? discountPercent,@JsonKey(name: 'salestartdate') DateTime? saleStartDate,@JsonKey(name: 'saleenddate') DateTime? saleEndDate, String? path, List<String>? binaries, List<String>? exes,@JsonKey(name: 'isowned') bool isOwned,@JsonKey(name: 'isinstalled') bool isInstalled, bool favorite,@JsonKey(name: 'playtimehours') double? playtimeHours
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
@override @pragma('vm:prefer-inline') $Res call({Object? gameId = null,Object? publisherId = null,Object? name = null,Object? description = null,Object? briefDescription = null,Object? requirement = null,Object? price = null,Object? recommended = null,Object? releaseDate = null,Object? categories = null,Object? media = freezed,Object? headerImage = null,Object? requestStatus = freezed,Object? isSale = freezed,Object? discountPercent = freezed,Object? saleStartDate = freezed,Object? saleEndDate = freezed,Object? path = freezed,Object? binaries = freezed,Object? exes = freezed,Object? isOwned = null,Object? isInstalled = null,Object? favorite = null,Object? playtimeHours = freezed,}) {
  return _then(_GameModel(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,publisherId: null == publisherId ? _self.publisherId : publisherId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,briefDescription: null == briefDescription ? _self.briefDescription : briefDescription // ignore: cast_nullable_to_non_nullable
as String,requirement: null == requirement ? _self.requirement : requirement // ignore: cast_nullable_to_non_nullable
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
