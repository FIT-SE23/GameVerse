import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const d = Duration(seconds: 3);

Future<void> login(
  WidgetTester t, {
  required String email,
  required String pass,
  Duration duration = d,
}) async {
  expect(find.byKey(const ValueKey('login_button')), findsOneWidget);
  await t.tap(find.byKey(const ValueKey('login_button')));
  await t.pumpAndSettle(duration);

  await t.enterText(find.byKey(const ValueKey('email_field')), email);
  await t.enterText(find.byKey(const ValueKey('password_field')), pass);

  await t.tap(find.byKey(const ValueKey('confirm_login_button')));
  await t.pumpAndSettle(duration);
}

Future<void> openGamesInPopular(WidgetTester t, List<String> games, {Duration duration = d}) async {
  final uniqueGames = <String>{...games}.toList();
  if (uniqueGames.isEmpty) return;

  final section = find.byKey(const ValueKey('popular_games_section'));

  for (final game in uniqueGames) {
    final bigCard = find.byKey(ValueKey('big_card_$game'));

    if (!t.any(bigCard)) {
      expect(section, findsOneWidget, reason: 'Popular Games section not found');

      final title = find.descendant(
        of: section,
        matching: find.byKey(ValueKey(game)),
      );
      expect(title, findsOneWidget, reason: 'Cant find $game in Popular Games');

      await t.tap(title);
      await t.pumpAndSettle(duration);

      expect(bigCard, findsOneWidget,
          reason: 'Big card for $game not found after selecting title');
    }

    await addGameToCart(t, game, duration: duration);
  }
}

Future<void> addGameToCart(
  WidgetTester t,
  String game, {
  Duration duration = d,
}) async {
  final big = find.byKey(ValueKey('big_card_$game'));
  expect(big, findsOneWidget, reason: 'Big card for $game is not available');
  await t.tap(big);
  await t.pumpAndSettle(duration);

  final addBtn = find.byKey(const ValueKey('add_to_cart_button'));
  if (t.any(addBtn)) {
    await t.tap(addBtn);
    await t.pumpAndSettle(duration);
  }

  expect(find.byKey(const ValueKey('go_back_button')), findsOneWidget);
  await t.tap(find.byKey(const ValueKey('go_back_button')));
  await t.pumpAndSettle(duration);
}

Future<void> openCart(WidgetTester t, {Duration duration = d}) async {
  expect(find.byKey(const ValueKey('user_menu')), findsOneWidget);
  await t.tap(find.byKey(const ValueKey('user_menu')));
  await t.pumpAndSettle(duration);

  expect(find.byKey(const ValueKey('menu_transaction')), findsOneWidget);
  await t.tap(find.byKey(const ValueKey('menu_transaction')));
  await t.pumpAndSettle(duration);
}

Future<void> proceedCheckout(
  WidgetTester t,
  String method, {
  Duration duration = d,
}) async {
  expect(find.byKey(const ValueKey('checkout_button')), findsOneWidget);
  await t.tap(find.byKey(const ValueKey('checkout_button')));
  await t.pumpAndSettle(duration);

  final m = method.trim().toLowerCase();
  final methodKey = (m == 'paypal')
      ? const ValueKey('paypal_method')
      : const ValueKey('vnpay_method');
  expect(find.byKey(methodKey), findsOneWidget,
      reason: 'Payment method "$method" not found');

  await t.tap(find.byKey(methodKey));
  await t.pumpAndSettle(duration);

  await t.tap(find.byKey(const ValueKey('pay_button')));
  await t.pumpAndSettle(duration);

  await t.tap(find.byKey(const ValueKey('gateway_button')));
  await t.pumpAndSettle(duration);
}

Future<void> closeGatewayAndReload(WidgetTester t, {Duration duration = d}) async {
  final barriers = find.byType(ModalBarrier);
  expect(barriers, findsWidgets, reason: 'No modal barrier to close (gateway)');
  await t.tapAt(t.getCenter(barriers.last));
  await t.pumpAndSettle(duration);

  await t.tap(find.byKey(const ValueKey('reload_button')));
  await t.pumpAndSettle(duration);
}

Future<void> openOwned(WidgetTester t, {Duration duration = d}) async {
  await t.tap(find.byKey(const ValueKey('library_button')));
  await t.pumpAndSettle(duration);

  await t.tap(find.byKey(const ValueKey('owned_tab')));
  await t.pumpAndSettle(duration);
}