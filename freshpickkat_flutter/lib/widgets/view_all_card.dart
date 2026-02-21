import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';

class ViewAllCard extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const ViewAllCard({
    super.key,
    required this.onTap,
    this.text = 'VIEW ALL',
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: AppTheme.primaryGreen,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              const Icon(
                Icons.arrow_forward,
                color: AppTheme.primaryGreen,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
