import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart'
    show
        AdminAuditLogRow,
        AppUserRow,
        CustomerOrderRow,
        OrderItemRow,
        ProductRow,
        ProductVariantRow;
import '../../generated/protocol.dart' as protocol;
import '../firebase/firebase_auth_service.dart';
import 'postgres_support.dart';

class PostgresAdminService {
  static const String _adminRole = 'ADMIN_SELLER';
  static final RegExp _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final RegExp _usernameRegex = RegExp(r'^[a-z][a-z0-9_]{3,23}$');

  static bool isValidUsername(String username) {
    return _usernameRegex.hasMatch(username.trim().toLowerCase());
  }

  Future<bool> isAdminSetupCompleted(Session session) async {
    final users = await AppUserRow.db.find(
      session,
      where: (t) => t.status.equals('active'),
    );
    return users.any((user) => _isAdminSellerRole(user.role));
  }

  Future<String> resolveAdminLoginEmail(
    Session session,
    String usernameOrEmail,
  ) async {
    final normalized = usernameOrEmail.trim().toLowerCase();
    if (normalized.isEmpty) return '';

    final adminUsers = await AppUserRow.db.find(
      session,
      where: (t) => t.status.equals('active'),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );

    final eligible = adminUsers.where((user) => _isAdminSellerRole(user.role));
    if (normalized.contains('@')) {
      if (!_emailRegex.hasMatch(normalized)) return '';
      for (final user in eligible) {
        final email = user.email?.trim().toLowerCase();
        if (email == normalized) return normalized;
      }
      return '';
    }

    AppUserRow? match;
    for (final user in eligible) {
      final name = user.name?.trim().toLowerCase();
      if (name == normalized) {
        if (match != null) return '';
        match = user;
      }
    }

    final email = match?.email?.trim().toLowerCase();
    if (email == null || !_emailRegex.hasMatch(email)) return '';
    return email;
  }

  Future<protocol.AdminAuthResult> firebaseLogin(
    Session session,
    String idToken,
  ) async {
    final token = await FirebaseAuthService.verifyIdToken(idToken);
    if (token == null) {
      final verifyError = FirebaseAuthService.getLastVerifyError();
      return protocol.AdminAuthResult(
        ok: false,
        message: verifyError == null || verifyError.trim().isEmpty
            ? 'Invalid or expired Firebase token.'
            : 'Invalid or expired Firebase token. $verifyError',
      );
    }

    if (!token.emailVerified) {
      return protocol.AdminAuthResult(
        ok: false,
        message: 'Email verification required.',
      );
    }

    final user = await AppUserRow.db.findFirstRow(
      session,
      where: (t) => t.firebaseUid.equals(token.uid) & t.status.equals('active'),
    );
    if (user != null && _isAdminSellerRole(user.role)) {
      return protocol.AdminAuthResult(ok: true);
    }

    final relinked = await _relinkAdminByEmail(session, token);
    if (!relinked) {
      return protocol.AdminAuthResult(
        ok: false,
        message: 'Access denied: ADMIN_SELLER role required.',
      );
    }

    return protocol.AdminAuthResult(ok: true);
  }

  Future<protocol.AdminAuthResult> completeFirebaseSetup(
    Session session,
    String idToken,
    String username,
  ) async {
    final token = await FirebaseAuthService.verifyIdToken(idToken);
    if (token == null) {
      final verifyError = FirebaseAuthService.getLastVerifyError();
      return protocol.AdminAuthResult(
        ok: false,
        message: verifyError == null || verifyError.trim().isEmpty
            ? 'Invalid or expired Firebase token.'
            : 'Invalid or expired Firebase token. $verifyError',
      );
    }
    if (!token.emailVerified) {
      return protocol.AdminAuthResult(
        ok: false,
        message: 'Email verification required.',
      );
    }

    final email = token.email?.trim().toLowerCase();
    if (email == null || !_emailRegex.hasMatch(email)) {
      return protocol.AdminAuthResult(
        ok: false,
        message: 'Verified admin email required.',
      );
    }

    final adminUsers = await _activeAdminUsers(session);
    final existingByUid = await AppUserRow.db.findFirstRow(
      session,
      where: (t) => t.firebaseUid.equals(token.uid),
    );
    final existingAdminByEmail = _findAdminByEmail(adminUsers, email);

    if (existingByUid != null && _isAdminSellerRole(existingByUid.role)) {
      await _updateAdminRow(
        session,
        existingByUid,
        firebaseUid: token.uid,
        email: email,
        username: username,
      );
      return protocol.AdminAuthResult(ok: true);
    }

    if (existingAdminByEmail != null) {
      await _updateAdminRow(
        session,
        existingAdminByEmail,
        firebaseUid: token.uid,
        email: email,
        username: username,
      );
      return protocol.AdminAuthResult(ok: true);
    }

    if (adminUsers.isNotEmpty) {
      return protocol.AdminAuthResult(
        ok: false,
        message: 'Access denied: ADMIN_SELLER role required.',
      );
    }

    if (existingByUid == null) {
      final now = DateTime.now().toUtc();
      await AppUserRow.db.insertRow(
        session,
        AppUserRow(
          firebaseUid: token.uid,
          phoneNumber: token.phoneNumber ?? '',
          name: _cleanUsername(username),
          email: email,
          role: _adminRole,
          status: 'active',
          createdAt: now,
          updatedAt: now,
        ),
      );
    } else {
      await _updateAdminRow(
        session,
        existingByUid,
        firebaseUid: token.uid,
        email: email,
        username: username,
      );
    }

    return protocol.AdminAuthResult(ok: true);
  }

  Future<List<protocol.AppUser>> getAllUsers(
    Session session, {
    int limit = 50,
  }) async {
    final rows = await AppUserRow.db.find(
      session,
      where: (t) => t.status.equals('active'),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: clampPageLimit(limit, defaultLimit: 50, maxLimit: 200),
    );

    final userIds = rows.map((row) => row.id!).toSet();
    final completedCounts = await _completedOrderCounts(session, userIds);

    return rows
        .map(
          (row) => protocol.AppUser(
            firebaseUid: row.firebaseUid ?? row.id!.toString(),
            phoneNumber: row.phoneNumber,
            name: row.name,
            email: row.email,
            role: row.role,
            fcmToken: row.fcmToken,
            completedOrdersCount: completedCounts[row.id!.toString()] ?? 0,
            currentFreshPoints: row.currentFreshPoints,
            totalEarned: row.totalEarned,
            totalRedeemed: row.totalRedeemed,
          ),
        )
        .toList();
  }

  Future<protocol.AdminDashboardStats> getDashboardStats(
    Session session,
  ) async {
    final orders = await CustomerOrderRow.db.find(session);
    final users = await AppUserRow.db.count(
      session,
      where: (t) => t.status.equals('active'),
    );

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    var todayOrders = 0;
    var todayRevenue = 0.0;
    var totalRevenue = 0.0;
    var pendingCount = 0;
    var confirmedCount = 0;
    var outForDeliveryCount = 0;
    var deliveredCount = 0;
    var cancelledCount = 0;

    for (final order in orders) {
      if (!order.orderedAt.isBefore(startOfDay)) {
        todayOrders++;
        if (order.paymentStatus == 'paid' && order.orderStatus != 'cancelled') {
          todayRevenue += order.finalAmount;
        }
      }

      if (order.paymentStatus == 'paid' && order.orderStatus != 'cancelled') {
        totalRevenue += order.finalAmount;
      }

      switch (order.orderStatus) {
        case 'placed':
        case 'pending':
          pendingCount++;
          break;
        case 'confirmed':
          confirmedCount++;
          break;
        case 'out_for_delivery':
          outForDeliveryCount++;
          break;
        case 'delivered':
          deliveredCount++;
          break;
        case 'cancelled':
          cancelledCount++;
          break;
      }
    }

    // ── COD analytics ──
    var codPlaced = 0;
    var codDelivered = 0;
    var codRejected = 0;
    var codCollected = 0.0;
    var codUnpaid = 0.0;
    var cashCollected = 0.0;
    var upiCollected = 0.0;
    for (final order in orders) {
      if (order.paymentMode != 'cod') continue;
      codPlaced++;
      if (order.orderStatus == 'delivered') {
        codDelivered++;
        if (order.paymentStatus == 'paid') {
          codCollected += order.finalAmount;
          if (order.paymentCollectionMode == 'cash') {
            cashCollected += order.finalAmount;
          } else if (order.paymentCollectionMode == 'upi_qr') {
            upiCollected += order.finalAmount;
          }
        }
      }
      if (order.codFailureReason != null) {
        codRejected++;
      }
      if (order.orderStatus != 'cancelled' &&
          order.orderStatus != 'delivered' &&
          order.paymentStatus != 'paid') {
        codUnpaid += order.finalAmount;
      }
    }

    return protocol.AdminDashboardStats(
      todayOrders: todayOrders,
      todayRevenue: todayRevenue,
      totalOrders: orders.length,
      totalRevenue: totalRevenue,
      totalUsers: users,
      pendingOrders: pendingCount,
      confirmedOrders: confirmedCount,
      outForDeliveryOrders: outForDeliveryCount,
      deliveredOrders: deliveredCount,
      cancelledOrders: cancelledCount,
      codOrdersPlaced: codPlaced,
      codOrdersDelivered: codDelivered,
      codOrdersRejected: codRejected,
      codCollectedAmount: codCollected,
      codUnpaidAmount: codUnpaid,
      cashCollectionAmount: cashCollected,
      upiCollectionAmount: upiCollected,
    );
  }

  Future<protocol.AdminAnalytics> getAnalytics(Session session) async {
    final orders = await CustomerOrderRow.db.find(session);
    final products = await ProductRow.db.find(
      session,
      where: (t) => t.status.equals('active'),
      orderBy: (t) => t.mostPurchaseCount,
      orderDescending: true,
    );

    final productIds = products.map((product) => product.id!).toSet();
    final variants = productIds.isEmpty
        ? <ProductVariantRow>[]
        : await ProductVariantRow.db.find(
            session,
            where: (t) => t.productId.inSet(productIds),
          );
    final variantsByProduct = <String, List<ProductVariantRow>>{};
    for (final variant in variants) {
      variantsByProduct
          .putIfAbsent(variant.productId.toString(), () => [])
          .add(variant);
    }

    var lowStockCount = 0;
    final topProducts = <protocol.AdminTopProduct>[];
    for (final product in products) {
      final quantity = _formatQuantity(
        product,
        variantsByProduct[product.id!.toString()] ?? const [],
      );
      final numeric = _extractLeadingNumber(quantity);
      if (numeric != null && numeric <= 5) {
        lowStockCount++;
      }

      if (topProducts.length < 10) {
        topProducts.add(
          protocol.AdminTopProduct(
            name: product.name,
            mostPurchases: product.mostPurchaseCount,
            quantity: quantity,
          ),
        );
      }
    }

    final cancelled = orders
        .where((order) => order.orderStatus == 'cancelled')
        .length;
    final cancellationRate = orders.isEmpty
        ? 0.0
        : (cancelled / orders.length) * 100;

    // ── COD analytics ──
    var codPlaced = 0;
    var codDelivered = 0;
    final rejectionReasons = <String, int>{};
    for (final order in orders) {
      if (order.paymentMode != 'cod') continue;
      codPlaced++;
      if (order.orderStatus == 'delivered') codDelivered++;
      final reason = order.codFailureReason;
      if (reason != null && reason.isNotEmpty) {
        rejectionReasons[reason] = (rejectionReasons[reason] ?? 0) + 1;
      }
    }
    final codSuccessRate = codPlaced > 0
        ? (codDelivered / codPlaced) * 100
        : 0.0;
    final codRejectionReasonDistribution = rejectionReasons.isEmpty
        ? null
        : rejectionReasons.entries
            .map((e) => '"${e.key}": ${e.value}')
            .join(', ');

    return protocol.AdminAnalytics(
      cancellationRate: cancellationRate,
      lowStockCount: lowStockCount,
      topProducts: topProducts,
      codSuccessRate: codSuccessRate,
      codRejectionReasonDistribution: codRejectionReasonDistribution == null
          ? null
          : '{$codRejectionReasonDistribution}',
    );
  }

  Future<protocol.SmgmAnalytics> getSmgmAnalytics(Session session) async {
    final totalOffers = await protocol.ShopMoreGetMoreOfferRow.db.count(session);
    final activeOffers = await protocol.ShopMoreGetMoreOfferRow.db.count(
      session,
      where: (t) => t.status.equals('active'),
    );

    final smgmOrderItems = await OrderItemRow.db.find(
      session,
      where: (t) => t.rewardSource.equals('SHOP_MORE_GET_MORE'),
    );

    final totalRewardsGiven = smgmOrderItems.fold<int>(
      0,
      (sum, item) => sum + (item.quantity ?? 0),
    );
    final totalRewardValue = smgmOrderItems.fold<double>(
      0,
      (sum, item) => sum + (item.unitPrice ?? 0) * (item.quantity ?? 0),
    );

    final orderIds = smgmOrderItems
        .map((item) => item.orderId)
        .whereType<UuidValue>()
        .toSet();
    final totalOrdersWithSmgm = orderIds.length;

    return protocol.SmgmAnalytics(
      totalOffers: totalOffers,
      activeOffers: activeOffers,
      totalRewardsGiven: totalRewardsGiven,
      totalRewardValue: totalRewardValue,
      totalOrdersWithSmgm: totalOrdersWithSmgm,
    );
  }

  /// C3: Basic abuse tracking — returns SMGM reward stats for a user.
  Future<Map<String, int>> getUserSmgmStats(
    Session session,
    String userId,
  ) async {
    final parsedUserId = tryParseUuid(userId);
    if (parsedUserId == null) return {};

    final orders = await CustomerOrderRow.db.find(
      session,
      where: (t) => t.userId.equals(parsedUserId),
    );
    if (orders.isEmpty) {
      return {'totalRewards': 0, 'totalQuantity': 0, 'totalValue': 0};
    }

    final orderIds = orders.map((o) => o.id!).toSet();
    final items = await OrderItemRow.db.find(
      session,
      where: (t) =>
          t.orderId.inSet(orderIds) &
          t.rewardSource.equals('SHOP_MORE_GET_MORE'),
    );

    return {
      'totalRewards': items.length,
      'totalQuantity': items.fold<int>(
        0,
        (sum, i) => sum + (i.quantity ?? 0),
      ),
      'totalValue': items.fold<int>(
        0,
        (sum, i) =>
            sum +
            ((i.unitPrice ?? 0) * (i.quantity ?? 0)).toInt(),
      ),
    };
  }

  Future<List<protocol.AdminAuditLogEntry>> getAuditLogs(
    Session session, {
    int limit = 50,
  }) async {
    final rows = await AdminAuditLogRow.db.find(
      session,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: clampPageLimit(limit, defaultLimit: 50, maxLimit: 200),
    );

    return rows
        .map(
          (row) => protocol.AdminAuditLogEntry(
            id: row.id!.toString(),
            actorUid: row.actorUserId?.toString() ?? '',
            action: row.action,
            entityType: row.entityType,
            entityId:
                row.entityId?.toString() ?? row.metadata?['entityRef'] ?? '',
            createdAt: row.createdAt.toUtc().toIso8601String(),
          ),
        )
        .toList();
  }

  Future<List<protocol.ActiveUserStatistics>> getActiveUsersWithStats(
    Session session, {
    int limit = 100,
  }) async {
    final users = await AppUserRow.db.find(
      session,
      where: (t) => t.status.equals('active'),
      orderBy: (t) => t.updatedAt,
      orderDescending: true,
      limit: clampPageLimit(limit, defaultLimit: 100, maxLimit: 500),
    );

    final userIds = users.map((user) => user.id!).toSet();
    final userStats = await _getUserOrderStats(session, userIds);

    return users.map(
      (user) {
        final stats = userStats[user.id!.toString()] ?? {};
        return protocol.ActiveUserStatistics(
          userId: user.id!.toString(),
          name: user.name,
          phoneNumber: user.phoneNumber,
          email: user.email,
          totalOrdersCount: stats['count'] as int? ?? 0,
          totalSpent: stats['amount'] as double? ?? 0.0,
          lastOrderDate: stats['lastDate'] as DateTime?,
          status: user.status,
        );
      },
    ).toList();
  }

  Future<Map<String, Map<String, dynamic>>> _getUserOrderStats(
    Session session,
    Set<UuidValue> userIds,
  ) async {
    if (userIds.isEmpty) return const {};

    final orders = await CustomerOrderRow.db.find(
      session,
      where: (t) => t.userId.inSet(userIds) & t.orderStatus.equals('delivered'),
    );

    final stats = <String, Map<String, dynamic>>{};
    for (final order in orders) {
      final userId = order.userId.toString();
      if (!stats.containsKey(userId)) {
        stats[userId] = {
          'count': 0,
          'amount': 0.0,
          'lastDate': order.createdAt,
        };
      }
      final userStats = stats[userId]!;
      userStats['count'] = (userStats['count'] as int) + 1;

      final currentAmount = userStats['amount'] as double;
      userStats['amount'] = currentAmount + order.totalAmount;

      // Update last order date
      final lastDate = userStats['lastDate'] as DateTime;
      if (order.createdAt.isAfter(lastDate)) {
        userStats['lastDate'] = order.createdAt;
      }
    }
    return stats;
  }

  Future<Map<String, int>> _completedOrderCounts(
    Session session,
    Set<UuidValue> userIds,
  ) async {
    if (userIds.isEmpty) return const {};

    final orders = await CustomerOrderRow.db.find(
      session,
      where: (t) => t.userId.inSet(userIds) & t.orderStatus.equals('delivered'),
    );

    final counts = <String, int>{};
    for (final order in orders) {
      counts.update(
        order.userId.toString(),
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
    return counts;
  }

  bool _isAdminSellerRole(String? role) {
    final normalized = role?.trim();
    if (normalized == null || normalized.isEmpty) return false;

    final lowered = normalized.toLowerCase();
    return lowered == 'admin' ||
        lowered == 'seller' ||
        lowered == 'admin_seller' ||
        lowered == 'admin-seller' ||
        lowered == 'admin seller' ||
        normalized.toUpperCase() == 'ADMIN_SELLER';
  }

  Future<List<AppUserRow>> _activeAdminUsers(Session session) async {
    final users = await AppUserRow.db.find(
      session,
      where: (t) => t.status.equals('active'),
    );
    return users.where((user) => _isAdminSellerRole(user.role)).toList();
  }

  Future<bool> _relinkAdminByEmail(
    Session session,
    VerifiedFirebaseToken token,
  ) async {
    final email = token.email?.trim().toLowerCase();
    if (email == null || !_emailRegex.hasMatch(email)) return false;

    final match = _findAdminByEmail(await _activeAdminUsers(session), email);
    if (match == null) return false;

    await _updateAdminRow(
      session,
      match,
      firebaseUid: token.uid,
      email: email,
      username: match.name,
    );
    return true;
  }

  Future<AppUserRow?> _findAdminByFirebaseUid(
    Session session,
    String firebaseUid,
  ) async {
    return AppUserRow.db.findFirstRow(
      session,
      where: (t) => t.firebaseUid.equals(firebaseUid),
    );
  }

  Future<String> updateAdminUsername(
    Session session,
    String firebaseUid,
    String newUsername,
  ) async {
    final normalized = newUsername.trim().toLowerCase();
    if (normalized.isEmpty || !isValidUsername(normalized)) {
      throw ArgumentError(
        'Username must be 4-24 characters, start with a letter, '
        'and contain only lowercase letters, digits, and underscores.',
      );
    }

    final admin = await _findAdminByFirebaseUid(session, firebaseUid);
    if (admin == null) {
      throw StateError('Admin not found for the given Firebase UID.');
    }

    final now = DateTime.now().toUtc();
    await AppUserRow.db.updateRow(
      session,
      admin.copyWith(
        name: normalized,
        updatedAt: now,
      ),
    );

    return normalized;
  }

  AppUserRow? _findAdminByEmail(List<AppUserRow> users, String email) {
    for (final user in users) {
      if (user.email?.trim().toLowerCase() == email) return user;
    }
    return null;
  }

  Future<void> _updateAdminRow(
    Session session,
    AppUserRow row, {
    required String firebaseUid,
    required String email,
    String? username,
  }) async {
    await AppUserRow.db.updateRow(
      session,
      row.copyWith(
        firebaseUid: firebaseUid,
        phoneNumber: row.phoneNumber,
        name: _cleanUsername(username) ?? row.name,
        email: email,
        role: _adminRole,
        status: 'active',
        deactivatedAt: null,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
  }

  String? _cleanUsername(String? username) {
    final cleaned = username?.trim().toLowerCase();
    return cleaned == null || cleaned.isEmpty ? null : cleaned;
  }

  String _formatQuantity(
    ProductRow product,
    List<ProductVariantRow?> variants,
  ) {
    final sortedVariants = variants.whereType<ProductVariantRow>().toList()
      ..sort((a, b) {
        if (a.isDefault != b.isDefault) return b.isDefault ? 1 : -1;
        final sortCompare = a.sortOrder.compareTo(b.sortOrder);
        if (sortCompare != 0) return sortCompare;
        return a.label.compareTo(b.label);
      });

    for (final variant in sortedVariants) {
      final quantityDescription = cleanNullableString(
        variant.quantityDescription,
      );
      if (quantityDescription != null) return quantityDescription;
      return '${_compactNumber(variant.quantityValue)} ${variant.quantityUnit}';
    }

    final productDescription = cleanNullableString(product.quantityDescription);
    if (productDescription != null) return productDescription;

    if (product.baseQuantity != null &&
        cleanNullableString(product.baseUnit) != null) {
      return '${_compactNumber(product.baseQuantity!)} ${product.baseUnit!.trim()}';
    }
    return '';
  }

  String _compactNumber(double value) {
    final asInt = value.toInt();
    if (value == asInt.toDouble()) return '$asInt';
    return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
  }

  int? _extractLeadingNumber(String? quantityText) {
    final text = quantityText?.trim();
    if (text == null || text.isEmpty) return null;

    final buffer = StringBuffer();
    for (final rune in text.runes) {
      final char = String.fromCharCode(rune);
      if (char == '.' && buffer.toString().contains('.')) break;
      if (RegExp(r'[0-9.]').hasMatch(char)) {
        buffer.write(char);
      } else if (buffer.isNotEmpty) {
        break;
      }
    }

    if (buffer.isEmpty) return null;
    final parsed = double.tryParse(buffer.toString());
    return parsed?.round();
  }
}
