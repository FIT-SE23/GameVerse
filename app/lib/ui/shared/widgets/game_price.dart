import 'package:flutter/material.dart';

import 'package:gameverse/domain/models/game_model/game_model.dart';

class GamePrice extends StatelessWidget {
  final GameModel game;
  final TextStyle textStyle;

  const GamePrice({
    super.key,
    required this.game,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (game.price > 0) {
      if (game.isSale!) {
        final today = DateTime.now();
        if (today.isAfter(game.saleStartDate!) && today.isBefore(game.saleEndDate!)) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Text(
                '${game.price.toInt()} VND',
                style: textStyle.copyWith(
                  decoration: TextDecoration.lineThrough,
                  decorationColor: textStyle.color,
                ),
              ),

              if (game.discountPercent != 100)
                Text(
                  '${(game.price * (100 - game.discountPercent!) / 100).toInt()} VND',
                  style: textStyle,
                )
              else
                Text(
                  'Free for now',
                  style: textStyle,
                )
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${game.price.toInt()} VND',
                style: textStyle,
              )
            ],
          );
        }
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${game.price.toInt()} VND',
              style: textStyle,
            )
          ],
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Free to Play',
          style: textStyle,
        )
      ],
    );
  }
}