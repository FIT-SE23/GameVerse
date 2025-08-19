// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_time_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayTimeModel _$PlayTimeModelFromJson(Map<String, dynamic> json) =>
    _PlayTimeModel(
      playtimeId: json['playtimeid'] as String?,
      userId: json['userid'] as String?,
      begin: DateTime.parse(json['begin'] as String),
      end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
    );

Map<String, dynamic> _$PlayTimeModelToJson(_PlayTimeModel instance) =>
    <String, dynamic>{
      'playtimeid': instance.playtimeId,
      'userid': instance.userId,
      'begin': instance.begin.toIso8601String(),
      'end': instance.end?.toIso8601String(),
    };
