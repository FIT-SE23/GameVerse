import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'use_cases/buy_game.dart' as buy_game;
import 'use_cases/advanced_search.dart' as advanced_search;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  group('Integration Tests', () {
    advanced_search.runTest();
  });
}