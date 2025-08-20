import 'package:flutter/material.dart';
import 'package:gameverse/data/repositories/post_repository.dart';
import 'package:gameverse/data/repositories/comment_repository.dart';

import 'package:gameverse/data/repositories/auth_repository.dart';
import 'package:gameverse/domain/models/post_model/post_model.dart';
import 'package:gameverse/domain/models/comment_model/comment_model.dart';

enum PostState { initial, loading, success, error }

class PostViewModel extends ChangeNotifier {
  final PostRepository _postRepository;
  final CommentRepository _commentRepository;
  final AuthRepository _authRepository;
  
  PostViewModel({
    required PostRepository postRepository,
    required CommentRepository commentRepository,
    required AuthRepository authRepository
  })
      : _postRepository = postRepository,
        _commentRepository = commentRepository,
        _authRepository = authRepository;

  bool isLoggedIn() {
    return _authRepository.isAuthenticated;
  }

  PostState _state = PostState.initial;
  PostState get state => _state;

  PostModel? _post;
  PostModel? get post => _post;

  List<CommentModel> _comments = [];
  List<CommentModel> get comments => _comments;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> loadPost(String postId) async {
    try {
      _state = PostState.loading;
      notifyListeners();

      _post = await _postRepository.getPost(postId);
      if (_post != null) {
        _comments = await _commentRepository.getComments(postId);
        _state = PostState.success;
      } else {
        _state = PostState.error;
        _errorMessage = 'Post not found';
      }
    } catch (e) {
      _state = PostState.error;
      _errorMessage = 'Failed to load post: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<void> addComment(String content, String authorId) async {
    if (_post == null) return;

    final newComment = CommentModel(
      commentId: '0',
      userId: authorId,
      postId: _post != null ? _post!.postId : '',
      content: content,
      recommend: 0,
      commentDate: DateTime.now()
    );

    await _commentRepository.addComment(_authRepository.accessToken, newComment);
    _comments.add(newComment);
    notifyListeners();
  }

  void upvotePost() async {
    if (_post != null) {
      await _postRepository.recommendPost(_authRepository.accessToken, _post!.postId);
      _post = await _postRepository.getPost(_post!.postId);

      notifyListeners();
    }
  }
}