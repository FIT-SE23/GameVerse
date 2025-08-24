import 'dart:convert';
import 'package:http/http.dart' as http;

import "../config/config.dart";

class Comment {
  final String? commentId;
  final String userId;
  final String postId;
  final String? content;
  final int? recommend;
  final DateTime? commentDate;

  const Comment({
    this.commentId,
    required this.userId,
    required this.postId,
    this.content,
    this.recommend,
    this.commentDate,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    final commentId = json["commentid"] as String?;
    final userId = json["userid"] as String;
    final postId = json["postid"] as String;
    final content = json["content"] as String?;
    final recommend = json["recommend"]?.toInt();

    final commentDateStr = json["commentdate"] as String?;
    final commentDate =
        (commentDateStr != null && commentDateStr.isNotEmpty)
            ? DateTime.parse(commentDateStr)
            : null;

    return Comment(
      commentId: commentId,
      userId: userId,
      postId: postId,
      content: content,
      recommend: recommend,
      commentDate: commentDate,
    );
  }

  @override
  String toString() {
    return "Comment {commentId: " +
        (commentId ?? "\"\"") +
        ", userId: " +
        userId +
        ", postId: " +
        postId +
        ", content: " +
        (content ?? "\"\"") +
        ", recommend: " +
        recommend.toString() +
        ", commentDate: " +
        commentDate.toString() +
        "}";
  }
}

