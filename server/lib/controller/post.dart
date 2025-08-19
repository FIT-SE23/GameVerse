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

Future<Response> addPost(
  String token,
  String forumId,
  String title,
  String content,
) async {
  final raw = await http.post(
    Uri.parse(serverURL + "post"),
    headers: <String, String>{"Authorization": "Bearer $token"},
    body: <String, String>{
      "forumid": forumId,
      "title": title,
      "content": content,
    }
  );

  return Response.fromJson(raw.statusCode, jsonDecode(raw.body) as Map<String, dynamic>);
}

Future<Response> getPost(String postId) async {
  final raw = await http.get(Uri.parse(serverURL + "post/$postId"));

  var jsonBody;
  try {
    jsonBody = jsonDecode(raw.body);
  } on FormatException catch (e) {
    return Response.fromJson(400, {"message": e.message});
  }

  final response = Response.fromJson(raw.statusCode, jsonBody as Map<String, dynamic>);
  final post = Post.fromJson(response.data[0] as Map<String, dynamic>);
  return Response(code: response.code, message: response.message, data: post);
}

Future<Response> updatePost(
  String token, 
  String postId, 
  String title, 
  String content
) async {
  final raw = await http.patch(
    Uri.parse(serverURL + "post/$postId"),
    headers: {"Authorization": "Bearer $token"},
    body: {
      "title": title,
      "content": content,
    }
  );

  return Response.fromJson(raw.statusCode, jsonDecode(raw.body) as Map<String, dynamic>);
}

Future<Response> deletePost(String token, String postId) async {
  final raw = await http.delete(
    Uri.parse(serverURL + "post/$postId"),
    headers: {"Authorization": "Bearer $token"}
  );

  return Response.fromJson(raw.statusCode, jsonDecode(raw.body) as Map<String, dynamic>);
}

Future<Response> recommendPost(String token, String postId) async {
  final raw = await http.post(
    Uri.parse(serverURL + "recommend/post"),
    headers: {"Authorization": "Bearer $token"},
    body: {"postid": postId}
  );

  return Response.fromJson(raw.statusCode, jsonDecode(raw.body) as Map<String, dynamic>);
}

Future<Response> listPosts(String forumId, String title, String sortBy, {int limit = 20}) async {
  final raw = await http.get(
    Uri.parse(serverURL +
        "search?entity=post&forumid=$forumId&title=${Uri.encodeComponent(title)}&sortby=$sortBy&limit=$limit")
  );

  var jsonBody;
  try {
    jsonBody = jsonDecode(raw.body);
  } on FormatException catch (e) {
    return Response.fromJson(400, {"message": e.message});
  }

  final response = Response.fromJson(
    raw.statusCode,
    jsonBody as Map<String, dynamic>,
  );

  final posts = <Post>[];
  for (var post in response.data as List<dynamic>) {
    posts.add(Post.fromJson(post as Map<String, dynamic>));
  }

  return Response(code: response.code, message: response.message, data: posts);
}