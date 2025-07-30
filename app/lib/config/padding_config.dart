import 'package:flutter/material.dart';
import 'dart:math';

EdgeInsets getNegativeSpacePadding(BuildContext context) {
  return EdgeInsets.symmetric(horizontal: max(MediaQuery.of(context).size.width / 8, 32));
} 