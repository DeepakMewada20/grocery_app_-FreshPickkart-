import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../admin/dependency_checker.dart';
import 'postgres_support.dart';

class PostgresDeliveryService {
  static const _defaultConfigKey = 'default';

  Future<DeliveryConfig> getDeliveryConfig(Session session) async {
    final row = await DeliveryConfigRow.db.findFirstRow(
      session,
      where: (t) => t.configKey.equals(_defaultConfigKey),
    );
    if (row == null || row.id == null) {
      return _defaultConfig();
    }

    final slabs = await DeliverySlabRow.db.find(
      session,
      where: (t) => t.configId.equals(row.id!),
      orderBy: (t) => t.sortOrder,
      orderDescending: false,
    );

    return DeliveryConfig(
      configId: row.id!.toString(),
      baseDeliveryFee: row.baseDeliveryFee,
      freeDeliveryThreshold: row.freeDeliveryThreshold,
      slabs: slabs
          .map(
            (slab) => DeliverySlab(
              minOrderAmount: slab.minOrderAmount,
              maxOrderAmount: slab.maxOrderAmount,
              fee: slab.fee,
            ),
          )
          .toList(),
      isActive: row.isActive,
      updatedAt: row.updatedAt,
    );
  }

  Future<bool> saveDeliveryConfig(
    Session session,
    DeliveryConfig config,
  ) async {
    return session.db.transaction<bool>((transaction) async {
      final now = DateTime.now().toUtc();
      var row = await DeliveryConfigRow.db.findFirstRow(
        session,
        where: (t) => t.configKey.equals(_defaultConfigKey),
        transaction: transaction,
      );

      if (row == null) {
        row = await DeliveryConfigRow.db.insertRow(
          session,
          DeliveryConfigRow(
            configKey: _defaultConfigKey,
            baseDeliveryFee: config.baseDeliveryFee,
            freeDeliveryThreshold: config.freeDeliveryThreshold,
            isActive: config.isActive,
            createdAt: now,
            updatedAt: now,
          ),
          transaction: transaction,
        );
      } else {
        row = await DeliveryConfigRow.db.updateRow(
          session,
          row.copyWith(
            baseDeliveryFee: config.baseDeliveryFee,
            freeDeliveryThreshold: config.freeDeliveryThreshold,
            isActive: config.isActive,
            updatedAt: now,
          ),
          transaction: transaction,
        );
      }

      final configId = row.id;
      if (configId == null) {
        throw Exception('Delivery config id was not generated.');
      }

      final existingSlabs = await DeliverySlabRow.db.find(
        session,
        where: (t) => t.configId.equals(configId),
        transaction: transaction,
      );
      if (existingSlabs.isNotEmpty) {
        await DeliverySlabRow.db.delete(
          session,
          existingSlabs,
          transaction: transaction,
        );
      }

      for (var i = 0; i < config.slabs.length; i++) {
        final slab = config.slabs[i];
        await DeliverySlabRow.db.insertRow(
          session,
          DeliverySlabRow(
            configId: configId,
            minOrderAmount: slab.minOrderAmount,
            maxOrderAmount: slab.maxOrderAmount,
            fee: slab.fee,
            sortOrder: i,
            createdAt: now,
            updatedAt: now,
          ),
          transaction: transaction,
        );
      }
      return true;
    });
  }

  Future<List<DeliveryRule>> getActiveDeliveryRules(Session session) async {
    final rows = await DeliveryRuleRow.db.find(
      session,
      where: (t) => t.status.equals('active'),
      orderBy: (t) => t.sortOrder,
      orderDescending: false,
    );

    final now = DateTime.now().toUtc();
    return rows
        .where((row) {
          if (row.startsAt != null && now.isBefore(row.startsAt!)) return false;
          if (row.endsAt != null && now.isAfter(row.endsAt!)) return false;
          return true;
        })
        .map(_mapRule)
        .toList();
  }

  Future<List<DeliveryRule>> getInactiveDeliveryRules(Session session) async {
    final rows = await DeliveryRuleRow.db.find(
      session,
      where: (t) => t.status.equals('inactive'),
      orderBy: (t) => t.sortOrder,
      orderDescending: false,
    );
    return rows.map(_mapRule).toList();
  }

  Future<List<DeliveryRule>> getAllDeliveryRules(Session session) async {
    final rows = await DeliveryRuleRow.db.find(
      session,
      where: (t) => t.status.equals('active'),
      orderBy: (t) => t.sortOrder,
      orderDescending: false,
    );
    return rows.map(_mapRule).toList();
  }

  Future<List<DeliveryRule>> getAllDeliveryRulesIncludingInactive(Session session) async {
    final rows = await DeliveryRuleRow.db.find(
      session,
      orderBy: (t) => t.sortOrder,
      orderDescending: false,
    );
    return rows.map(_mapRule).toList();
  }

  Future<int> getNextSortOrder(Session session) async {
    final rows = await DeliveryRuleRow.db.find(
      session,
      orderBy: (t) => t.sortOrder,
      orderDescending: true,
      limit: 1,
    );
    return rows.isNotEmpty ? rows.first.sortOrder + 1 : 1;
  }

  Future<bool> swapSortOrder(Session session, String ruleId1, String ruleId2) async {
    final parsed1 = tryParseUuid(ruleId1);
    final parsed2 = tryParseUuid(ruleId2);
    if (parsed1 == null || parsed2 == null) return false;

    return session.db.transaction<bool>((transaction) async {
      final row1 = await DeliveryRuleRow.db.findById(session, parsed1!, transaction: transaction);
      final row2 = await DeliveryRuleRow.db.findById(session, parsed2!, transaction: transaction);
      if (row1 == null || row2 == null) return false;

      final tempOrder = row1.sortOrder;
      await DeliveryRuleRow.db.updateRow(session, row1.copyWith(sortOrder: row2.sortOrder, updatedAt: DateTime.now().toUtc()), transaction: transaction);
      await DeliveryRuleRow.db.updateRow(session, row2.copyWith(sortOrder: tempOrder, updatedAt: DateTime.now().toUtc()), transaction: transaction);
      return true;
    });
  }

  Future<bool> upsertDeliveryRule(
    Session session,
    DeliveryRule rule,
  ) async {
    return session.db.transaction<bool>((transaction) async {
      DeliveryRuleRow? row;
      final providedId = tryParseUuid(rule.ruleId);
      if (providedId != null) {
        row = await DeliveryRuleRow.db.findById(
          session,
          providedId,
          transaction: transaction,
        );
      }

      final now = DateTime.now().toUtc();
      if (row == null) {
        final nextSortOrder = await getNextSortOrder(session);
        await DeliveryRuleRow.db.insertRow(
          session,
          DeliveryRuleRow(
            name: rule.name.trim(),
            description: cleanNullableString(rule.description),
            deliveryFee: rule.deliveryFee,
            sortOrder: nextSortOrder,
            targetUserType: cleanNullableString(rule.targetUserType),
            targetOrderCount: rule.targetOrderCount,
            startsAt: rule.startDate?.toUtc(),
            endsAt: rule.endDate?.toUtc(),
            status: rule.isActive ? 'active' : 'inactive',
            deactivatedAt: rule.isActive ? null : now,
            createdAt: now,
            updatedAt: now,
          ),
          transaction: transaction,
        );
      } else {
        await DeliveryRuleRow.db.updateRow(
          session,
          row.copyWith(
            name: rule.name.trim(),
            description: cleanNullableString(rule.description),
            deliveryFee: rule.deliveryFee,
            sortOrder: row.sortOrder,
            targetUserType: cleanNullableString(rule.targetUserType),
            targetOrderCount: rule.targetOrderCount,
            startsAt: rule.startDate?.toUtc(),
            endsAt: rule.endDate?.toUtc(),
            status: rule.isActive ? 'active' : 'inactive',
            deactivatedAt: rule.isActive ? null : now,
            updatedAt: now,
          ),
          transaction: transaction,
        );
      }
      return true;
    });
  }

  Future<String> deleteDeliveryRule(Session session, String ruleId) async {
    final parsedId = tryParseUuid(ruleId);
    if (parsedId == null) return 'Invalid rule ID';

    final row = await DeliveryRuleRow.db.findById(session, parsedId);
    if (row == null) return 'Rule not found';

    final refs = await DependencyChecker.checkDeliveryRule(session, parsedId);
    if (refs.isNotEmpty) {
      return DependencyChecker.formatRefs(refs);
    }

    final now = DateTime.now().toUtc();
    await DeliveryRuleRow.db.updateRow(
      session,
      row.copyWith(
        status: 'inactive',
        deactivatedAt: now,
        updatedAt: now,
      ),
    );
    return '';
  }

  Future<bool> setDeliveryRuleActive(
    Session session,
    String ruleId,
    bool isActive,
  ) async {
    final parsedId = tryParseUuid(ruleId);
    if (parsedId == null) return false;

    final row = await DeliveryRuleRow.db.findById(session, parsedId);
    if (row == null) return false;

    final now = DateTime.now().toUtc();
    await DeliveryRuleRow.db.updateRow(
      session,
      row.copyWith(
        status: isActive ? 'active' : 'inactive',
        deactivatedAt: isActive ? null : now,
        updatedAt: now,
      ),
    );
    return true;
  }

  Future<bool> moveDeliveryRuleUp(Session session, String ruleId) async {
    final parsedId = tryParseUuid(ruleId);
    if (parsedId == null) return false;

    final allRules = await DeliveryRuleRow.db.find(
      session,
      orderBy: (t) => t.sortOrder,
      orderDescending: false,
    );
    final idx = allRules.indexWhere((r) => r.id == parsedId);
    if (idx <= 0) return false;

    return swapSortOrder(session, allRules[idx].id!.toString(), allRules[idx - 1].id!.toString());
  }

  Future<bool> moveDeliveryRuleDown(Session session, String ruleId) async {
    final parsedId = tryParseUuid(ruleId);
    if (parsedId == null) return false;

    final allRules = await DeliveryRuleRow.db.find(
      session,
      orderBy: (t) => t.sortOrder,
      orderDescending: false,
    );
    final idx = allRules.indexWhere((r) => r.id == parsedId);
    if (idx < 0 || idx >= allRules.length - 1) return false;

    return swapSortOrder(session, allRules[idx].id!.toString(), allRules[idx + 1].id!.toString());
  }

  DeliveryRule _mapRule(DeliveryRuleRow row) {
    return DeliveryRule(
      ruleId: row.id?.toString(),
      name: row.name,
      description: row.description,
      deliveryFee: row.deliveryFee,
      sortOrder: row.sortOrder,
      targetUserType: row.targetUserType,
      targetOrderCount: row.targetOrderCount,
      isActive: row.status == 'active',
      startDate: row.startsAt,
      endDate: row.endsAt,
      createdAt: row.createdAt,
    );
  }

  DeliveryConfig _defaultConfig() {
    return DeliveryConfig(
      configId: _defaultConfigKey,
      baseDeliveryFee: 40,
      freeDeliveryThreshold: 300,
      slabs: [
        DeliverySlab(minOrderAmount: 0, maxOrderAmount: 199, fee: 40),
        DeliverySlab(minOrderAmount: 200, maxOrderAmount: 299, fee: 20),
        DeliverySlab(minOrderAmount: 300, maxOrderAmount: 999999, fee: 0),
      ],
      isActive: true,
      updatedAt: DateTime.now(),
    );
  }
}
