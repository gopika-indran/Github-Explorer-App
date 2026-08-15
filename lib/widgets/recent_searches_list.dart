import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class RecentSearchesList extends StatelessWidget {
  const RecentSearchesList({
    super.key,
    required this.searches,
    required this.onTap,
    this.onClearAll,
  });

  final List<String> searches;
  final ValueChanged<String> onTap;
  final VoidCallback? onClearAll;

  static const List<Color> _avatarPalette = [
    Color(0xFF5B7CFA),
    Color(0xFF8A5CF6),
    Color(0xFFEF5A6F),
    Color(0xFFF3B94E),
    Color(0xFF3FB950),
  ];

  @override
  Widget build(BuildContext context) {
    if (searches.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text(
              'Recent Searches',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const Spacer(),
            if (onClearAll != null)
              InkWell(
                onTap: onClearAll,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                  child: Text(
                    'Clear all',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accentSolid,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: searches.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final username = searches[index];
            final color = _avatarPalette[index % _avatarPalette.length];
            return InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => onTap(username),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.history_rounded, size: 16, color: AppTheme.textMuted),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: color.withOpacity(0.22),
                      child: Text(
                        username.isNotEmpty ? username[0].toUpperCase() : '?',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        username,
                        style: const TextStyle(
                          fontSize: 14.5,
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, size: 20, color: AppTheme.textMuted),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
