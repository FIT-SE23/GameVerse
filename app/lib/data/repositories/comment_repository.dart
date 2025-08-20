import 'package:http/http.dart' as http;

import 'package:gameverse/data/services/comment_api_client.dart';
import 'package:gameverse/domain/models/comment_model/comment_model.dart';

class CommentSortCriteria {
  static final date = 'date';
  static final recommend = 'recommend';
}

class CommentRepository {
  final http.Client client;

  CommentRepository({http.Client? httpClient}) : client = httpClient ?? http.Client();

  Future<List<CommentModel>> getComments(String postId, {String? sortBy, int limit = 20}) async {
    try {
      final response = await CommentApiClient().listComments(
        postId,
        sortBy ?? CommentSortCriteria.recommend,
        limit: limit
      );

      if (response.code != 200) {
        throw Exception('Failed to load comments: ${response.message}');
      } else {
        final comments = <CommentModel>[];
        for (final json in response.data as List<dynamic>) {
          comments.add(CommentModel.fromJson(json as Map<String, dynamic>));
        }
        return comments;
      }
    } catch (e) {
      throw Exception('Failed to load comments: $e');
    }
  }

  Future<void> addComment(String token, CommentModel comment) async {
    try {
      final response = await CommentApiClient().addComment(
        token,
        comment.postId,
        comment.content
      );

      if (response.code != 200) {
        throw Exception('Failed to comment: ${response.message}');
      } else {
        return;
      }
    } catch (e) {
      throw Exception('Failed to comment: $e');
    }
  }
  Future<void> deleteComment(String token, String commentId) async {
    try {
      final response = await CommentApiClient().deleteComment(
        token,
        commentId,
      );

      if (response.code != 200) {
        throw Exception('Failed to delete comment: ${response.message}');
      } else {
        return;
      }
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }
  Future<void> updateComment(String token, CommentModel comment) async {
    try {
      final response = await CommentApiClient().updateComment(
        token,
        comment.commentId,
        comment.content
      );

      if (response.code != 200) {
        throw Exception('Failed to update comment: ${response.message}');
      } else {
        return;
      }
    } catch (e) {
      throw Exception('Failed to update comment: $e');
    }
  }
}