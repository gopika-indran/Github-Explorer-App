import 'package:flutter/material.dart';

import '../utils/app_theme.dart';
import '../utils/navigation_helper.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/state_illustration.dart';

class RepositoriesPlaceholderScreen extends StatelessWidget {
  const RepositoriesPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Repositories')),
      body: SafeArea(
        child: StateIllustration(
          icon: Icons.folder_off_rounded,
          title: 'No Profile Selected',
          message: 'Search a GitHub username first to browse their repositories.',
          actionLabel: 'Go to Search',
          onAction: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 1,
        onTap: (index) => handleBottomNavTap(context, index, currentIndex: 1),
      ),
    );
  }
}
