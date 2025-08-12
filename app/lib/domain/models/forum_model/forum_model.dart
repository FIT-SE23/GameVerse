import 'package:freezed_annotation/freezed_annotation.dart';

part 'forum_model.freezed.dart';
part 'forum_model.g.dart';

@freezed
abstract class ForumModel with _$ForumModel {
  const factory ForumModel({
    @JsonKey(name: 'gameid') required String gameId,
    required String name,
    @JsonKey(name: 'briefdescription') required String briefDescription,
    @JsonKey(name: 'headerimage') required String headerImage,
  }) = _ForumModel;

  factory ForumModel.fromJson(Map<String, dynamic> json) => 
      _$ForumModelFromJson(json);
}