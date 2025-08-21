import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';

part 'post_model.g.dart';

@freezed
abstract class PostModel with _$PostModel {
  const factory PostModel({
    required String username,
    @JsonKey(name: 'postid') required String postId,
    @JsonKey(name: 'userid') required String authorId,
    @JsonKey(name: 'forumid') required String forumId,
    required String title,
    required String content,
    @JsonKey(name: 'recommend') required int upvotes,
    @JsonKey(name: 'postdate') required DateTime createdAt,
    @JsonKey(name: 'comments') required int commentsCount,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, Object?> json) => 
    _$PostModelFromJson(json);
}