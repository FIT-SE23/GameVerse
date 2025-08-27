import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'use_cases/buy_game_csv.dart' as buy_game_csv;
import 'use_cases/advanced_search.dart' as advanced_search;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  group('Integration Tests', () {
    // buy_game_csv.runTest();
    // advanced_search.runTest();
  });
}
