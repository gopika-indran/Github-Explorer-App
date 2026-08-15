import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/repo_list_provider.dart';
import '../utils/app_theme.dart';
import '../utils/navigation_helper.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/repo_card.dart';
import '../widgets/state_illustration.dart';

class RepositoriesScreen extends StatelessWidget {
  const RepositoriesScreen({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RepoListProvider>(
      create: (_) => RepoListProvider()..fetchRepos(username),
      child: _RepositoriesView(username: username),
    );
  }
}

class _RepositoriesView extends StatelessWidget {
  const _RepositoriesView({required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Repositories')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SortRow(),
              const SizedBox(height: 14),
              Expanded(
                child: Consumer<RepoListProvider>(
                  builder: (context, provider, _) {
                    switch (provider.state) {
                      case RepoViewState.loading:
                        return StateIllustration.loading(
                          message: 'Loading repositories…',
                        );
                      case RepoViewState.error:
                        return StateIllustration.genericError(
                          message: provider.errorMessage ?? 'Something went wrong.',
                          onRetry: () => provider.fetchRepos(username),
                        );
                      case RepoViewState.empty:
                        return StateIllustration.empty(
                          title: 'No Repositories',
                          message: 'This user has no public repositories yet.',
                        );
                      case RepoViewState.loaded:
                        final repos = provider.repos;
                        return RefreshIndicator(
                          color: AppTheme.accentSolid,
                          backgroundColor: AppTheme.surface,
                          onRefresh: () => provider.fetchRepos(username),
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 24),
                            itemCount: repos.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (context, index) => RepoCard(repo: repos[index]),
                          ),
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 1,
        onTap: (index) => handleBottomNavTap(context, index, currentIndex: 1),
      ),
    );
  }
}

class _SortRow extends StatelessWidget {
  const _SortRow();

  @override
  Widget build(BuildContext context) {
    return Consumer<RepoListProvider>(
      builder: (context, provider, _) {
        return Row(
          children: [
            const Text(
              'Sort by',
              style: TextStyle(
                fontSize: 13.5,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  children: [
                    _SortButton(
                      label: 'Stars',
                      selected: provider.sortOption == RepoSortOption.stars,
                      onTap: () => provider.setSortOption(RepoSortOption.stars),
                    ),
                    _SortButton(
                      label: 'Recently Updated',
                      selected: provider.sortOption == RepoSortOption.recentlyUpdated,
                      onTap: () => provider.setSortOption(RepoSortOption.recentlyUpdated),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: selected ? AppTheme.accentSolid : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
