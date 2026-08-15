import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/user_search_provider.dart';
import 'screens/search_screen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const GithubExplorerApp());
}

class GithubExplorerApp extends StatelessWidget {
  const GithubExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserSearchProvider>(
          create: (_) => UserSearchProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'GitHub Explorer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        home: const SearchScreen(),
      ),
    );
  }
}
