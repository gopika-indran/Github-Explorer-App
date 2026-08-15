import 'package:flutter/material.dart';

import '../utils/app_theme.dart';
class StateIllustration extends StatelessWidget {
  const StateIllustration({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.iconColor = AppTheme.accentSolid,
    this.showProgress = false,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color iconColor;
  final bool showProgress;
  final String? actionLabel;
  final VoidCallback? onAction;

  factory StateIllustration.loading({
    String title = 'Loading...',
    String message = 'Fetching data from GitHub',
  }) {
    return StateIllustration(
      icon: Icons.search_rounded,
      title: title,
      message: message,
      showProgress: true,
    );
  }

  factory StateIllustration.notFound({
    required String message,
    required VoidCallback onRetry,
  }) {
    return StateIllustration(
      icon: Icons.person_search_rounded,
      title: 'User Not Found',
      message: message,
      actionLabel: 'Try Again',
      onAction: onRetry,
    );
  }

  factory StateIllustration.network({
    required String message,
    required VoidCallback onRetry,
  }) {
    return StateIllustration(
      icon: Icons.cloud_off_rounded,
      title: 'Network Error',
      message: message,
      actionLabel: 'Try Again',
      onAction: onRetry,
    );
  }

  factory StateIllustration.genericError({
    required String message,
    required VoidCallback onRetry,
  }) {
    return StateIllustration(
      icon: Icons.error_outline_rounded,
      title: 'Something Went Wrong',
      message: message,
      actionLabel: 'Try Again',
      onAction: onRetry,
    );
  }

  factory StateIllustration.empty({
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return StateIllustration(
      icon: Icons.inbox_rounded,
      title: title,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Sparkles(icon: icon, color: iconColor),
            const SizedBox(height: 28),
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.45,
              ),
            ),
            if (showProgress) ...[
              const SizedBox(height: 22),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: 130,
                  height: 5,
                  child: const LinearProgressIndicator(
                    backgroundColor: AppTheme.surfaceAlt,
                    valueColor: AlwaysStoppedAnimation(AppTheme.accentSolid),
                  ),
                ),
              ),
            ],
            if (actionLabel != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onAction,
                  child: Text(actionLabel!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Sparkles extends StatelessWidget {
  const _Sparkles({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 6,
            left: 18,
            child: _sparkle(10, color.withOpacity(0.55)),
          ),
          Positioned(
            top: 0,
            right: 24,
            child: _sparkle(7, color.withOpacity(0.4)),
          ),
          Positioned(
            bottom: 10,
            left: 4,
            child: _sparkle(6, color.withOpacity(0.35)),
          ),
          Positioned(
            bottom: 18,
            right: 6,
            child: _sparkle(9, color.withOpacity(0.5)),
          ),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [color.withOpacity(0.28), color.withOpacity(0.08)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(icon, size: 42, color: color),
          ),
        ],
      ),
    );
  }

  Widget _sparkle(double size, Color color) {
    return Icon(Icons.auto_awesome_rounded, size: size, color: color);
  }
}
