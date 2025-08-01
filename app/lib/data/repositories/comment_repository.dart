import 'package:http/http.dart' as http;

import 'package:gameverse/domain/models/comment_model/comment_model.dart';

class CommentRepository {
  final http.Client client;

  CommentRepository({http.Client? httpClient}) : client = httpClient ?? http.Client();

  Future<List<CommentModel>> getCommentsForPost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _getMockCommentsForPost(postId);
  }

  List<CommentModel> _getMockCommentsForPost(String postId) {
    // final now = DateTime.now();
    
    switch (postId) {
      case 'cp_post_1':
        return [
          CommentModel(
            id: 'cp_comment_1',
            relatedGameId: '1091500',
            postsId: ['cp_post_1'],
          ),
          CommentModel(
            id: 'cp_comment_2',
            relatedGameId: '1091500',
            postsId: ['cp_post_1'],
          ),
        ];
      case 'cp_post_2':
        return [
          CommentModel(
            id: 'cp_comment_3',
            relatedGameId: '1091500',
            postsId: ['cp_post_2'],
          ),
        ];
      case 'cs_post_1':
        return [
          CommentModel(
            id: 'cs_comment_1',
            relatedGameId: '730',
            postsId: ['cs_post_1'],
          ),
          CommentModel(
            id: 'cs_comment_2',
            relatedGameId: '730',
            postsId: ['cs_post_1'],
          ),
        ];
      case 'cs_post_2':
        return [
          CommentModel(
            id: 'cs_comment_3',
            relatedGameId: '730',
            postsId: ['cs_post_2'],
          ),
        ];
      case 'dota_post_1':
        return [
          CommentModel(
            id: 'dota_comment_1',
            relatedGameId: '570',
            postsId: ['dota_post_1'],
          ),
          CommentModel(
            id: 'dota_comment_2',
            relatedGameId: '570',
            postsId: ['dota_post_1'],
          ),
        ];
      case 'dota_post_2':
        return [
          CommentModel(
            id: 'dota_comment_3',
            relatedGameId: '570',
            postsId: ['dota_post_2'],
          ),
        ];
      default:
        return [];
    }
  }

  Future<void> addComment(CommentModel comment) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate adding a comment
  }
  Future<void> deleteComment(String commentId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate deleting a comment
  }
  Future<void> updateComment(CommentModel comment) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate updating a comment
  }
}