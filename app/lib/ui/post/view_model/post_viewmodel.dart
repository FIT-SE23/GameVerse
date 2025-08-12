import 'package:flutter/material.dart';
import 'package:gameverse/data/repositories/post_repository.dart';
import 'package:gameverse/data/repositories/comment_repository.dart';
import 'package:gameverse/domain/models/post_model/post_model.dart';
import 'package:gameverse/domain/models/comment_model/comment_model.dart';

enum PostState { initial, loading, success, error }

class PostViewModel extends ChangeNotifier {
  final PostRepository _postRepository;
  final CommentRepository _commentRepository;
  
  PostViewModel({required PostRepository postRepository, required CommentRepository commentRepository})
      : _postRepository = postRepository,
        _commentRepository = commentRepository;

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

      _post = await _postRepository.getPostById(postId);
      if (_post != null) {
        _comments = await _commentRepository.getCommentsForPost(postId);
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
      commentId: 'comment_${DateTime.now().millisecondsSinceEpoch}',
      relatedGameId: _post!.forumId.replaceFirst('forum_', ''),
      postsId: [_post!.postId],
    );

    await _commentRepository.addComment(newComment);
    _comments.add(newComment);
    notifyListeners();
  }

  void upvotePost() {
    if (_post != null) {
      _post = _post!.copyWith(upvotes: _post!.upvotes + 1);
      notifyListeners();
    }
  }
}