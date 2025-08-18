import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:http/http.dart' as http;

import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';
import 'package:gameverse/ui/home/view_model/home_viewmodel.dart';
import 'package:gameverse/ui/shared/theme_viewmodel.dart';
import 'package:gameverse/ui/game_detail/view_model/game_details_viewmodel.dart';
import 'package:gameverse/ui/library/view_model/library_viewmodel.dart';
import 'package:gameverse/ui/profile/view_model/profile_viewmodel.dart';
import 'package:gameverse/ui/settings/view_model/settings_viewmodel.dart';
import 'package:gameverse/ui/forum_posts/view_model/forum_posts_viewmodel.dart';
import 'package:gameverse/ui/forums/view_model/forum_viewmodel.dart';
import 'package:gameverse/ui/post/view_model/post_viewmodel.dart';
import 'package:gameverse/ui/transaction/view_model/transaction_viewmodel.dart';
import 'package:gameverse/ui/publisher/view_model/publisher_viewmodel.dart';
import 'package:gameverse/ui/operator/view_model/operator_viewmodel.dart';

import 'package:gameverse/ui/advanced_search/view_model/advanced_search_viewmodel.dart';


import '../data/repositories/auth_repository.dart';
import '../data/repositories/game_repository.dart';
import '../data/repositories/forum_repository.dart';
import '../data/repositories/post_repository.dart';
import '../data/repositories/comment_repository.dart';
import '../data/repositories/transaction_repository.dart';
import '../data/repositories/operator_repository.dart';

import '../data/services/transaction_service.dart';
Future<List<SingleChildWidget>> appProviders() async {
  return [
    // Provider(create: (_) => GameRepository(httpClient: http.Client())),
    FutureProvider(create: (_) => GameRepository.fromService(), initialData: GameRepository(httpClient: http.Client())),
    Provider(create: (_) => AuthRepository()),
    Provider(create: (_) => ForumRepository()),
    Provider(create: (_) => PostRepository()),
    Provider(create: (_) => CommentRepository()),
    Provider(create: (_) => TransactionService()),
    Provider(create: (_) => TransactionRepository()),
    Provider(create: (_) => OperatorRepository()),

    // ViewModels
    ChangeNotifierProvider(
      create: (context) => AuthViewModel(
        authRepository: Provider.of<AuthRepository>(context, listen: false),
      ),
    ),
    ChangeNotifierProvider<HomeViewModel>(
      create: (context) => HomeViewModel(
        gameRepository: context.read<GameRepository>(),
      ),
    ),
    ChangeNotifierProvider<GameDetailsViewModel>(
      create: (context) => GameDetailsViewModel(
        gameRepository: context.read<GameRepository>(),
        authRepository: context.read<AuthRepository>(),
      ),
    ),
    ChangeNotifierProvider<LibraryViewModel>(
      create: (context) => LibraryViewModel(
        gameRepository: context.read<GameRepository>(),
      ),
    ),
    ChangeNotifierProvider<ForumsViewModel>(
      create: (context) => ForumsViewModel(
        forumRepository: context.read<ForumRepository>(),
      ),
    ),
    ChangeNotifierProvider<ForumPostsViewModel>(
      create: (context) => ForumPostsViewModel(
        postRepository: context.read<PostRepository>(),
      ),
    ),
    ChangeNotifierProvider<PostViewModel>(
      create: (context) => PostViewModel(
        postRepository: context.read<PostRepository>(),
        commentRepository: context.read<CommentRepository>(),
      ),
    ),
    ChangeNotifierProvider<ProfileViewModel>(
      create: (_) => ProfileViewModel(),
    ),
    ChangeNotifierProvider<SettingsViewModel>(
      create: (_) => SettingsViewModel(),
    ),
    ChangeNotifierProvider<ThemeViewModel>(
      create: (_) => ThemeViewModel(),
    ),
    ChangeNotifierProvider<TransactionViewModel>(
      create: (context) => TransactionViewModel(
        transactionRepository: context.read<TransactionRepository>(),
        authRepository: context.read<AuthRepository>(),
      ),
    ),
    ChangeNotifierProvider<PublisherViewModel>(
      create: (context) => PublisherViewModel(
        gameRepository: context.read<GameRepository>(),
        authRepository: context.read<AuthRepository>(),
      ),
    ),
    ChangeNotifierProvider<AdvancedSearchViewmodel>(
      create: (context) => AdvancedSearchViewmodel(
        gameRepository: context.read<GameRepository>(),
      ),
    ),
    // Add to your existing providers list
    ChangeNotifierProvider<OperatorViewModel>(
      create: (context) => OperatorViewModel(
        operatorRepository: context.read<OperatorRepository>(),
        authRepository: context.read<AuthRepository>(),
      ),
    ),
  ];
}