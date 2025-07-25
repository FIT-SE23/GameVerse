import 'package:gameverse/ui/game_detail/view_model/game_detail_viewmodel.dart';
import 'package:gameverse/ui/library/view_model/library_viewmodel.dart';
import 'package:gameverse/ui/profile/view_model/profile_viewmodel.dart';
import 'package:gameverse/ui/settings/view_model/settings_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:http/http.dart' as http;

import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';
import 'package:gameverse/ui/home/view_model/home_viewmodel.dart';
import 'package:gameverse/ui/shared/theme_viewmodel.dart';
// import 'package:gameverse/ui/shared/game_selectable_viewmodel.dart';

import '../data/repositories/auth_repository.dart';
import '../data/repositories/game_repository.dart';

List<SingleChildWidget> appProviders() {
  return [
    Provider(create: (_) => GameRepository(httpClient: http.Client())),
    Provider(create: (_) => AuthRepository()),

    ChangeNotifierProvider(
      create: (_) => ThemeViewModel(),
    ),
    ChangeNotifierProxyProvider<GameRepository, GameDetailViewModel>(
      create: (context) => GameDetailViewModel(
        gameRepository: Provider.of<GameRepository>(context, listen: false),
      ),
      update: (context, repository, previous)  =>
          previous ?? GameDetailViewModel(gameRepository: repository),
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
      create: (_) => SettingsViewmodel(),
    ),
    ChangeNotifierProvider(
      create: (context) => AuthViewModel(
        authRepository: Provider.of<AuthRepository>(context, listen: false),
      ),
    ),
  ];
}