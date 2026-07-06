import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final String? title;
  final VoidCallback? onRetry;
  final IconData icon;

  const ErrorStateWidget({
    super.key,
    this.message = 'Something went wrong',
    this.title,
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Insets.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: Insets.md),
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: Insets.sm),
                child: Text(
                  title!,
                  style: AppTypography.headlineSm,
                  textAlign: TextAlign.center,
                ),
              ),
            Text(
              message,
              style: AppTypography.bodyMd.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: Insets.lg),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: FilledButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.brMd,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
