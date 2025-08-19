import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_model.freezed.dart';

part 'comment_model.g.dart';

@freezed
abstract class CommentModel with _$CommentModel {
  const factory CommentModel({
    @JsonKey(name: 'commentid') required String commentId,
    @JsonKey(name: 'userid') required String userId,
    @JsonKey(name: 'postid') required String postId,
    required String content,
    required int recommend,
    @JsonKey(name: 'commentdate') required DateTime commentDate,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, Object?> json) => 
    _$CommentModelFromJson(json);
}