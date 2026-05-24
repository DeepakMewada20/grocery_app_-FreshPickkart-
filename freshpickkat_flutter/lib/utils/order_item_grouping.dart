import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/combo_offer_utils.dart';

class GroupedOrderSections {
  const GroupedOrderSections({
    required this.bogoGroups,
    required this.comboGroups,
    required this.individualItems,
  });

  final List<GroupedOrderItem> bogoGroups;
  final List<GroupedOrderCombo> comboGroups;
  final List<OrderItem> individualItems;
}

class GroupedOrderItem {
  const GroupedOrderItem({required this.item, required this.freeItems});

  final OrderItem item;
  final List<OrderItem> freeItems;
}

class GroupedOrderCombo {
  const GroupedOrderCombo({
    required this.comboId,
    required this.name,
    required this.discountType,
    required this.discountValue,
    required this.items,
  });

  final String comboId;
  final String name;
  final String discountType;
  final double discountValue;
  final List<OrderItem> items;

  int get bundleQuantity {
    if (items.isEmpty) return 0;
    final counts =
        items
            .map((item) => item.quantity ~/ (item.comboItemQuantity ?? 1))
            .where((count) => count > 0)
            .toList()
          ..sort();
    return counts.isEmpty ? 0 : counts.first;
  }

  double get originalTotal =>
      items.fold(0, (sum, item) => sum + item.totalPrice);

  double get discountedTotal => applyComboDiscount(
    originalTotal: originalTotal,
    discountType: discountType,
    discountValue: discountType == 'flat'
        ? discountValue * bundleQuantity
        : discountValue,
  );
}

GroupedOrderSections groupOrderItems(List<OrderItem> items) {
  final freeByTrigger = <String, List<OrderItem>>{};
  final paidItems = <OrderItem>[];
  final comboMap = <String, List<OrderItem>>{};

  for (final item in items) {
    final comboId = item.comboId?.trim();
    if (comboId != null && comboId.isNotEmpty) {
      comboMap.putIfAbsent(comboId, () => <OrderItem>[]).add(item);
      continue;
    }

    final triggerProductId = item.triggerProductId?.trim();
    if (item.isFreeItem &&
        triggerProductId != null &&
        triggerProductId.isNotEmpty) {
      freeByTrigger
          .putIfAbsent(triggerProductId, () => <OrderItem>[])
          .add(item);
      continue;
    }

    paidItems.add(item);
  }

  final bogoGroups = <GroupedOrderItem>[];
  final individualItems = <OrderItem>[];
  for (final item in paidItems) {
    final freeItems = freeByTrigger[item.productId] ?? const <OrderItem>[];
    if (freeItems.isEmpty) {
      individualItems.add(item);
    } else {
      bogoGroups.add(GroupedOrderItem(item: item, freeItems: freeItems));
    }
  }

  for (final orphanedFreeItems in freeByTrigger.entries) {
    if (!paidItems.any((item) => item.productId == orphanedFreeItems.key)) {
      individualItems.addAll(orphanedFreeItems.value);
    }
  }

  final comboGroups = comboMap.entries
      .map((entry) {
        final first = entry.value.first;
        return GroupedOrderCombo(
          comboId: entry.key,
          name: first.comboName ?? 'Combo Offer',
          discountType: first.comboDiscountType ?? 'flat',
          discountValue: first.comboDiscountValue ?? 0,
          items: entry.value,
        );
      })
      .toList(growable: false);

  return GroupedOrderSections(
    bogoGroups: bogoGroups,
    comboGroups: comboGroups,
    individualItems: individualItems,
  );
}
