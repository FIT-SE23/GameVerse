// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publisher_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PublisherRequestModel _$PublisherRequestModelFromJson(
  Map<String, dynamic> json,
) => _PublisherRequestModel(
  requestId: json['requestid'] as String,
  userId: json['userid'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
  description: json['description'] as String,
  paymentMethod: PaymentMethodModel.fromJson(
    json['paymentmethod'] as Map<String, dynamic>,
  ),
  status: json['status'] as String,
  feedback: json['feedback'] as String?,
  submissionDate: json['submissiondate'] == null
      ? null
      : DateTime.parse(json['submissiondate'] as String),
);

Map<String, dynamic> _$PublisherRequestModelToJson(
  _PublisherRequestModel instance,
) => <String, dynamic>{
  'requestid': instance.requestId,
  'userid': instance.userId,
  'username': instance.username,
  'email': instance.email,
  'description': instance.description,
  'paymentmethod': instance.paymentMethod,
  'status': instance.status,
  'feedback': instance.feedback,
  'submissiondate': instance.submissionDate?.toIso8601String(),
};
