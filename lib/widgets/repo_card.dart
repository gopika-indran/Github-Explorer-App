import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/github_repo.dart';
import '../utils/app_theme.dart';
import '../utils/formatters.dart';
import '../utils/language_colors.dart';

class RepoCard extends StatelessWidget {
  const RepoCard({super.key, required this.repo});

  final GithubRepo repo;

  Future<void> _openRepo() async {
    final uri = Uri.tryParse(repo.htmlUrl);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: _openRepo,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      repo.name,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (repo.fork)
                    const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Icon(Icons.fork_right_rounded,
                          size: 15, color: AppTheme.textMuted),
                    ),
                  const Icon(Icons.bookmark_border_rounded,
                      size: 19, color: AppTheme.textMuted),
                ],
              ),
              if (repo.description != null && repo.description!.trim().isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  repo.description!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, size: 15, color: AppTheme.star),
                      const SizedBox(width: 3),
                      Text(
                        formatCompactNumber(repo.stargazersCount),
                        style: const TextStyle(fontSize: 12.5, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                  if (repo.language != null) ...[
                    const SizedBox(width: 14),
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: LanguageColors.of(repo.language),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      repo.language!,
                      style: const TextStyle(fontSize: 12.5, color: AppTheme.textSecondary),
                    ),
                  ],
                  const Spacer(),
                  Text(
                    formatRelativeDate(repo.updatedAt),
                    style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
