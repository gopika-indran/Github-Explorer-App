import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_search_provider.dart';
import '../utils/app_theme.dart';
import '../utils/navigation_helper.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/recent_searches_list.dart';
import 'profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _runSearch(String username) {
    if (username.trim().isEmpty) return;
    _focusNode.unfocus();
    context.read<UserSearchProvider>().searchUser(username);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'GitHub ',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: ShaderMask(
                        shaderCallback: (bounds) =>
                            AppTheme.accentGradient.createShader(bounds),
                        child: const Text(
                          'Explorer',
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Search GitHub users and explore their repositories',
                style: TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: const TextStyle(color: AppTheme.textPrimary),
                      textInputAction: TextInputAction.search,
                      onSubmitted: _runSearch,
                      decoration: const InputDecoration(
                        hintText: 'torvalds',
                        prefixIcon: Icon(Icons.search_rounded, color: AppTheme.textMuted),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => _runSearch(_controller.text),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: AppTheme.accentGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.search_rounded, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Expanded(
                child: Consumer<UserSearchProvider>(
                  builder: (context, provider, _) {
                    if (provider.recentSearches.isEmpty) {
                      return const _EmptyRecentHint();
                    }
                    return SingleChildScrollView(
                      child: RecentSearchesList(
                        searches: provider.recentSearches,
                        onTap: (username) {
                          _controller.text = username;
                          _runSearch(username);
                        },
                        onClearAll: provider.clearRecentSearches,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
        onTap: (index) => handleBottomNavTap(context, index, currentIndex: 0),
      ),
    );
  }
}

class _EmptyRecentHint extends StatelessWidget {
  const _EmptyRecentHint();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: const [
          Icon(Icons.travel_explore_rounded, size: 52, color: AppTheme.border),
          SizedBox(height: 14),
          Text(
            'Search any GitHub username to view\ntheir profile and repositories.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13.5, height: 1.5),
          ),
        ],
      ),
    );
  }
}
