import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:gameverse/config/spacing_config.dart';
// import 'package:gameverse/domain/models/game_model/game_model.dart';

import '../view_model/game_details_viewmodel.dart';
import 'game_details_layout.dart';


class GameDetailsScreen extends StatefulWidget {
  final String gameId;

  const GameDetailsScreen({
    super.key,
    required this.gameId,
  });

  @override
  State<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GameDetailsViewModel>(context, listen: false).loadGameDetails(widget.gameId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<GameDetailsViewModel>(
        builder: (context, gameDetailsViewModel, child) {
          return GameDetailsLayout(gameId: widget.gameId);
        },
      ),
    );
  }
}