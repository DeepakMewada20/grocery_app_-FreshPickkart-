import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart'
    show
        AdminAuditLogRow,
        AppUserRow,
        CustomerOrderRow,
        ProductRow,
        ProductVariantRow;
import '../../generated/protocol.dart' as protocol;
import '../firebase_auth_service.dart';
import 'postgres_support.dart';

class PostgresAdminService {
  static final RegExp _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  Future<bool> isAdminSetupCompleted(Session session) async {
    return await AppUserRow.db.count(
          session,
          where: (t) => t.status.equals('active'),
        ) >
        0;
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
      final email = user.email?.trim().toLowerCase();
      final localPart = email == null || !email.contains('@')
          ? null
          : email.split('@').first;
      final name = user.name?.trim().toLowerCase();
      if (localPart == normalized || name == normalized) {
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
    if (user == null || !_isAdminSellerRole(user.role)) {
      return protocol.AdminAuthResult(
        ok: false,
        message: 'Access denied: ADMIN_SELLER role required.',
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

    return protocol.AdminAnalytics(
      cancellationRate: cancellationRate,
      lowStockCount: lowStockCount,
      topProducts: topProducts,
    );
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
