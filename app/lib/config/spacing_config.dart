import 'package:flutter/material.dart';
import 'dart:math';

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double negativeSpaceWidth(BuildContext context) {
  return max(screenWidth(context) / 8, 16);
}

EdgeInsets getNegativeSpacePadding(BuildContext context) {
  return EdgeInsets.symmetric(horizontal: negativeSpaceWidth(context));
}

const double spaceCardHorizontal = 16;
const double minCardWidth = 160;
const int maxCardPerRow = 4;
const int minCardPerRow = 2;

const double backgroundKeyArtHeight = 640;

int cardPerRow(BuildContext context) {
  int cardPerRow = min(((screenWidth(context) - 2 * negativeSpaceWidth(context) + spaceCardHorizontal) / (minCardWidth + spaceCardHorizontal)).toInt(), maxCardPerRow);
  cardPerRow = max(cardPerRow, minCardPerRow);
  return cardPerRow;
}

double cardWidth(BuildContext context) {
  int cardPerRow = min(((screenWidth(context) - 2 * negativeSpaceWidth(context) + spaceCardHorizontal) / (minCardWidth + spaceCardHorizontal)).toInt(), maxCardPerRow);
  cardPerRow = max(cardPerRow, minCardPerRow);
  return (screenWidth(context) - 2 * negativeSpaceWidth(context) - (cardPerRow - 1) * spaceCardHorizontal) / cardPerRow;
}