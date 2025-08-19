import 'package:gameverse/data/services/game_api_client.dart';
import 'package:gameverse/domain/models/play_time_model/play_time_model.dart';
import 'package:gameverse/utils/response.dart';


class PlaytimeRepository {

  Future<List<PlayTimeModel>> getPlaytimeSessions({
    required String token,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final Response response = await GameApiClient().getPlaytimeSessions(token, startDate, endDate);
      if (response.code == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => PlayTimeModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load playtime sessions: ${response.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch playtime data: $e');
    }
  }
  
  Future<void> addPlaytimeSession({
    required String token,
    required DateTime begin,
    required DateTime end,
  }) async {
    try {
      final Response response = await GameApiClient().addPlaytimeSession(token, begin, end);

      if (response.code != 200) {
        throw Exception('Failed to add playtime session: ${response.message}');
      }
    } catch (e) {
      throw Exception('Failed to add playtime session: $e');
    }
  }
}