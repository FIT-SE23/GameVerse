// import 'package:dio/dio.dart';
// import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;

import 'package:gameverse/data/services/post_api_client.dart';
import 'package:gameverse/domain/models/post_model/post_model.dart';

class PostSortCriteria {
  static final date = 'date';
  static final recommend = 'recommend';
}

class PostRepository {
  final http.Client client;

  PostRepository({http.Client? httpClient}) : client = httpClient ?? http.Client();

  Future<List<PostModel>> searchPosts(String gameId, String title, String sortBy, {int limit = 20}) async {
    try {
      final response = await PostApiClient().listPosts(gameId, title, sortBy, limit: limit);

      if (response.code != 200) {
        throw Exception('Failed to load posts: ${response.message}');
      } else {
        final posts = <PostModel>[];
        for (final json in response.data as List<dynamic>) {
          posts.add(PostModel.fromJson(json as Map<String, dynamic>));
        }
        return posts;
      }

    } catch (e) {
      throw Exception('Failed to load posts: $e');
    }
  }

  Future<PostModel?> getPost(String postId) async {  
    try {
      final response = await PostApiClient().getPost(postId);
      
      if (response.code != 200) {
        throw Exception('Failed to load post: ${response.message}');
      } else {
        final post = PostModel.fromJson(response.data as Map<String, dynamic>);
        return post;
      }
    } catch (e) {
      return null;
    }
  }
  
  Future<void> createPost(String token, PostModel post) async {
    try {
      final response = await PostApiClient().addPost(
        token,
        post.forumId,
        post.title,
        post.content,
      );

      if (response.code != 200) {
        throw Exception('Failed to create post: ${response.message}');
      } else {
        return;
      }
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  Future<void> deletePost(String token, String postId) async {
    try {
      final response = await PostApiClient().deletePost(token, postId);

      if (response.code != 200) {
        throw Exception('Failed to delete post: ${response.message}');
      } else {
        return;
      }

    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  Future<void> updatePost(String token, PostModel post) async {
    try {
      final response = await PostApiClient().updatePost(
        token,
        post.postId,
        post.title,
        post.content
      );
      
      if (response.code != 200) {
        throw Exception('Failed to update post: ${response.message}');
      } else {
        return;
      }
    } catch (e) {
      throw Exception('Failed to update post: $e');
    }
  }

  Future<void> recommendPost(String token, String postId) async {
    try {
      final response = await PostApiClient().recommendPost(token, postId);
      
      if (response.code != 200) {
        throw Exception('Failed to recommend post: ${response.message}');
      } else {
        return;
      } 
    } catch (e) {
      throw Exception('Failed to recommend post: $e');
    }
  }
}