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

  final Map<String, bool> _commentRecommendStatuses = {};
  Map<String, bool> get commentRecommendStatuses => _commentRecommendStatuses;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isPostRecommended = false;
  bool get isPostRecommended => _isPostRecommended;

  Future<void> loadPost(String postId) async {
    try {
      _state = PostState.loading;
      notifyListeners();

      _post = await _postRepository.getPost(postId);
      if (_post != null) {
        _comments = await _commentRepository.getComments(postId);
        updatePostRecommendStatus();
        for (final comment in _comments) {
          _commentRecommendStatuses[comment.commentId] = await _commentRepository.recommendStatus(_authRepository.accessToken, comment.commentId);
        }
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
      username: '',
      commentId: '0',
      userId: authorId,
      postId: _post != null ? _post!.postId : '',
      content: content,
      recommend: 0,
      commentDate: DateTime.now()
    );

    final newCommentId = await _commentRepository.addComment(_authRepository.accessToken, newComment);
    final realNewComment = await _commentRepository.getComment(newCommentId);
    if (realNewComment != null) {
      _comments.insert(0, realNewComment);
      notifyListeners();
    }
    notifyListeners();
  }

  void upvotePost() async {
    if (_post != null) {
      await _postRepository.recommendPost(_authRepository.accessToken, _post!.postId);
      _post = await _postRepository.getPost(_post!.postId);
      updatePostRecommendStatus();

      notifyListeners();
    }
  }

  void recommendComment(String commentId) async {
    await _commentRepository.recommendComment(_authRepository.accessToken, commentId);
    updateCommentRecommendStatuses(commentId);
    
    final idx = _comments.indexWhere((element) => element.commentId == commentId);
    if (idx != -1) {
      final reloadedComment = await _commentRepository.getComment(commentId);
      if (reloadedComment != null) {
        _comments[idx] = reloadedComment;
      }
    }

    notifyListeners();
  }

  void updateCommentRecommendStatuses(String commentId) async {
    if (!isLoggedIn()) {
      _commentRecommendStatuses[commentId] = false;
    } else {
      _commentRecommendStatuses[commentId] = await _commentRepository.recommendStatus(_authRepository.accessToken, commentId);
    }
    notifyListeners();
  }

  void updatePostRecommendStatus() async {
    if (!isLoggedIn()) {
      _isPostRecommended = false;
    } else {
      _isPostRecommended = await _postRepository.recommendStatus(_authRepository.accessToken, _post!.postId);
    }
    notifyListeners();
  }
}