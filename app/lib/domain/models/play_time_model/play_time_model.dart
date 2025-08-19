import 'package:freezed_annotation/freezed_annotation.dart';

part 'play_time_model.freezed.dart';
part 'play_time_model.g.dart';

@freezed
abstract class PlayTimeModel with _$PlayTimeModel {
  const factory PlayTimeModel({
    @JsonKey(name: 'playtimeid') String? playtimeId,
    @JsonKey(name: 'userid') String? userId,
    @JsonKey(name: 'begin') required DateTime begin,
    @JsonKey(name: 'end') DateTime? end,
  }) = _PlayTimeModel;

  factory PlayTimeModel.fromJson(Map<String, dynamic> json) =>
      _$PlayTimeModelFromJson(json);
}