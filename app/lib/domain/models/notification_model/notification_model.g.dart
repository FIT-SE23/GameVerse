// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    _NotificationModel(
      notificationId: json['messageid'] as String?,
      userId: json['userid'],
      approved: json['approved'] as bool,
      gameName: json['gamename'] as String?,
      date: DateTime.parse(json['date'] as String),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$NotificationModelToJson(_NotificationModel instance) =>
    <String, dynamic>{
      'messageid': instance.notificationId,
      'userid': instance.userId,
      'approved': instance.approved,
      'gamename': instance.gameName,
      'date': instance.date.toIso8601String(),
      'message': instance.message,
    };
