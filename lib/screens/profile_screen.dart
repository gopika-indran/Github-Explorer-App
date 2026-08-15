import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/github_user.dart';
import '../providers/user_search_provider.dart';
import '../utils/app_theme.dart';
import '../utils/formatters.dart';
import '../utils/navigation_helper.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/state_illustration.dart';
import 'repositories_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _openInBrowser(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserSearchProvider>(
      builder: (context, provider, _) {
        final isLoaded = provider.state == SearchViewState.loaded && provider.user != null;
        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: isLoaded ? null : const Text('Search User'),
            actions: isLoaded
                ? [
                    IconButton(
                      icon: const Icon(Icons.ios_share_rounded),
                      onPressed: () => _openInBrowser(provider.user!.htmlUrl),
                    ),
                  ]
                : null,
          ),
          body: SafeArea(child: _buildBody(context, provider)),
          bottomNavigationBar: AppBottomNav(
            currentIndex: 0,
            onTap: (index) => handleBottomNavTap(context, index, currentIndex: 0),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, UserSearchProvider provider) {
    switch (provider.state) {
      case SearchViewState.idle:
        return const SizedBox.shrink();

      case SearchViewState.loading:
        return StateIllustration.loading(
          message: 'Fetching user data from GitHub',
        );

      case SearchViewState.error:
        final message = provider.errorMessage ?? 'Something went wrong.';
        switch (provider.errorType) {
          case SearchErrorType.notFound:
            return StateIllustration.notFound(
              message: message,
              onRetry: () => provider.searchUser(provider.lastQuery),
            );
          case SearchErrorType.network:
            return StateIllustration.network(
              message: message,
              onRetry: () => provider.searchUser(provider.lastQuery),
            );
          case SearchErrorType.api:
          case null:
            return StateIllustration.genericError(
              message: message,
              onRetry: () => provider.searchUser(provider.lastQuery),
            );
        }

      case SearchViewState.loaded:
        final user = provider.user!;
        return _ProfileBody(
          user: user,
          onViewRepos: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => RepositoriesScreen(username: user.login)),
          ),
        );
    }
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.user, required this.onViewRepos});

  final GithubUser user;
  final VoidCallback onViewRepos;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 12, 28, 24),
      child: Column(
        children: [
          Stack(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: user.avatarUrl,
                  width: 116,
                  height: 116,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 116,
                    height: 116,
                    color: AppTheme.surfaceAlt,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 116,
                    height: 116,
                    color: AppTheme.surfaceAlt,
                    child: const Icon(Icons.person, color: AppTheme.textSecondary, size: 40),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.background, width: 2),
                  ),
                  child: const Icon(Icons.code_rounded, size: 17, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user.displayName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '@${user.login}',
            style: const TextStyle(
              fontSize: 14.5,
              color: AppTheme.accentBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (user.location != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.place_outlined, size: 15, color: AppTheme.textSecondary),
                const SizedBox(width: 4),
                Text(
                  user.location!,
                  style: const TextStyle(fontSize: 13.5, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ],
          if (user.bio != null && user.bio!.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              user.bio!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimary,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 26),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                _StatColumn(value: formatCompactNumber(user.followers), label: 'Followers'),
                _statDivider(),
                _StatColumn(value: formatCompactNumber(user.following), label: 'Following'),
                _statDivider(),
                _StatColumn(value: formatCompactNumber(user.publicRepos), label: 'Repositories'),
              ],
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppTheme.accentGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: ElevatedButton.icon(
                onPressed: onViewRepos,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                icon: const Icon(Icons.folder_open_rounded, size: 19),
                label: const Text('View Repositories'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statDivider() => Container(width: 1, height: 34, color: AppTheme.border);
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11.5, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}
