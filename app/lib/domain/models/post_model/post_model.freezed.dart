// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostModel {

 String get username;@JsonKey(name: 'postid') String get postId;@JsonKey(name: 'userid') String get authorId;@JsonKey(name: 'forumid') String get forumId; String get title; String get content;@JsonKey(name: 'recommend') int get upvotes;@JsonKey(name: 'postdate') DateTime get createdAt;@JsonKey(name: 'comments') int get commentsCount;
/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostModelCopyWith<PostModel> get copyWith => _$PostModelCopyWithImpl<PostModel>(this as PostModel, _$identity);

  /// Serializes this PostModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostModel&&(identical(other.username, username) || other.username == username)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.forumId, forumId) || other.forumId == forumId)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.upvotes, upvotes) || other.upvotes == upvotes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.commentsCount, commentsCount) || other.commentsCount == commentsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,postId,authorId,forumId,title,content,upvotes,createdAt,commentsCount);

@override
String toString() {
  return 'PostModel(username: $username, postId: $postId, authorId: $authorId, forumId: $forumId, title: $title, content: $content, upvotes: $upvotes, createdAt: $createdAt, commentsCount: $commentsCount)';
}


}

/// @nodoc
abstract mixin class $PostModelCopyWith<$Res>  {
  factory $PostModelCopyWith(PostModel value, $Res Function(PostModel) _then) = _$PostModelCopyWithImpl;
@useResult
$Res call({
 String username,@JsonKey(name: 'postid') String postId,@JsonKey(name: 'userid') String authorId,@JsonKey(name: 'forumid') String forumId, String title, String content,@JsonKey(name: 'recommend') int upvotes,@JsonKey(name: 'postdate') DateTime createdAt,@JsonKey(name: 'comments') int commentsCount
});




}
/// @nodoc
class _$PostModelCopyWithImpl<$Res>
    implements $PostModelCopyWith<$Res> {
  _$PostModelCopyWithImpl(this._self, this._then);

  final PostModel _self;
  final $Res Function(PostModel) _then;

/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? postId = null,Object? authorId = null,Object? forumId = null,Object? title = null,Object? content = null,Object? upvotes = null,Object? createdAt = null,Object? commentsCount = null,}) {
  return _then(_self.copyWith(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,forumId: null == forumId ? _self.forumId : forumId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,upvotes: null == upvotes ? _self.upvotes : upvotes // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,commentsCount: null == commentsCount ? _self.commentsCount : commentsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PostModel].
extension PostModelPatterns on PostModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostModel value)  $default,){
final _that = this;
switch (_that) {
case _PostModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostModel value)?  $default,){
final _that = this;
switch (_that) {
case _PostModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String username, @JsonKey(name: 'postid')  String postId, @JsonKey(name: 'userid')  String authorId, @JsonKey(name: 'forumid')  String forumId,  String title,  String content, @JsonKey(name: 'recommend')  int upvotes, @JsonKey(name: 'postdate')  DateTime createdAt, @JsonKey(name: 'comments')  int commentsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostModel() when $default != null:
return $default(_that.username,_that.postId,_that.authorId,_that.forumId,_that.title,_that.content,_that.upvotes,_that.createdAt,_that.commentsCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String username, @JsonKey(name: 'postid')  String postId, @JsonKey(name: 'userid')  String authorId, @JsonKey(name: 'forumid')  String forumId,  String title,  String content, @JsonKey(name: 'recommend')  int upvotes, @JsonKey(name: 'postdate')  DateTime createdAt, @JsonKey(name: 'comments')  int commentsCount)  $default,) {final _that = this;
switch (_that) {
case _PostModel():
return $default(_that.username,_that.postId,_that.authorId,_that.forumId,_that.title,_that.content,_that.upvotes,_that.createdAt,_that.commentsCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String username, @JsonKey(name: 'postid')  String postId, @JsonKey(name: 'userid')  String authorId, @JsonKey(name: 'forumid')  String forumId,  String title,  String content, @JsonKey(name: 'recommend')  int upvotes, @JsonKey(name: 'postdate')  DateTime createdAt, @JsonKey(name: 'comments')  int commentsCount)?  $default,) {final _that = this;
switch (_that) {
case _PostModel() when $default != null:
return $default(_that.username,_that.postId,_that.authorId,_that.forumId,_that.title,_that.content,_that.upvotes,_that.createdAt,_that.commentsCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostModel implements PostModel {
  const _PostModel({required this.username, @JsonKey(name: 'postid') required this.postId, @JsonKey(name: 'userid') required this.authorId, @JsonKey(name: 'forumid') required this.forumId, required this.title, required this.content, @JsonKey(name: 'recommend') required this.upvotes, @JsonKey(name: 'postdate') required this.createdAt, @JsonKey(name: 'comments') required this.commentsCount});
  factory _PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);

@override final  String username;
@override@JsonKey(name: 'postid') final  String postId;
@override@JsonKey(name: 'userid') final  String authorId;
@override@JsonKey(name: 'forumid') final  String forumId;
@override final  String title;
@override final  String content;
@override@JsonKey(name: 'recommend') final  int upvotes;
@override@JsonKey(name: 'postdate') final  DateTime createdAt;
@override@JsonKey(name: 'comments') final  int commentsCount;

/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostModelCopyWith<_PostModel> get copyWith => __$PostModelCopyWithImpl<_PostModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostModel&&(identical(other.username, username) || other.username == username)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.forumId, forumId) || other.forumId == forumId)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.upvotes, upvotes) || other.upvotes == upvotes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.commentsCount, commentsCount) || other.commentsCount == commentsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,postId,authorId,forumId,title,content,upvotes,createdAt,commentsCount);

@override
String toString() {
  return 'PostModel(username: $username, postId: $postId, authorId: $authorId, forumId: $forumId, title: $title, content: $content, upvotes: $upvotes, createdAt: $createdAt, commentsCount: $commentsCount)';
}


}

/// @nodoc
abstract mixin class _$PostModelCopyWith<$Res> implements $PostModelCopyWith<$Res> {
  factory _$PostModelCopyWith(_PostModel value, $Res Function(_PostModel) _then) = __$PostModelCopyWithImpl;
@override @useResult
$Res call({
 String username,@JsonKey(name: 'postid') String postId,@JsonKey(name: 'userid') String authorId,@JsonKey(name: 'forumid') String forumId, String title, String content,@JsonKey(name: 'recommend') int upvotes,@JsonKey(name: 'postdate') DateTime createdAt,@JsonKey(name: 'comments') int commentsCount
});




}
/// @nodoc
class __$PostModelCopyWithImpl<$Res>
    implements _$PostModelCopyWith<$Res> {
  __$PostModelCopyWithImpl(this._self, this._then);

  final _PostModel _self;
  final $Res Function(_PostModel) _then;

/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = null,Object? postId = null,Object? authorId = null,Object? forumId = null,Object? title = null,Object? content = null,Object? upvotes = null,Object? createdAt = null,Object? commentsCount = null,}) {
  return _then(_PostModel(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,forumId: null == forumId ? _self.forumId : forumId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,upvotes: null == upvotes ? _self.upvotes : upvotes // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,commentsCount: null == commentsCount ? _self.commentsCount : commentsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
