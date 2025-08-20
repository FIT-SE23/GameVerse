import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
abstract class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    @JsonKey(name: 'messageid') String? notificationId,
    @JsonKey(name: 'userid') required userId,
    @JsonKey(name: 'approved') required bool approved,
    // has a game name if notification is related to a game
    @JsonKey(name: 'gamename') String? gameName, 
    @JsonKey(name: 'date') required DateTime date,
    @JsonKey(name: 'message') String? message,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}