import 'package:flutter/material.dart';
import 'package:gameverse/data/repositories/auth_repository.dart';
import 'package:gameverse/data/repositories/post_repository.dart';
import 'package:gameverse/domain/models/post_model/post_model.dart';

enum ForumPostsState { initial, loading, success, error }

class ForumPostsViewModel extends ChangeNotifier {
  final PostRepository _postRepository;
  final AuthRepository _authRepository;
  
  ForumPostsViewModel({
    required PostRepository postRepository,
    required AuthRepository authRepository
  })
      : _postRepository = postRepository,
        _authRepository = authRepository;

  bool isLoggedIn() {
    return _authRepository.isAuthenticated;
  }

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

      _posts = await _postRepository.searchPosts(
        gameId,
        '',
        PostSortCriteria.date,
        limit: 20
      );
      _state = ForumPostsState.success;
    } catch (e) {
      _state = ForumPostsState.error;
      _errorMessage = 'Failed to load posts: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<void> createPost(String gameId, String title, String content, String authorId) async {
    final newPost = PostModel(
      postId: '0',              // this is generated on server side
      title: title,
      content: content,
      createdAt: DateTime.now(),
      upvotes: 0,
      forumId: gameId,
      authorId: authorId,
      commentsCount: 0,
    );

    final newPostId = await _postRepository.createPost(
      _authRepository.accessToken,
      newPost
    );
    final realNewPost = await _postRepository.getPost(newPostId);
    if (realNewPost != null) {
      _posts.insert(0, realNewPost);
      notifyListeners();
    }
  }

  void upvotePost(String postId) {
    final postIndex = _posts.indexWhere((post) => post.postId == postId);
    if (postIndex != -1) {
      _posts[postIndex] = _posts[postIndex].copyWith(
        upvotes: _posts[postIndex].upvotes + 1,
      );
      notifyListeners();
    }
  }
}