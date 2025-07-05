import 'package:flutter/material.dart';
import 'package:gameverse/data/repositories/auth_repository.dart';
import 'package:gameverse/ui/shared/theme_viewmodel.dart';
import 'package:gameverse/routing/router.dart';
import 'package:gameverse/ui/shared/widgets/main_layout.dart';
import 'package:gameverse/config/config.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  // Initialize any required services or configurations
  await AuthRepository.initializeSupabase();

  runApp(MultiProvider(
    providers: appProviders(),
    child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeViewModel themeProvider = Provider.of<ThemeViewModel>(context);

    return MaterialApp(
      title: 'GameVerse',
      theme: themeProvider.isDarkMode
          ? AppTheme.darkTheme
          : AppTheme.lightTheme,
      onGenerateRoute: AppRouter.onGenerateRoute,
      // initialRoute: AppRouter.homeRoute,
      debugShowCheckedModeBanner: false,
      home: const MainLayout(initialIndex: 0),
    );
  }
}