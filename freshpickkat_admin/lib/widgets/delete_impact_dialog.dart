import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

enum DeleteChoice { hardDelete, softDelete, cancel }

Future<DeleteChoice> showDeleteImpactDialog({
  required BuildContext context,
  required DeleteImpactResponse impact,
  required String entityName,
}) {
  if (impact.canHardDelete) {
    return _showHardDeleteDialog(context, entityName);
  }
  return _showReferencesDialog(context, entityName, impact.references);
}

Future<DeleteChoice> _showHardDeleteDialog(
  BuildContext context,
  String entityName,
) {
  return showDialog<DeleteChoice>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          Icon(Icons.delete_forever, color: Colors.red.shade700, size: 24),
          const SizedBox(width: 10),
          const Text('Permanent Delete'),
        ],
      ),
      content: Text(
        'This $entityName is not linked with any records and will be '
        'permanently deleted. This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, DeleteChoice.cancel),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red.shade700,
          ),
          onPressed: () => Navigator.pop(context, DeleteChoice.hardDelete),
          child: const Text('Delete Permanently'),
        ),
      ],
    ),
  ).then((v) => v ?? DeleteChoice.cancel);
}

Widget _buildReferenceList(List<DeleteImpactReference> references) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text(
        'This item is associated with existing records:',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 12),
      for (final ref in references)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: [
              const SizedBox(width: 16),
              const Icon(Icons.circle, size: 6, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${ref.count} ${_formatType(ref.type)}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
    ],
  );
}

String _formatType(String type) {
  switch (type) {
    case 'orders':
      return 'Orders';
    case 'banners':
      return 'Banners';
    case 'bogo_offers':
      return 'BOGO Offers';
    case 'bogo_rewards':
      return 'BOGO Rewards';
    case 'combo_offers':
      return 'Combo Offers';
    case 'category_offers':
      return 'Category Offers';
    case 'category_offer_exclusions':
      return 'Category Offer Exclusions';
    case 'coupons':
      return 'Coupons';
    case 'cart_items':
      return 'Cart Items';
    case 'free_delivery_rules':
      return 'Free Delivery Rules';
    default:
      return type;
  }
}

Future<DeleteChoice> _showReferencesDialog(
  BuildContext context,
  String entityName,
  List<DeleteImpactReference> references,
) {
  return showDialog<DeleteChoice>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700, size: 24),
          const SizedBox(width: 10),
          const Text('Permanent Delete Not Possible'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildReferenceList(references),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: Colors.orange.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'You may mark this $entityName as inactive instead.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, DeleteChoice.cancel),
          child: const Text('Cancel'),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.orange.shade700,
            side: BorderSide(color: Colors.orange.shade700),
          ),
          onPressed: () => Navigator.pop(context, DeleteChoice.softDelete),
          child: const Text('Mark as Inactive'),
        ),
      ],
    ),
  ).then((v) => v ?? DeleteChoice.cancel);
}
