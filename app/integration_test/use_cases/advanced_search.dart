import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameverse/main.dart' as app;
import 'package:gameverse/ui/shared/widgets/game_card.dart';
import 'package:gameverse/ui/shared/widgets/game_card_long.dart';

void runTest() {
  group('Advanced Search', () {
    testWidgets(
      'Scenario: Successful search',
      (WidgetTester tester) async {
        app.main([]);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        
        await tester.tap(find.byKey(const ValueKey('search_button')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.enterText(find.byKey(const ValueKey('game_title')), 'brain');
        await tester.tap(find.byKey(const ValueKey('Indie')));
        await tester.tap(find.byKey(const ValueKey('Open World')));
        await tester.pumpAndSettle(const Duration(seconds: 2));
        
        await tester.tap(find.byKey(const ValueKey('apply_filter_button')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        final gameCardPredicate = (Widget widget) => widget is GameCard || widget is GameCardLong;
        final genericGameCardFinder = find.byWidgetPredicate(gameCardPredicate);
        
        expect(genericGameCardFinder, findsWidgets, reason: 'No games exits');
        final List<Widget> gameWidgets = tester.widgetList<Widget>(genericGameCardFinder).toList();

        for (final widget in gameWidgets) {
          final dynamic gameCard = widget;
          final String gameName = gameCard.game.name; 

          final specificGameFinder = find.byKey(ValueKey(gameName));
          expect(specificGameFinder, findsOneWidget);

          await tester.tap(specificGameFinder);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          expect(find.textContaining(gameName, findRichText: true), findsOneWidget, reason: '"$gameName" not match');
          expect(find.text('Open World'), findsOneWidget, reason: '"$gameName" doesnt have tag Open World');
          expect(find.text('Indie'), findsOneWidget, reason: '"$gameName" doesnt have tag Indie');
          
          await tester.tap(find.byKey(const ValueKey('go_back_button')));
          await tester.pumpAndSettle(const Duration(seconds: 2));
        }
      },
    );
  testWidgets(
    'Scenario: Search with no matching criteria - Weird game title',
    (WidgetTester tester) async {
      app.main([]);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byKey(const ValueKey('search_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.enterText(find.byKey(const ValueKey('game_title')), '!@#%^&*()12222222222222222222121212121212121211221a'); 
      await tester.tap(find.byKey(const ValueKey('apply_filter_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3)); 

      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      expect(find.text('No games found'), findsOneWidget);
      expect(find.text('Try adjusting your filters'), findsOneWidget);
    },
  );
  });
}