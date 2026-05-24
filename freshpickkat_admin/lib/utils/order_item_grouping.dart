import 'package:freshpickkat_client/freshpickkat_client.dart';

class AdminGroupedOrderSections {
  const AdminGroupedOrderSections({
    required this.bogoGroups,
    required this.comboGroups,
    required this.individualItems,
  });

  final List<AdminGroupedOrderItem> bogoGroups;
  final List<AdminGroupedOrderCombo> comboGroups;
  final List<OrderItem> individualItems;
}

class AdminGroupedOrderItem {
  const AdminGroupedOrderItem({required this.item, required this.freeItems});

  final OrderItem item;
  final List<OrderItem> freeItems;
}

class AdminGroupedOrderCombo {
  const AdminGroupedOrderCombo({
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

  int get bundleQuantity => _bundleQuantity(items);
  double get originalTotal =>
      items.fold(0, (sum, item) => sum + item.totalPrice);
  double get discountedTotal => _applyComboDiscount(
    originalTotal: originalTotal,
    discountType: discountType,
    discountValue: discountType == 'flat'
        ? discountValue * bundleQuantity
        : discountValue,
  );
}

class AdminGroupedComplaintSections {
  const AdminGroupedComplaintSections({
    required this.bogoGroups,
    required this.comboGroups,
    required this.individualItems,
  });

  final List<AdminGroupedComplaintItem> bogoGroups;
  final List<AdminGroupedComplaintCombo> comboGroups;
  final List<ComplaintProductItem> individualItems;
}

class AdminGroupedComplaintItem {
  const AdminGroupedComplaintItem({
    required this.item,
    required this.freeItems,
  });

  final ComplaintProductItem item;
  final List<ComplaintProductItem> freeItems;
}

class AdminGroupedComplaintCombo {
  const AdminGroupedComplaintCombo({
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
  final List<ComplaintProductItem> items;

  int get bundleQuantity => _bundleQuantity(items);
  double get originalTotal =>
      items.fold(0, (sum, item) => sum + item.totalPrice);
  double get discountedTotal => _applyComboDiscount(
    originalTotal: originalTotal,
    discountType: discountType,
    discountValue: discountType == 'flat'
        ? discountValue * bundleQuantity
        : discountValue,
  );
}

AdminGroupedOrderSections groupAdminOrderItems(List<OrderItem> items) {
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

  final bogoGroups = <AdminGroupedOrderItem>[];
  final individualItems = <OrderItem>[];
  for (final item in paidItems) {
    final freeItems = freeByTrigger[item.productId] ?? const <OrderItem>[];
    if (freeItems.isEmpty) {
      individualItems.add(item);
    } else {
      bogoGroups.add(AdminGroupedOrderItem(item: item, freeItems: freeItems));
    }
  }

  for (final entry in freeByTrigger.entries) {
    if (!paidItems.any((item) => item.productId == entry.key)) {
      individualItems.addAll(entry.value);
    }
  }

  return AdminGroupedOrderSections(
    bogoGroups: bogoGroups,
    comboGroups: comboMap.entries
        .map((entry) {
          final first = entry.value.first;
          return AdminGroupedOrderCombo(
            comboId: entry.key,
            name: first.comboName ?? 'Combo Offer',
            discountType: first.comboDiscountType ?? 'flat',
            discountValue: first.comboDiscountValue ?? 0,
            items: entry.value,
          );
        })
        .toList(growable: false),
    individualItems: individualItems,
  );
}

AdminGroupedComplaintSections groupAdminComplaintItems(
  List<ComplaintProductItem> items,
) {
  final freeByTrigger = <String, List<ComplaintProductItem>>{};
  final paidItems = <ComplaintProductItem>[];
  final comboMap = <String, List<ComplaintProductItem>>{};

  for (final item in items) {
    final comboId = item.comboId?.trim();
    if (comboId != null && comboId.isNotEmpty) {
      comboMap.putIfAbsent(comboId, () => <ComplaintProductItem>[]).add(item);
      continue;
    }
    final triggerProductId = item.triggerProductId?.trim();
    if (item.isFreeItem &&
        triggerProductId != null &&
        triggerProductId.isNotEmpty) {
      freeByTrigger
          .putIfAbsent(triggerProductId, () => <ComplaintProductItem>[])
          .add(item);
      continue;
    }
    paidItems.add(item);
  }

  final bogoGroups = <AdminGroupedComplaintItem>[];
  final individualItems = <ComplaintProductItem>[];
  for (final item in paidItems) {
    final freeItems =
        freeByTrigger[item.productId] ?? const <ComplaintProductItem>[];
    if (freeItems.isEmpty) {
      individualItems.add(item);
    } else {
      bogoGroups.add(
        AdminGroupedComplaintItem(item: item, freeItems: freeItems),
      );
    }
  }

  for (final entry in freeByTrigger.entries) {
    if (!paidItems.any((item) => item.productId == entry.key)) {
      individualItems.addAll(entry.value);
    }
  }

  return AdminGroupedComplaintSections(
    bogoGroups: bogoGroups,
    comboGroups: comboMap.entries
        .map((entry) {
          final first = entry.value.first;
          return AdminGroupedComplaintCombo(
            comboId: entry.key,
            name: first.comboName ?? 'Combo Offer',
            discountType: first.comboDiscountType ?? 'flat',
            discountValue: first.comboDiscountValue ?? 0,
            items: entry.value,
          );
        })
        .toList(growable: false),
    individualItems: individualItems,
  );
}

int _bundleQuantity(List<dynamic> items) {
  if (items.isEmpty) return 0;
  final counts =
      items
          .map((item) => item.quantity ~/ (item.comboItemQuantity ?? 1))
          .where((count) => count > 0)
          .toList()
        ..sort();
  return counts.isEmpty ? 0 : counts.first;
}

double _applyComboDiscount({
  required double originalTotal,
  required String discountType,
  required double discountValue,
}) {
  if (originalTotal <= 0 || discountValue <= 0) return originalTotal;
  if (discountType == 'percentage') {
    return (originalTotal * (1 - (discountValue / 100)))
        .clamp(0, originalTotal)
        .toDouble();
  }
  return (originalTotal - discountValue).clamp(0, originalTotal).toDouble();
}
