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
mixin _$GameModel {

 String get gameId; String get publisherId; String get name; int get recommended; String get briefDescription; String get description; String get requirements; String get headerImage; double get price; List<String>? get screenshots; List<String> get categoriesId;// Sale related fields
 bool? get isSale; double? get discountPercent; DateTime? get saleStartDate; DateTime? get saleEndDate;// Field for User only
 bool get isOwned; bool get installed; bool get favorite; double? get playtimeHours;
/// Create a copy of GameModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameModelCopyWith<GameModel> get copyWith => _$GameModelCopyWithImpl<GameModel>(this as GameModel, _$identity);

  /// Serializes this GameModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameModel&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.publisherId, publisherId) || other.publisherId == publisherId)&&(identical(other.name, name) || other.name == name)&&(identical(other.recommended, recommended) || other.recommended == recommended)&&(identical(other.briefDescription, briefDescription) || other.briefDescription == briefDescription)&&(identical(other.description, description) || other.description == description)&&(identical(other.requirements, requirements) || other.requirements == requirements)&&(identical(other.headerImage, headerImage) || other.headerImage == headerImage)&&(identical(other.price, price) || other.price == price)&&const DeepCollectionEquality().equals(other.screenshots, screenshots)&&const DeepCollectionEquality().equals(other.categoriesId, categoriesId)&&(identical(other.isSale, isSale) || other.isSale == isSale)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&(identical(other.saleStartDate, saleStartDate) || other.saleStartDate == saleStartDate)&&(identical(other.saleEndDate, saleEndDate) || other.saleEndDate == saleEndDate)&&(identical(other.isOwned, isOwned) || other.isOwned == isOwned)&&(identical(other.installed, installed) || other.installed == installed)&&(identical(other.favorite, favorite) || other.favorite == favorite)&&(identical(other.playtimeHours, playtimeHours) || other.playtimeHours == playtimeHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,gameId,publisherId,name,recommended,briefDescription,description,requirements,headerImage,price,const DeepCollectionEquality().hash(screenshots),const DeepCollectionEquality().hash(categoriesId),isSale,discountPercent,saleStartDate,saleEndDate,isOwned,installed,favorite,playtimeHours]);

@override
String toString() {
  return 'GameModel(gameId: $gameId, publisherId: $publisherId, name: $name, recommended: $recommended, briefDescription: $briefDescription, description: $description, requirements: $requirements, headerImage: $headerImage, price: $price, screenshots: $screenshots, categoriesId: $categoriesId, isSale: $isSale, discountPercent: $discountPercent, saleStartDate: $saleStartDate, saleEndDate: $saleEndDate, isOwned: $isOwned, installed: $installed, favorite: $favorite, playtimeHours: $playtimeHours)';
}


}

/// @nodoc
abstract mixin class $GameModelCopyWith<$Res>  {
  factory $GameModelCopyWith(GameModel value, $Res Function(GameModel) _then) = _$GameModelCopyWithImpl;
@useResult
$Res call({
 String gameId, String publisherId, String name, int recommended, String briefDescription, String description, String requirements, String headerImage, double price, List<String>? screenshots, List<String> categoriesId, bool? isSale, double? discountPercent, DateTime? saleStartDate, DateTime? saleEndDate, bool isOwned, bool installed, bool favorite, double? playtimeHours
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
@pragma('vm:prefer-inline') @override $Res call({Object? gameId = null,Object? publisherId = null,Object? name = null,Object? recommended = null,Object? briefDescription = null,Object? description = null,Object? requirements = null,Object? headerImage = null,Object? price = null,Object? screenshots = freezed,Object? categoriesId = null,Object? isSale = freezed,Object? discountPercent = freezed,Object? saleStartDate = freezed,Object? saleEndDate = freezed,Object? isOwned = null,Object? installed = null,Object? favorite = null,Object? playtimeHours = freezed,}) {
  return _then(_self.copyWith(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,publisherId: null == publisherId ? _self.publisherId : publisherId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,recommended: null == recommended ? _self.recommended : recommended // ignore: cast_nullable_to_non_nullable
as int,briefDescription: null == briefDescription ? _self.briefDescription : briefDescription // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,requirements: null == requirements ? _self.requirements : requirements // ignore: cast_nullable_to_non_nullable
as String,headerImage: null == headerImage ? _self.headerImage : headerImage // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,screenshots: freezed == screenshots ? _self.screenshots : screenshots // ignore: cast_nullable_to_non_nullable
as List<String>?,categoriesId: null == categoriesId ? _self.categoriesId : categoriesId // ignore: cast_nullable_to_non_nullable
as List<String>,isSale: freezed == isSale ? _self.isSale : isSale // ignore: cast_nullable_to_non_nullable
as bool?,discountPercent: freezed == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as double?,saleStartDate: freezed == saleStartDate ? _self.saleStartDate : saleStartDate // ignore: cast_nullable_to_non_nullable
as DateTime?,saleEndDate: freezed == saleEndDate ? _self.saleEndDate : saleEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isOwned: null == isOwned ? _self.isOwned : isOwned // ignore: cast_nullable_to_non_nullable
as bool,installed: null == installed ? _self.installed : installed // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String gameId,  String publisherId,  String name,  int recommended,  String briefDescription,  String description,  String requirements,  String headerImage,  double price,  List<String>? screenshots,  List<String> categoriesId,  bool? isSale,  double? discountPercent,  DateTime? saleStartDate,  DateTime? saleEndDate,  bool isOwned,  bool installed,  bool favorite,  double? playtimeHours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameModel() when $default != null:
return $default(_that.gameId,_that.publisherId,_that.name,_that.recommended,_that.briefDescription,_that.description,_that.requirements,_that.headerImage,_that.price,_that.screenshots,_that.categoriesId,_that.isSale,_that.discountPercent,_that.saleStartDate,_that.saleEndDate,_that.isOwned,_that.installed,_that.favorite,_that.playtimeHours);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String gameId,  String publisherId,  String name,  int recommended,  String briefDescription,  String description,  String requirements,  String headerImage,  double price,  List<String>? screenshots,  List<String> categoriesId,  bool? isSale,  double? discountPercent,  DateTime? saleStartDate,  DateTime? saleEndDate,  bool isOwned,  bool installed,  bool favorite,  double? playtimeHours)  $default,) {final _that = this;
switch (_that) {
case _GameModel():
return $default(_that.gameId,_that.publisherId,_that.name,_that.recommended,_that.briefDescription,_that.description,_that.requirements,_that.headerImage,_that.price,_that.screenshots,_that.categoriesId,_that.isSale,_that.discountPercent,_that.saleStartDate,_that.saleEndDate,_that.isOwned,_that.installed,_that.favorite,_that.playtimeHours);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String gameId,  String publisherId,  String name,  int recommended,  String briefDescription,  String description,  String requirements,  String headerImage,  double price,  List<String>? screenshots,  List<String> categoriesId,  bool? isSale,  double? discountPercent,  DateTime? saleStartDate,  DateTime? saleEndDate,  bool isOwned,  bool installed,  bool favorite,  double? playtimeHours)?  $default,) {final _that = this;
switch (_that) {
case _GameModel() when $default != null:
return $default(_that.gameId,_that.publisherId,_that.name,_that.recommended,_that.briefDescription,_that.description,_that.requirements,_that.headerImage,_that.price,_that.screenshots,_that.categoriesId,_that.isSale,_that.discountPercent,_that.saleStartDate,_that.saleEndDate,_that.isOwned,_that.installed,_that.favorite,_that.playtimeHours);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameModel implements GameModel {
  const _GameModel({required this.gameId, required this.publisherId, required this.name, required this.recommended, required this.briefDescription, required this.description, required this.requirements, required this.headerImage, required this.price, final  List<String>? screenshots, required final  List<String> categoriesId, this.isSale, this.discountPercent, this.saleStartDate, this.saleEndDate, this.isOwned = false, this.installed = false, this.favorite = false, this.playtimeHours}): _screenshots = screenshots,_categoriesId = categoriesId;
  factory _GameModel.fromJson(Map<String, dynamic> json) => _$GameModelFromJson(json);

@override final  String gameId;
@override final  String publisherId;
@override final  String name;
@override final  int recommended;
@override final  String briefDescription;
@override final  String description;
@override final  String requirements;
@override final  String headerImage;
@override final  double price;
 final  List<String>? _screenshots;
@override List<String>? get screenshots {
  final value = _screenshots;
  if (value == null) return null;
  if (_screenshots is EqualUnmodifiableListView) return _screenshots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String> _categoriesId;
@override List<String> get categoriesId {
  if (_categoriesId is EqualUnmodifiableListView) return _categoriesId;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categoriesId);
}

// Sale related fields
@override final  bool? isSale;
@override final  double? discountPercent;
@override final  DateTime? saleStartDate;
@override final  DateTime? saleEndDate;
// Field for User only
@override@JsonKey() final  bool isOwned;
@override@JsonKey() final  bool installed;
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
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameModel&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.publisherId, publisherId) || other.publisherId == publisherId)&&(identical(other.name, name) || other.name == name)&&(identical(other.recommended, recommended) || other.recommended == recommended)&&(identical(other.briefDescription, briefDescription) || other.briefDescription == briefDescription)&&(identical(other.description, description) || other.description == description)&&(identical(other.requirements, requirements) || other.requirements == requirements)&&(identical(other.headerImage, headerImage) || other.headerImage == headerImage)&&(identical(other.price, price) || other.price == price)&&const DeepCollectionEquality().equals(other._screenshots, _screenshots)&&const DeepCollectionEquality().equals(other._categoriesId, _categoriesId)&&(identical(other.isSale, isSale) || other.isSale == isSale)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&(identical(other.saleStartDate, saleStartDate) || other.saleStartDate == saleStartDate)&&(identical(other.saleEndDate, saleEndDate) || other.saleEndDate == saleEndDate)&&(identical(other.isOwned, isOwned) || other.isOwned == isOwned)&&(identical(other.installed, installed) || other.installed == installed)&&(identical(other.favorite, favorite) || other.favorite == favorite)&&(identical(other.playtimeHours, playtimeHours) || other.playtimeHours == playtimeHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,gameId,publisherId,name,recommended,briefDescription,description,requirements,headerImage,price,const DeepCollectionEquality().hash(_screenshots),const DeepCollectionEquality().hash(_categoriesId),isSale,discountPercent,saleStartDate,saleEndDate,isOwned,installed,favorite,playtimeHours]);

@override
String toString() {
  return 'GameModel(gameId: $gameId, publisherId: $publisherId, name: $name, recommended: $recommended, briefDescription: $briefDescription, description: $description, requirements: $requirements, headerImage: $headerImage, price: $price, screenshots: $screenshots, categoriesId: $categoriesId, isSale: $isSale, discountPercent: $discountPercent, saleStartDate: $saleStartDate, saleEndDate: $saleEndDate, isOwned: $isOwned, installed: $installed, favorite: $favorite, playtimeHours: $playtimeHours)';
}


}

/// @nodoc
abstract mixin class _$GameModelCopyWith<$Res> implements $GameModelCopyWith<$Res> {
  factory _$GameModelCopyWith(_GameModel value, $Res Function(_GameModel) _then) = __$GameModelCopyWithImpl;
@override @useResult
$Res call({
 String gameId, String publisherId, String name, int recommended, String briefDescription, String description, String requirements, String headerImage, double price, List<String>? screenshots, List<String> categoriesId, bool? isSale, double? discountPercent, DateTime? saleStartDate, DateTime? saleEndDate, bool isOwned, bool installed, bool favorite, double? playtimeHours
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
@override @pragma('vm:prefer-inline') $Res call({Object? gameId = null,Object? publisherId = null,Object? name = null,Object? recommended = null,Object? briefDescription = null,Object? description = null,Object? requirements = null,Object? headerImage = null,Object? price = null,Object? screenshots = freezed,Object? categoriesId = null,Object? isSale = freezed,Object? discountPercent = freezed,Object? saleStartDate = freezed,Object? saleEndDate = freezed,Object? isOwned = null,Object? installed = null,Object? favorite = null,Object? playtimeHours = freezed,}) {
  return _then(_GameModel(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,publisherId: null == publisherId ? _self.publisherId : publisherId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,recommended: null == recommended ? _self.recommended : recommended // ignore: cast_nullable_to_non_nullable
as int,briefDescription: null == briefDescription ? _self.briefDescription : briefDescription // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,requirements: null == requirements ? _self.requirements : requirements // ignore: cast_nullable_to_non_nullable
as String,headerImage: null == headerImage ? _self.headerImage : headerImage // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,screenshots: freezed == screenshots ? _self._screenshots : screenshots // ignore: cast_nullable_to_non_nullable
as List<String>?,categoriesId: null == categoriesId ? _self._categoriesId : categoriesId // ignore: cast_nullable_to_non_nullable
as List<String>,isSale: freezed == isSale ? _self.isSale : isSale // ignore: cast_nullable_to_non_nullable
as bool?,discountPercent: freezed == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as double?,saleStartDate: freezed == saleStartDate ? _self.saleStartDate : saleStartDate // ignore: cast_nullable_to_non_nullable
as DateTime?,saleEndDate: freezed == saleEndDate ? _self.saleEndDate : saleEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isOwned: null == isOwned ? _self.isOwned : isOwned // ignore: cast_nullable_to_non_nullable
as bool,installed: null == installed ? _self.installed : installed // ignore: cast_nullable_to_non_nullable
as bool,favorite: null == favorite ? _self.favorite : favorite // ignore: cast_nullable_to_non_nullable
as bool,playtimeHours: freezed == playtimeHours ? _self.playtimeHours : playtimeHours // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
