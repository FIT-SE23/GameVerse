import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';

part 'post_model.g.dart';

@freezed
abstract class PostModel with _$PostModel {
  const factory PostModel({
    required String id,
    required String content,
    required DateTime createdAt,
    required int upvotes,
    required String forumId,
    required String authorId,
    List<String>? commentsId,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, Object?> json) => 
    _$PostModelFromJson(json);
}