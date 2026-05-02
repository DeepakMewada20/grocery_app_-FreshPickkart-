import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';

class AdminStateView extends StatelessWidget {
  const AdminStateView({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.info_outline,
    this.onRetry,
  });

  factory AdminStateView.empty({
    Key? key,
    required String title,
    String? message,
    IconData icon = Icons.inbox_outlined,
    Future<void> Function()? onRefresh,
  }) {
    return AdminStateView(
      key: key,
      title: title,
      message: message,
      icon: icon,
      onRetry: onRefresh,
    );
  }

  factory AdminStateView.error({
    Key? key,
    String? message,
    VoidCallback? onRetry,
  }) {
    return AdminStateView(
      key: key,
      title: sanitizeErrorMessage(message),
      message: 'Please try again.',
      icon: Icons.error_outline,
      onRetry: onRetry,
    );
  }

  final String title;
  final String? message;
  final IconData icon;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 56,
              color: AdminAppTheme.getTextSecondaryColor(context),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (message != null && message!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AdminAppTheme.getTextSecondaryColor(context),
                ),
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String sanitizeErrorMessage(String? error) {
  final raw = error?.trim();
  if (raw == null || raw.isEmpty) return 'Something went wrong';

  final lower = raw.toLowerCase();
  if (lower.contains('internal server error') ||
      lower.contains('status code 500') ||
      lower.contains('serverpodclientexception') ||
      lower.contains('stack trace') ||
      lower.contains('invalid argument') ||
      lower.contains('contains superfluous variables')) {
    return 'Something went wrong';
  }

  if (lower.contains('timeout')) return 'Request timed out';
  if (lower.contains('network') || lower.contains('socket')) {
    return 'Network connection failed';
  }
  if (lower.contains('access denied') || lower.contains('unauthorized')) {
    return 'Access denied';
  }
  return raw.length > 120 ? '${raw.substring(0, 117)}...' : raw;
}
