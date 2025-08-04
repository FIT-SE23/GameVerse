import 'package:freezed_annotation/freezed_annotation.dart';

part 'forum_model.freezed.dart';

part 'forum_model.g.dart';

@freezed
abstract class ForumModel with _$ForumModel {
  const factory ForumModel({
    required String forumId,
    required String relatedGameId,
    List<String>? postsId,
  }) = _ForumModel;

  factory ForumModel.fromJson(Map<String, Object?> json) => 
    _$ForumModelFromJson(json);
}