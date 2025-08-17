// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'publisher_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PublisherRequestModel {

@JsonKey(name: 'requestid') String get requestId;@JsonKey(name: 'userid') String get userId;@JsonKey(name: 'username') String get username;@JsonKey(name: 'email') String get email; String get description;@JsonKey(name: 'paymentmethod') PaymentMethodModel get paymentMethod; String get status;// 'pending', 'approved', 'rejected'
 String? get feedback;// Operator feedback for rejections
@JsonKey(name: 'submissiondate') DateTime? get submissionDate;
/// Create a copy of PublisherRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublisherRequestModelCopyWith<PublisherRequestModel> get copyWith => _$PublisherRequestModelCopyWithImpl<PublisherRequestModel>(this as PublisherRequestModel, _$identity);

  /// Serializes this PublisherRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublisherRequestModel&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.description, description) || other.description == description)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.status, status) || other.status == status)&&(identical(other.feedback, feedback) || other.feedback == feedback)&&(identical(other.submissionDate, submissionDate) || other.submissionDate == submissionDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestId,userId,username,email,description,paymentMethod,status,feedback,submissionDate);

@override
String toString() {
  return 'PublisherRequestModel(requestId: $requestId, userId: $userId, username: $username, email: $email, description: $description, paymentMethod: $paymentMethod, status: $status, feedback: $feedback, submissionDate: $submissionDate)';
}


}

/// @nodoc
abstract mixin class $PublisherRequestModelCopyWith<$Res>  {
  factory $PublisherRequestModelCopyWith(PublisherRequestModel value, $Res Function(PublisherRequestModel) _then) = _$PublisherRequestModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'requestid') String requestId,@JsonKey(name: 'userid') String userId,@JsonKey(name: 'username') String username,@JsonKey(name: 'email') String email, String description,@JsonKey(name: 'paymentmethod') PaymentMethodModel paymentMethod, String status, String? feedback,@JsonKey(name: 'submissiondate') DateTime? submissionDate
});


$PaymentMethodModelCopyWith<$Res> get paymentMethod;

}
/// @nodoc
class _$PublisherRequestModelCopyWithImpl<$Res>
    implements $PublisherRequestModelCopyWith<$Res> {
  _$PublisherRequestModelCopyWithImpl(this._self, this._then);

  final PublisherRequestModel _self;
  final $Res Function(PublisherRequestModel) _then;

/// Create a copy of PublisherRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestId = null,Object? userId = null,Object? username = null,Object? email = null,Object? description = null,Object? paymentMethod = null,Object? status = null,Object? feedback = freezed,Object? submissionDate = freezed,}) {
  return _then(_self.copyWith(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethodModel,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as String?,submissionDate: freezed == submissionDate ? _self.submissionDate : submissionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of PublisherRequestModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentMethodModelCopyWith<$Res> get paymentMethod {
  
  return $PaymentMethodModelCopyWith<$Res>(_self.paymentMethod, (value) {
    return _then(_self.copyWith(paymentMethod: value));
  });
}
}


/// Adds pattern-matching-related methods to [PublisherRequestModel].
extension PublisherRequestModelPatterns on PublisherRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublisherRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublisherRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublisherRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _PublisherRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublisherRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _PublisherRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'requestid')  String requestId, @JsonKey(name: 'userid')  String userId, @JsonKey(name: 'username')  String username, @JsonKey(name: 'email')  String email,  String description, @JsonKey(name: 'paymentmethod')  PaymentMethodModel paymentMethod,  String status,  String? feedback, @JsonKey(name: 'submissiondate')  DateTime? submissionDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublisherRequestModel() when $default != null:
return $default(_that.requestId,_that.userId,_that.username,_that.email,_that.description,_that.paymentMethod,_that.status,_that.feedback,_that.submissionDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'requestid')  String requestId, @JsonKey(name: 'userid')  String userId, @JsonKey(name: 'username')  String username, @JsonKey(name: 'email')  String email,  String description, @JsonKey(name: 'paymentmethod')  PaymentMethodModel paymentMethod,  String status,  String? feedback, @JsonKey(name: 'submissiondate')  DateTime? submissionDate)  $default,) {final _that = this;
switch (_that) {
case _PublisherRequestModel():
return $default(_that.requestId,_that.userId,_that.username,_that.email,_that.description,_that.paymentMethod,_that.status,_that.feedback,_that.submissionDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'requestid')  String requestId, @JsonKey(name: 'userid')  String userId, @JsonKey(name: 'username')  String username, @JsonKey(name: 'email')  String email,  String description, @JsonKey(name: 'paymentmethod')  PaymentMethodModel paymentMethod,  String status,  String? feedback, @JsonKey(name: 'submissiondate')  DateTime? submissionDate)?  $default,) {final _that = this;
switch (_that) {
case _PublisherRequestModel() when $default != null:
return $default(_that.requestId,_that.userId,_that.username,_that.email,_that.description,_that.paymentMethod,_that.status,_that.feedback,_that.submissionDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PublisherRequestModel implements PublisherRequestModel {
  const _PublisherRequestModel({@JsonKey(name: 'requestid') required this.requestId, @JsonKey(name: 'userid') required this.userId, @JsonKey(name: 'username') required this.username, @JsonKey(name: 'email') required this.email, required this.description, @JsonKey(name: 'paymentmethod') required this.paymentMethod, required this.status, this.feedback, @JsonKey(name: 'submissiondate') this.submissionDate});
  factory _PublisherRequestModel.fromJson(Map<String, dynamic> json) => _$PublisherRequestModelFromJson(json);

@override@JsonKey(name: 'requestid') final  String requestId;
@override@JsonKey(name: 'userid') final  String userId;
@override@JsonKey(name: 'username') final  String username;
@override@JsonKey(name: 'email') final  String email;
@override final  String description;
@override@JsonKey(name: 'paymentmethod') final  PaymentMethodModel paymentMethod;
@override final  String status;
// 'pending', 'approved', 'rejected'
@override final  String? feedback;
// Operator feedback for rejections
@override@JsonKey(name: 'submissiondate') final  DateTime? submissionDate;

/// Create a copy of PublisherRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublisherRequestModelCopyWith<_PublisherRequestModel> get copyWith => __$PublisherRequestModelCopyWithImpl<_PublisherRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublisherRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublisherRequestModel&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.description, description) || other.description == description)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.status, status) || other.status == status)&&(identical(other.feedback, feedback) || other.feedback == feedback)&&(identical(other.submissionDate, submissionDate) || other.submissionDate == submissionDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestId,userId,username,email,description,paymentMethod,status,feedback,submissionDate);

@override
String toString() {
  return 'PublisherRequestModel(requestId: $requestId, userId: $userId, username: $username, email: $email, description: $description, paymentMethod: $paymentMethod, status: $status, feedback: $feedback, submissionDate: $submissionDate)';
}


}

/// @nodoc
abstract mixin class _$PublisherRequestModelCopyWith<$Res> implements $PublisherRequestModelCopyWith<$Res> {
  factory _$PublisherRequestModelCopyWith(_PublisherRequestModel value, $Res Function(_PublisherRequestModel) _then) = __$PublisherRequestModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'requestid') String requestId,@JsonKey(name: 'userid') String userId,@JsonKey(name: 'username') String username,@JsonKey(name: 'email') String email, String description,@JsonKey(name: 'paymentmethod') PaymentMethodModel paymentMethod, String status, String? feedback,@JsonKey(name: 'submissiondate') DateTime? submissionDate
});


@override $PaymentMethodModelCopyWith<$Res> get paymentMethod;

}
/// @nodoc
class __$PublisherRequestModelCopyWithImpl<$Res>
    implements _$PublisherRequestModelCopyWith<$Res> {
  __$PublisherRequestModelCopyWithImpl(this._self, this._then);

  final _PublisherRequestModel _self;
  final $Res Function(_PublisherRequestModel) _then;

/// Create a copy of PublisherRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? userId = null,Object? username = null,Object? email = null,Object? description = null,Object? paymentMethod = null,Object? status = null,Object? feedback = freezed,Object? submissionDate = freezed,}) {
  return _then(_PublisherRequestModel(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethodModel,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as String?,submissionDate: freezed == submissionDate ? _self.submissionDate : submissionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of PublisherRequestModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentMethodModelCopyWith<$Res> get paymentMethod {
  
  return $PaymentMethodModelCopyWith<$Res>(_self.paymentMethod, (value) {
    return _then(_self.copyWith(paymentMethod: value));
  });
}
}

// dart format on
