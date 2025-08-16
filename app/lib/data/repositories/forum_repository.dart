import 'package:flutter/foundation.dart';
import 'package:gameverse/domain/models/forum_model/forum_model.dart';
import 'package:gameverse/data/services/forum_api_client.dart';
import 'package:gameverse/utils/response.dart';

class ForumRepository {
  
  Future<List<ForumModel>> getGamesWithForums() async {
    try {
      List<String> forumIds = [];
      final Response response = await ForumApiClient().getAllForums();
      // Check if the response is successful
      if (response.code == 200) {
        forumIds = List<String>.from(response.data.map((forum) => forum['forumid'] as String));
      }
      else {
        throw Exception('Failed to load forums: ${response.message}');
      }

      // Get forum details for each forum ID
      List<ForumModel> forums = [];
      for (String forumId in forumIds) {
        final forumResponse = await ForumApiClient().getForum(forumId);
        
        // Check if the forum response is successful
        if (forumResponse.code == 200) {
          forums.add(ForumModel.fromJson(forumResponse.data[0]));
        } else {
          throw Exception('Failed to load forum: ${forumResponse.message}');
        }
      }
      return forums;
    } catch (e) {
      debugPrint('Error fetching forums: $e');
      throw Exception('Failed to load forums: $e');
    }
  }
}