import 'package:gameverse/ui/game_detail/view_model/game_viewmodel.dart';
import 'package:gameverse/ui/library/view_model/library_viewmodel.dart';
import 'package:gameverse/ui/profile/view_model/profile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:http/http.dart' as http;

import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';
import 'package:gameverse/ui/home/view_model/home_viewmodel.dart';
import 'package:gameverse/ui/shared/theme_viewmodel.dart';

import '../data/repositories/auth_repository.dart';
import '../data/repositories/game_repository.dart';

List<SingleChildWidget> appProviders() {
  return [
    Provider(create: (_) => GameRepository(httpClient: http.Client())),
    Provider(create: (_) => AuthRepository()),

    ChangeNotifierProvider(
      create: (_) => ThemeViewModel(),
    ),
    ChangeNotifierProxyProvider<GameRepository, GameViewModel>(
      create: (context) => GameViewModel(
        gameRepository: Provider.of<GameRepository>(context, listen: false),
      ),
      update: (context, repository, previous)  =>
          previous ?? GameViewModel(gameRepository: repository),
    ),
    ChangeNotifierProxyProvider<GameRepository, HomeViewModel>(
      create: (context) => HomeViewModel(
        gameRepository: Provider.of<GameRepository>(context, listen: false),
      ),
      update: (context, repository, previous)  =>
          previous ?? HomeViewModel(gameRepository: repository),
    ),
    ChangeNotifierProxyProvider<GameRepository, LibraryViewModel>(
      create: (context) => LibraryViewModel(
        gameRepository: Provider.of<GameRepository>(context, listen: false),
      ),
      update: (context, repository, previous)  =>
          previous ?? LibraryViewModel(gameRepository: repository),
    ),
    ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
    ),
    ChangeNotifierProvider(
      create: (context) => AuthViewModel(
        authRepository: Provider.of<AuthRepository>(context, listen: false),
      ),
    ),
  ];
}