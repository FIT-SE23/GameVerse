import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_model.freezed.dart';

part 'comment_model.g.dart';

@freezed
abstract class CommentModel with _$CommentModel {
  const factory CommentModel({
    required String id,
    required String relatedGameId,
    List<String>? postsId,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, Object?> json) => 
    _$CommentModelFromJson(json);
}