import 'package:flutter/material.dart';
import 'package:gameverse/data/repositories/post_repository.dart';
import 'package:gameverse/domain/models/post_model/post_model.dart';

enum ForumPostsState { initial, loading, success, error }

class ForumPostsViewModel extends ChangeNotifier {
  final PostRepository _postRepository;
  
  ForumPostsViewModel({required PostRepository postRepository})
      : _postRepository = postRepository;

  ForumPostsState _state = ForumPostsState.initial;
  ForumPostsState get state => _state;

  List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _gameName = '';
  String get gameName => _gameName;

  Future<void> loadPostsForGame(String gameId, String gameName) async {
    try {
      _state = ForumPostsState.loading;
      _gameName = gameName;
      notifyListeners();

      _posts = await _postRepository.getPostsForGame(gameId);
      _state = ForumPostsState.success;
    } catch (e) {
      _state = ForumPostsState.error;
      _errorMessage = 'Failed to load posts: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<void> createPost(String gameId, String content, String authorId) async {
    final newPost = PostModel(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      content: content,
      createdAt: DateTime.now(),
      upvotes: 0,
      forumId: 'forum_$gameId',
      authorId: authorId,
      commentsId: [],
    );

    await _postRepository.createPost(newPost);
    _posts.insert(0, newPost);
    notifyListeners();
  }

  void upvotePost(String postId) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      _posts[postIndex] = _posts[postIndex].copyWith(
        upvotes: _posts[postIndex].upvotes + 1,
      );
      notifyListeners();
    }
  }
}