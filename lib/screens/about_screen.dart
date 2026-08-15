import 'package:flutter/material.dart';

import '../utils/app_theme.dart';
import '../utils/navigation_helper.dart';
import '../widgets/app_bottom_nav.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('About')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          children: [
            Center(
              child: Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  gradient: AppTheme.accentGradient,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(Icons.code_rounded, color: Colors.white, size: 38),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'GitHub Explorer',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Version 1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 22),
            const Text(
              'Search any GitHub username to view their profile — avatar, bio, '
              'followers, and following — then dive into their public '
              'repositories, sortable by stars or last updated.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.6),
            ),
            const SizedBox(height: 28),
            const _InfoTile(
              icon: Icons.cloud_outlined,
              title: 'Data source',
              subtitle: 'Public GitHub REST API (api.github.com), unauthenticated.',
            ),
            const _InfoTile(
              icon: Icons.bolt_rounded,
              title: 'Built with',
              subtitle: 'Flutter, Provider for state management, http for networking.',
            ),
            const _InfoTile(
              icon: Icons.history_rounded,
              title: 'Recent searches',
              subtitle: 'Your last 5 searches are stored on this device only.',
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 2,
        onTap: (index) => handleBottomNavTap(context, index, currentIndex: 2),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppTheme.accentBlue),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12.5, color: AppTheme.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
