import 'dart:convert';
import 'package:http/http.dart' as http;

import "../config/config.dart";

class Post {
  final String? postId;
  final String userId;
  final String forumId;
  final String title;
  final String? content;
  final int? recommend;
  final int? comments;
  final DateTime? postDate;

  const Post({
    this.postId,
    required this.userId,
    required this.forumId,
    required this.title,
    this.content,
    this.recommend,
    this.comments,
    this.postDate,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    final postId = json["postid"] as String?;
    final userId = json["userid"] as String;
    final forumId = json["forumid"] as String;
    final title = json["title"] as String;
    final content = json["content"] as String?;
    final recommend = json["recommend"]?.toInt();
    final comments = json["comments"]?.toInt();

    final postDateStr = json["postdate"] as String?;
    final postDate = (postDateStr != null && postDateStr.isNotEmpty)
        ? DateTime.parse(postDateStr)
        : null;

    return Post(
      postId: postId,
      userId: userId,
      forumId: forumId,
      title: title,
      content: content,
      recommend: recommend,
      comments: comments,
      postDate: postDate,
    );
  }

  @override
  String toString() {
    return "Post {postId: " +
        (this.postId ?? "\"\"") +
        ", userId: " +
        this.userId +
        ", forumId: " +
        this.forumId +
        ", title: " +
        this.title +
        ", content: " +
        (this.content ?? "\"\"") +
        ", recommend: " +
        this.recommend.toString() +
        ", comments: " +
        this.comments.toString() +
        ", postDate: " +
        this.postDate.toString() +
        "}";
  }
}

