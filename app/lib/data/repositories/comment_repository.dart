import 'dart:ffi';

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

  

  Future<void> addComment(CommentModel comment) async {
    // Simulate adding a comment
  }
  Future<void> deleteComment(String commentId) async {
    // Simulate deleting a comment
  }
  Future<void> updateComment(CommentModel comment) async {
    // Simulate updating a comment
  }
}