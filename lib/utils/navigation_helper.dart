import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_search_provider.dart';
import '../screens/about_screen.dart';
import '../screens/repositories_placeholder_screen.dart';
import '../screens/repositories_screen.dart';
void handleBottomNavTap(BuildContext context, int index, {required int currentIndex}) {
  if (index == currentIndex) return;

  switch (index) {
    case 0:
      Navigator.of(context).popUntil((route) => route.isFirst);
      break;
    case 1:
      final user = context.read<UserSearchProvider>().user;
      if (user != null) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => RepositoriesScreen(username: user.login)),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const RepositoriesPlaceholderScreen()),
        );
      }
      break;
    case 2:
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AboutScreen()));
      break;
  }
}
