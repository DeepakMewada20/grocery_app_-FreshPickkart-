import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

Future<bool> showCascadeDeactivationDialog({
  required BuildContext context,
  required CascadeImpactResponse impact,
}) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange.shade700,
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: const Text(
              'Cascade Deactivation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'This item is linked to ${impact.affectedEntities.length} other active entit${impact.affectedEntities.length == 1 ? 'y' : 'ies'}.',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(
              'If you continue, some related entities will be deactivated automatically.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            if (impact.affectedEntities.isNotEmpty) ...[
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 10),
              const Text(
                'Entities to deactivate:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              _buildAffectedList(impact.affectedEntities),
            ],
            if (impact.protectedEntities.isNotEmpty) ...[
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.shield_outlined, size: 16, color: Colors.green.shade700),
                  const SizedBox(width: 6),
                  Text(
                    'Protected (kept active):',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              _buildProtectedList(impact.protectedEntities),
            ],
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
                      'This action cannot be undone. Deactivated entities can be reactivated manually.',
                      style: TextStyle(fontSize: 13, color: Colors.orange.shade800),
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
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.orange.shade700,
            side: BorderSide(color: Colors.orange.shade700),
          ),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Deactivate'),
        ),
      ],
    ),
  ).then((v) => v ?? false);
}

Widget _buildAffectedList(List<CascadeEntityInfo> entities) {
  final grouped = <String, List<CascadeEntityInfo>>{};
  for (final e in entities) {
    grouped.putIfAbsent(e.entityType, () => []).add(e);
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: grouped.entries.map((entry) {
      final label = _typeLabel(entry.key);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 8),
            Text(
              '$label (${entry.value.length}):',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }).toList(),
  );
}

Widget _buildProtectedList(List<CascadeEntityInfo> entities) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: entities.map((e) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8),
          Icon(Icons.check_circle_outline, size: 14, color: Colors.green.shade600),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              '${e.entityName.isNotEmpty ? e.entityName : e.entityId} — ${e.reason}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    )).toList(),
  );
}

String _typeLabel(String entityType) {
  switch (entityType) {
    case 'product': return 'Products';
    case 'variant': return 'Variants';
    case 'bogo_offer': return 'BOGO Offers';
    case 'combo_offer': return 'Combo Offers';
    case 'combo_offer_item': return 'Combo Items';
    case 'category_offer': return 'Category Offers';
    case 'coupon': return 'Coupons';
    case 'free_delivery_rule': return 'Free Delivery Rules';
    case 'delivery_rule': return 'Delivery Rules';
    case 'banner': return 'Banners';
    default: return entityType;
  }
}
