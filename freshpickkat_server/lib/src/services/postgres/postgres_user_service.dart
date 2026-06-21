import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../bogo/bogo_eligibility.dart';
import 'postgres_referral_service.dart';
import 'postgres_support.dart';
import 'postgres_offer_service.dart';
import 'postgres_product_compat_service.dart';

class PostgresUserService {
  final PostgresOfferService _offerService = PostgresOfferService();
  final PostgresProductCompatService _productService =
      PostgresProductCompatService();

  Future<AppUser?> getUserByFirebaseUid(
    Session session,
    String firebaseUid,
  ) async {
    final user = await _findUserByFirebaseUid(
      session,
      firebaseUid,
      activeOnly: true,
    );
    if (user == null) return null;

    return _hydrateUser(session, user);
  }

  Future<AppUser> createOrUpdateUser(Session session, AppUser user) async {
    final firebaseUid = cleanNullableString(user.firebaseUid);
    if (firebaseUid == null) {
      throw Exception('firebaseUid is required.');
    }

    await session.db.transaction<void>((transaction) async {
      final now = DateTime.now().toUtc();
      var existing = await _findUserByFirebaseUid(
        session,
        firebaseUid,
        activeOnly: false,
        transaction: transaction,
      );

      existing ??= await _findUserByPhoneNumber(
        session,
        user.phoneNumber.trim(),
        transaction: transaction,
      );

      final role = cleanNullableString(user.role) ?? 'user';
      final isNewUser = existing == null;
      final persisted = isNewUser
          ? await AppUserRow.db.insertRow(
              session,
              AppUserRow(
                firebaseUid: firebaseUid,
                phoneNumber: user.phoneNumber.trim(),
                name: user.name,
                email: user.email,
                role: role,
                fcmToken: cleanNullableString(user.fcmToken),
                status: 'active',
                createdAt: now,
                updatedAt: now,
              ),
              transaction: transaction,
            )
          : await AppUserRow.db.updateRow(
              session,
              existing.copyWith(
                firebaseUid: firebaseUid,
                phoneNumber: user.phoneNumber.trim(),
                name: user.name ?? existing.name,
                email: user.email ?? existing.email,
                fcmToken: user.fcmToken ?? existing.fcmToken,
                status: 'active',
                deactivatedAt: null,
                updatedAt: now,
              ),
              transaction: transaction,
            );

      final persistedId = persisted.id;
      if (persistedId == null) {
        throw Exception('Failed to persist user.');
      }

      if (user.shippingAddress != null) {
        await _upsertDefaultAddress(
          session,
          userId: persistedId,
          address: user.shippingAddress!,
          transaction: transaction,
        );
      }

      if (user.cart != null) {
        await _replaceCart(
          session,
          userId: persistedId,
          cart: user.cart!,
          transaction: transaction,
        );
      }

      if (isNewUser) {
        final referral = PostgresReferralService();
        await referral.getOrCreateReferralCodeForUser(session, persistedId);
      }
    });

    final hydrated = await getUserByFirebaseUid(session, firebaseUid);
    if (hydrated == null) {
      throw Exception('Failed to load user.');
    }
    return hydrated;
  }

  Future<bool> updateCart(
    Session session,
    String firebaseUid,
    List<CartItem> cart,
  ) async {
    final user = await _findUserByFirebaseUid(
      session,
      firebaseUid,
      activeOnly: true,
    );
    if (user?.id == null) return false;
    final sanitizedCart = await _sanitizeCartBogoSelections(session, cart);

    await session.db.transaction<void>((transaction) async {
      await _replaceCart(
        session,
        userId: user!.id!,
        cart: sanitizedCart,
        transaction: transaction,
      );
      await AppUserRow.db.updateById(
        session,
        user.id!,
        columnValues: (t) => [t.updatedAt(DateTime.now().toUtc())],
        transaction: transaction,
      );
    });
    return true;
  }

  Future<List<CartItem>> _sanitizeCartBogoSelections(
    Session session,
    List<CartItem> cart,
  ) async {
    final bogoItems = cart
        .where((item) => item.bogoFreeProductId?.trim().isNotEmpty == true)
        .toList();
    if (bogoItems.isEmpty) return cart;

    final productIds = <String>{};
    for (final item in bogoItems) {
      productIds.add(item.productId);
      productIds.add(item.bogoFreeProductId!);
    }
    final products = await _productService.getProductsByIds(
      session,
      productIds.toList(),
    );
    final productById = {
      for (final product in products)
        if (product.productId != null) product.productId!: product,
    };
    final offers = await _offerService.getActiveBogoOffersForProducts(
      session,
      bogoItems.map((item) => item.productId).toSet().toList(),
    );

    return cart
        .map((item) {
          final freeProductId = item.bogoFreeProductId?.trim();
          if (freeProductId == null || freeProductId.isEmpty) return item;

          final triggerProduct = productById[item.productId];
          final freeProduct = productById[freeProductId];
          final offer = offers.firstWhere(
            (candidate) =>
                candidate.isActive &&
                candidate.triggerProductId == item.productId,
            orElse: () => BogoOffer(
              triggerProductId: '',
              freeProductIds: const [],
              offerTitle: '',
              isActive: false,
              startDate: DateTime.fromMillisecondsSinceEpoch(0),
              endDate: DateTime.fromMillisecondsSinceEpoch(0),
              createdAt: DateTime.fromMillisecondsSinceEpoch(0),
            ),
          );

          final reward = offer.triggerProductId.isEmpty
              ? null
              : findBogoReward(offer, freeProductId: freeProductId);
          final valid =
              triggerProduct != null &&
              freeProduct != null &&
              reward != null &&
              isBogoTriggerEligibleForQuantity(
                triggerProduct: triggerProduct,
                offer: offer,
                selectedVariantId: item.variantId,
                quantity: item.quantity,
              );

          if (valid) return item;
          return item.copyWith(bogoFreeProductId: null);
        })
        .toList(growable: false);
  }

  Future<bool> updateFcmToken(
    Session session,
    String firebaseUid,
    String token,
  ) async {
    final user = await _findUserByFirebaseUid(
      session,
      firebaseUid,
      activeOnly: true,
    );
    if (user?.id == null) return false;

    await AppUserRow.db.updateById(
      session,
      user!.id!,
      columnValues: (t) => [
        t.fcmToken(cleanNullableString(token)),
        t.updatedAt(DateTime.now().toUtc()),
      ],
    );
    return true;
  }

  Future<AppUser> _hydrateUser(Session session, AppUserRow user) async {
    final userId = user.id;
    final defaultAddress = userId == null
        ? null
        : await _loadDefaultAddress(session, userId);
    final cart = userId == null
        ? const <CartItem>[]
        : await _loadCart(session, userId);
    final completedOrdersCount = userId == null
        ? 0
        : await CustomerOrderRow.db.count(
            session,
            where: (t) =>
                t.userId.equals(userId) & t.orderStatus.equals('delivered'),
          );

    return AppUser(
      firebaseUid: user.firebaseUid ?? '',
      phoneNumber: user.phoneNumber,
      name: user.name,
      email: user.email,
      shippingAddress: defaultAddress,
      cart: cart,
      role: cleanNullableString(user.role) ?? 'user',
      fcmToken: user.fcmToken,
      completedOrdersCount: completedOrdersCount,
      currentFreshPoints: user.currentFreshPoints,
      totalEarned: user.totalEarned,
      totalRedeemed: user.totalRedeemed,
    );
  }

  Future<AppUserRow?> _findUserByFirebaseUid(
    Session session,
    String firebaseUid, {
    required bool activeOnly,
    Transaction? transaction,
  }) {
    final normalized = cleanNullableString(firebaseUid);
    if (normalized == null) return Future.value(null);

    return AppUserRow.db.findFirstRow(
      session,
      where: (t) => activeOnly
          ? t.firebaseUid.equals(normalized) & t.status.equals('active')
          : t.firebaseUid.equals(normalized),
      transaction: transaction,
    );
  }

  Future<AppUserRow?> _findUserByPhoneNumber(
    Session session,
    String phoneNumber, {
    Transaction? transaction,
  }) {
    final normalized = phoneNumber.trim();
    if (normalized.isEmpty) return Future.value(null);

    return AppUserRow.db.findFirstRow(
      session,
      where: (t) => t.phoneNumber.equals(normalized),
      transaction: transaction,
    );
  }

  Future<Address?> _loadDefaultAddress(
    Session session,
    UuidValue userId,
  ) async {
    final addresses = await UserAddressRow.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );
    if (addresses.isEmpty) return null;

    addresses.sort((a, b) {
      if (a.isDefault != b.isDefault) {
        return a.isDefault ? -1 : 1;
      }
      return b.updatedAt.compareTo(a.updatedAt);
    });

    final row = addresses.first;
    return Address(
      street: row.streetLine1,
      city: row.city,
      state: row.state,
      zipCode: row.postalCode,
      country: row.country,
      latitude: row.latitude,
      longitude: row.longitude,
    );
  }

  Future<List<CartItem>> _loadCart(
    Session session,
    UuidValue userId,
  ) async {
    final rows = await UserCartItemRow.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );
    rows.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return rows
        .map(
          (row) => CartItem(
            productId: row.productId,
            variantId: row.variantId,
            quantity: row.quantity,
            bogoFreeProductId: row.bogoFreeProductId,
            comboId: row.comboId,
            comboName: row.comboName,
            comboDiscountType: row.comboDiscountType,
            comboDiscountValue: row.comboDiscountValue,
            comboItemQuantity: row.comboItemQuantity,
          ),
        )
        .toList();
  }

  Future<void> _upsertDefaultAddress(
    Session session, {
    required UuidValue userId,
    required Address address,
    Transaction? transaction,
  }) async {
    final existing = await UserAddressRow.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      transaction: transaction,
    );

    final target = existing.cast<UserAddressRow?>().firstWhere(
      (row) => row?.isDefault == true,
      orElse: () => existing.isEmpty ? null : existing.first,
    );

    final now = DateTime.now().toUtc();
    final normalized = UserAddressRow(
      userId: userId,
      label: target?.label ?? 'shipping',
      recipientName: null,
      phoneNumber: null,
      streetLine1: address.street.trim(),
      streetLine2: null,
      landmark: null,
      city: address.city.trim(),
      state: address.state.trim(),
      postalCode: address.zipCode.trim(),
      country: address.country.trim(),
      latitude: address.latitude,
      longitude: address.longitude,
      isDefault: true,
      createdAt: target?.createdAt ?? now,
      updatedAt: now,
    );

    if (target?.id == null) {
      await UserAddressRow.db.insertRow(
        session,
        normalized,
        transaction: transaction,
      );
      return;
    }

    await UserAddressRow.db.updateRow(
      session,
      normalized.copyWith(id: target!.id),
      transaction: transaction,
    );
  }

  Future<void> _replaceCart(
    Session session, {
    required UuidValue userId,
    required List<CartItem> cart,
    Transaction? transaction,
  }) async {
    await UserCartItemRow.db.deleteWhere(
      session,
      where: (t) => t.userId.equals(userId),
      transaction: transaction,
    );

    final now = DateTime.now().toUtc();
    for (final item in cart) {
      await UserCartItemRow.db.insertRow(
        session,
        UserCartItemRow(
          userId: userId,
          productId: item.productId.trim(),
          variantId: cleanNullableString(item.variantId),
          quantity: item.quantity,
          bogoFreeProductId: cleanNullableString(item.bogoFreeProductId),
          comboId: cleanNullableString(item.comboId),
          comboName: cleanNullableString(item.comboName),
          comboDiscountType: cleanNullableString(item.comboDiscountType),
          comboDiscountValue: item.comboDiscountValue,
          comboItemQuantity: item.comboItemQuantity,
          createdAt: now,
          updatedAt: now,
        ),
        transaction: transaction,
      );
    }
  }
}
