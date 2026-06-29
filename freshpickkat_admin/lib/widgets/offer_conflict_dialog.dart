import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

Future<bool?> showOfferConflictDialog({
  required BuildContext context,
  required OfferConflictResponse conflict,
  bool showSelectNewProduct = true,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Offer Conflict'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            conflict.message ?? 'This offer conflicts with another active offer.',
          ),
          const SizedBox(height: 12),
          Text(
            'To use this product, first deactivate the active offer using it.',
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(ctx).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        if (showSelectNewProduct)
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Select New Product'),
          ),
      ],
    ),
  );
}
