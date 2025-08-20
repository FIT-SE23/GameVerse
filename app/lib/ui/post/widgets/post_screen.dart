import 'package:flutter/material.dart';
import 'package:gameverse/domain/models/comment_model/comment_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:gameverse/ui/post/view_model/post_viewmodel.dart';

import 'package:gameverse/config/spacing_config.dart';
import 'package:gameverse/config/app_theme.dart';

class PostScreen extends StatefulWidget {
  final String postId;

  const PostScreen({
    super.key,
    required this.postId,
  });

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostViewModel>(context, listen: false).loadPost(widget.postId);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<PostViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.state == PostState.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.state == PostState.error || viewModel.post == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  viewModel.errorMessage.isNotEmpty
                      ? viewModel.errorMessage
                      : 'Post not found',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          );
        }

        final post = viewModel.post!;

        return SingleChildScrollView(
          child: Padding(
            padding: getNegativeSpacePadding(context),
            child: Column(
              children: [
                const SizedBox(height: 64),
                // Post content
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.currentThemeColors(theme.brightness).getShell,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Author and date
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: theme.colorScheme.primary,
                            radius: 16,
                            child: Text(
                              post.authorId[0].toUpperCase(),
                              style: TextStyle(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User ${post.authorId.substring(0, 4)}',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                _formatDate(post.createdAt),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Post content
                      Text(
                        post.content,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Post actions
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (Provider.of<PostViewModel>(context, listen: false).isLoggedIn()) {
                                viewModel.upvotePost();
                              } else {
                                context.push('/login');
                              }                              
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: theme.colorScheme.outline),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    viewModel.isPostRecommended ? Icons.thumb_up : Icons.thumb_up_outlined,
                                    size: 18,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${post.upvotes}',
                                    style: TextStyle(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: 18,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${viewModel.comments.length} Comments',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                                
                // Add comment section
                if (Provider.of<PostViewModel>(context, listen: false).isLoggedIn())
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add a comment',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _commentController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Write your comment...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            if (_commentController.text.isNotEmpty) {
                              viewModel.addComment(
                                _commentController.text,
                                'current_user',
                              );
                              _commentController.clear();
                            }
                          },
                          child: const Text('Post Comment'),
                        ),
                      ],
                    ),
                  ),
                if (!Provider.of<PostViewModel>(context, listen: false).isLoggedIn())
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        const SizedBox(height: 64),
            
                        Icon(
                          Icons.forum_outlined,
                          size: 60,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Join the conversation',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        OutlinedButton(
                          onPressed: () => context.push('/login'),
                          child: const Text(
                            'Log in'
                          )
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => context.push('/signup'),
                          child: const Text(
                            'Sign up'
                          ),
                        ),
            
                        const SizedBox(height: 64)
                      ],
                    ),
                  ),
                                
                // Comments list
                if (viewModel.comments.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comments (${viewModel.comments.length})',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: viewModel.comments.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final comment = viewModel.comments[index];
                            return _CommentCard(
                              comment: comment,
                              viewModel: viewModel,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

String _formatDate(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime) - const Duration(hours: 7);

  if (difference.inDays > 30) {
    return dateTime.toString().split(' ')[0];
  }

  if (difference.inDays > 0) {
    return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
  } else {
    return 'Just now';
  }
}

class _CommentCard extends StatelessWidget {
  final CommentModel comment;
  final PostViewModel viewModel;

  const _CommentCard({
    required this.comment,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comment header
          Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.secondary,
                radius: 14,
                child: Text(
                  'U',
                  style: TextStyle(
                    color: theme.colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'User ${comment.userId.substring(0, 4)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(comment.commentDate),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            comment.content,
            style: theme.textTheme.bodyMedium,
          ),

          const SizedBox(height: 12),

          InkWell(
            onTap: () {
              if (Provider.of<PostViewModel>(context, listen: false).isLoggedIn()) {
                viewModel.recommendComment(comment.commentId);
              } else {
                context.push('/login');
              }                              
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    (viewModel.commentRecommendStatuses[comment.commentId] ?? false) ? Icons.thumb_up : Icons.thumb_up_outlined,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${comment.recommend}',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}