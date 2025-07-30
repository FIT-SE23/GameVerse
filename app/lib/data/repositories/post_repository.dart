import 'package:http/http.dart' as http;

import 'package:gameverse/domain/models/post_model/post_model.dart';

class PostRepository {
  final http.Client client;

  PostRepository({http.Client? httpClient}) : client = httpClient ?? http.Client();

  Future<List<PostModel>> getPostsForGame(String gameId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _getMockPostsForGame(gameId);
  }

  Future<PostModel?> getPostById(String postId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final allPosts = [
      ..._getMockPostsForGame('1091500'),
      ..._getMockPostsForGame('730'),
      ..._getMockPostsForGame('570'),
    ];
    
    try {
      return allPosts.firstWhere((post) => post.id == postId);
    } catch (e) {
      return null;
    }
  }

  List<PostModel> _getMockPostsForGame(String gameId) {
    final now = DateTime.now();
    
    switch (gameId) {
      case '1091500': // Cyberpunk 2077
        return [
          PostModel(
            id: 'cp_post_1',
            content: 'I\'ve been experimenting with different builds and found that focusing on Cool and Intelligence stats creates an amazing stealth experience. The combination of quickhacking and silent takedowns makes you feel like a true netrunner. Here\'s my recommended build path for anyone interested in stealth gameplay...',
            createdAt: now.subtract(const Duration(hours: 2)),
            upvotes: 42,
            forumId: 'forum_1091500',
            authorId: 'user1',
            commentsId: ['cp_comment_1', 'cp_comment_2'],
          ),
          PostModel(
            id: 'cp_post_2',
            content: 'Night City is absolutely stunning! I\'ve been using photo mode to capture some incredible shots. The lighting system in this game is phenomenal, especially during the golden hour. Check out these locations for the best photos and share your own screenshots!',
            createdAt: now.subtract(const Duration(hours: 5)),
            upvotes: 28,
            forumId: 'forum_1091500',
            authorId: 'user2',
            commentsId: ['cp_comment_3'],
          ),
          PostModel(
            id: 'cp_post_3',
            content: 'After tweaking settings for weeks, I\'ve found the perfect balance between visual quality and performance. Here are my recommended settings for different RTX cards to maintain 60+ FPS with raytracing enabled. Let me know if you need help optimizing your setup!',
            createdAt: now.subtract(const Duration(days: 1)),
            upvotes: 67,
            forumId: 'forum_1091500',
            authorId: 'user3',
            commentsId: [],
          ),
        ];

      case '730': // Counter-Strike 2
        return [
          PostModel(
            id: 'cs_post_1',
            content: 'The new smoke mechanics in CS2 have completely changed how we approach site takes. Here are the essential smoke lineups for Mirage that every player should know. These smokes will help you execute perfect A and B site takes and improve your team coordination.',
            createdAt: now.subtract(const Duration(hours: 4)),
            upvotes: 89,
            forumId: 'forum_730',
            authorId: 'user4',
            commentsId: ['cs_comment_1', 'cs_comment_2'],
          ),
          PostModel(
            id: 'cs_post_2',
            content: 'After months of inconsistent aim, I developed this training routine that improved my headshot percentage by 40%. The key is consistency and focusing on muscle memory rather than just flicking to targets. Here\'s my daily routine that actually works.',
            createdAt: now.subtract(const Duration(hours: 8)),
            upvotes: 156,
            forumId: 'forum_730',
            authorId: 'user5',
            commentsId: ['cs_comment_3'],
          ),
        ];

      case '570': // Dota 2
        return [
          PostModel(
            id: 'dota_post_1',
            content: 'The latest patch has shaken up the meta significantly. After analyzing over 1000 matches, here are the heroes that are dominating each role. Pudge and Crystal Maiden are surprisingly strong in the current patch due to recent buffs.',
            createdAt: now.subtract(const Duration(hours: 6)),
            upvotes: 234,
            forumId: 'forum_570',
            authorId: 'user6',
            commentsId: ['dota_comment_1', 'dota_comment_2'],
          ),
          PostModel(
            id: 'dota_post_2',
            content: 'Good warding can single-handedly win games, but many support players place wards without strategic thinking. Here are the ward spots that provide maximum map control and help your team make better decisions throughout the match.',
            createdAt: now.subtract(const Duration(hours: 12)),
            upvotes: 178,
            forumId: 'forum_570',
            authorId: 'user7',
            commentsId: ['dota_comment_3'],
          ),
        ];

      default:
        return [];
    }
  }
  Future<void> createPost(PostModel post) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate adding a post
  }

  Future<void> deletePost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate deleting a post
  }

  Future<void> updatePost(PostModel post) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate updating a post
  }
}