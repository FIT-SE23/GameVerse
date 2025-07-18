import 'package:flutter/material.dart';

class GameGrid extends StatelessWidget {
  final int selectedIndex;
  
  const GameGrid({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Theme.of(context).primaryColor,
      child: Text("Hello")
    );
  }
}