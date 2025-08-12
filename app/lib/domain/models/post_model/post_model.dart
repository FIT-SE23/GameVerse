import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';

part 'post_model.g.dart';

@freezed
abstract class PostModel with _$PostModel {
  const factory PostModel({
    @JsonKey(name: 'postid') required String postId,
    @JsonKey(name: 'userid') required String authorId,
    @JsonKey(name: 'forumid') required String forumId,
    required String title,
    required String content,
    required int upvotes,
    @JsonKey(name: 'postdate') required DateTime createdAt,
    List<String>? commentsId,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, Object?> json) => 
    _$PostModelFromJson(json);
}