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
    final commentDate = (commentDateStr != null && commentDateStr.isNotEmpty)
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

Future<Response> addComment(
  String token,
  String postId,
  String content
) async {
  final raw = await http.post(
    Uri.parse(serverURL + "comment"),
    headers: {"Authorization": "Bearer $token"},
    body: {
      "postid": postId,
      "content": content,
    }
  );

  return Response.fromJson(raw.statusCode, jsonDecode(raw.body) as Map<String, dynamic>);
}

Future<Response> getComment(String commentId) async {
  final raw = await http.get(Uri.parse(serverURL + "comment/$commentId"));

  var jsonBody;
  try {
    jsonBody = jsonDecode(raw.body);
  } on FormatException catch (e) {
    return Response.fromJson(400, {"message": e.message});
  }

  final response = Response.fromJson(raw.statusCode, jsonBody as Map<String, dynamic>);
  final comment = Comment.fromJson(response.data[0] as Map<String, dynamic>);
  return Response(code: response.code, message: response.message, data: comment);
}

Future<Response> updateComment(
  String token,
  String commentId,
  String content
) async {
  final raw = await http.patch(
    Uri.parse(serverURL + "comment/$commentId"),
    headers: {"Authorization": "Bearer $token"},
    body: {"content": content}
  );

  return Response.fromJson(raw.statusCode, jsonDecode(raw.body) as Map<String, dynamic>);
}

Future<Response> deleteComment(String token, String commentId) async {
  final raw = await http.delete(
    Uri.parse(serverURL + "comment/$commentId"),
    headers: {"Authorization": "Bearer $token"}
  );

  return Response.fromJson(raw.statusCode, jsonDecode(raw.body) as Map<String, dynamic>);
}

Future<Response> recommendComment(String token, String commentId) async {
  final raw = await http.post(
    Uri.parse(serverURL + "recommend/comment"),
    headers: {"Authorization": "Bearer $token"},
    body: {"commentid": commentId}
  );

  return Response.fromJson(raw.statusCode, jsonDecode(raw.body) as Map<String, dynamic>);
}
