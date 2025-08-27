import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:csv/csv.dart';
import 'package:gameverse/main.dart' as app;
import 'helper.dart';

class CsvCase {
  final String email, pass, payment;
  final List<String> games;
  final bool success;
  CsvCase(this.email, this.pass, this.games, this.payment, this.success);
}

List<CsvCase> loadCases(String path) {
  final file = File(path);
  if (!file.existsSync()) return [];

  final rows = const CsvToListConverter().convert(file.readAsStringSync());
  final cases = <CsvCase>[];

  for (final row in rows.skip(1)) {
    if (row.isEmpty || row[0].toString().trim().isEmpty) continue;

    final email = row[0].toString().trim();
    final password = (row.length > 1 ? row[1] : '').toString().trim();

    final lastIdx = row.length - 1;
    final paymentIdx = lastIdx - 1;

    final successStr = (lastIdx >= 0 ? row[lastIdx] : 'true')
        .toString()
        .trim()
        .toLowerCase();
    final success = ['true', '1', 'yes', 'y'].contains(successStr);

    final payment = (paymentIdx >= 0 ? row[paymentIdx] : 'vnpay')
        .toString()
        .trim();

    final games = <String>[];
    for (var i = 2; i < paymentIdx && games.length < 5; i++) {
      final g = row[i].toString().trim();
      if (g.isNotEmpty) games.add(g);
    }

    cases.add(CsvCase(email, password, games, payment, success));
  }
  return cases;
}

void runTest() {
  final cases = loadCases('integration_test/data/buy_game_scenarios.csv');

  group('Buy Game', () {
    for (var i = 0; i < cases.length; i++) {
      final c = cases[i];

      testWidgets('CSV[$i] ${c.success ? "PASSED" : "FAILED"}', (t) async {
        final bool mockSuccess = (i == 0)
            ? true
            : (i == 1)
            ? false
            : c.success;
        setTestMode(enabled: true, success: mockSuccess);
        addTearDown(() => setTestMode(enabled: false, success: true));

        app.main([]);
        await t.pumpAndSettle(d);

        await login(t, email: c.email, pass: c.pass);

        if (c.games.isNotEmpty) {
          await openGamesInPopular(t, c.games);
        }

        await openCart(t);
        for (final g in c.games) {
          expect(find.text(g), findsOneWidget);
        }

        await proceedCheckout(t, c.payment);
        await closeGatewayAndReload(t);

        if (mockSuccess) {
          expect(find.text('Your Cart is Empty'), findsOneWidget);

          await openOwned(t);
          for (final g in c.games) {
            expect(find.text(g), findsOneWidget);
          }
        } else {
          expect(find.text('Your Cart is Empty'), findsNothing);

          for (final g in c.games) {
            expect(find.text(g), findsOneWidget);
          }

          await openOwned(t);
          for (final g in c.games) {
            expect(find.text(g), findsNothing);
          }
        }
      });
    }
  });
}
