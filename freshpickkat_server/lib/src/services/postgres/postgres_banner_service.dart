import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../dependency_checker.dart';
import 'postgres_support.dart';

class PostgresBannerService {
  Future<List<Banner>> getInactiveBanners(Session session) async {
    final rows = await BannerRow.db.find(
      session,
      where: (t) => t.status.equals('inactive'),
      orderBy: (t) => t.priority,
      orderDescending: false,
    );
    return _hydrateBanners(session, rows);
  }

  Future<List<Banner>> getAllBanners(Session session) async {
    final rows = await BannerRow.db.find(
      session,
      orderBy: (t) => t.priority,
      orderDescending: false,
    );
    return _hydrateBanners(session, rows);
  }

  Future<List<Banner>> getBanners(
    Session session, {
    String? screen,
    bool activeOnly = true,
  }) async {
    final rows = await BannerRow.db.find(
      session,
      where: activeOnly ? (t) => t.status.equals('active') : null,
      orderBy: (t) => t.priority,
      orderDescending: false,
    );
    var banners = await _hydrateBanners(session, rows);
    final now = DateTime.now().toUtc();

    if (activeOnly) {
      banners = banners.where((banner) => banner.active).toList();
    }

    banners = banners.where((banner) {
      if (banner.isBaseImage) return true;
      return !now.isBefore(
            banner.startDate.subtract(const Duration(days: 1)),
          ) &&
          !now.isAfter(
            banner.endDate.add(const Duration(days: 1)),
          );
    }).toList();

    final normalizedScreen = cleanNullableString(screen);
    if (normalizedScreen != null) {
      banners = banners.where((banner) {
        final placements = banner.screenPlacements
            .split(',')
            .map((value) => value.trim())
            .where((value) => value.isNotEmpty)
            .toList();
        return placements.contains(normalizedScreen);
      }).toList();

      if (normalizedScreen == 'home_top_image') {
        final festive = banners.where((banner) => !banner.isBaseImage).toList()
          ..sort((a, b) => b.priority.compareTo(a.priority));
        if (festive.isNotEmpty) return [festive.first];

        final base = banners.where((banner) => banner.isBaseImage).toList();
        if (base.isNotEmpty) return [base.first];
        return const [];
      }
    }

    banners.sort((a, b) => a.priority.compareTo(b.priority));
    return banners;
  }

  Future<BannerPage> getBannersPage(
    Session session, {
    int limit = 20,
    String? pageToken,
    bool activeOnly = false,
    String? screen,
  }) async {
    final banners = await getBanners(
      session,
      screen: screen,
      activeOnly: activeOnly,
    );
    final offset = int.tryParse(pageToken ?? '') ?? 0;
    final safeOffset = offset.clamp(0, banners.length);
    final end = (safeOffset + clampPageLimit(limit, defaultLimit: 20)) //
        .clamp(0, banners.length);

    return BannerPage(
      banners: banners.sublist(safeOffset, end),
      nextPageToken: end < banners.length ? '$end' : null,
      totalCount: banners.length,
    );
  }

  Future<Banner?> getBannerById(Session session, String bannerId) async {
    final parsedId = tryParseUuid(bannerId);
    if (parsedId == null) return null;

    final row = await BannerRow.db.findById(session, parsedId);
    if (row == null) return null;

    final hydrated = await _hydrateBanners(session, [row]);
    return hydrated.isEmpty ? null : hydrated.first;
  }

  Future<Banner> createBanner(Session session, Banner banner) async {
    final row = await session.db.transaction<BannerRow>((transaction) async {
      final refs = await _resolveBannerRefs(session, banner);
      final placements = _normalizePlacements(banner.screenPlacements);
      final linkedProductIds = _normalizeLinkedProductIds(banner.linkedProductIds);
      final now = DateTime.now().toUtc();

      if (banner.isBaseImage && placements.isNotEmpty) {
        await _unsetOtherBaseImages(
          session,
          placements: placements,
          excludeBannerId: null,
          transaction: transaction,
        );
      }

      final inserted = await BannerRow.db.insertRow(
        session,
        BannerRow(
          title: banner.title.trim(),
          imageUrl: banner.imageUrl.trim(),
          actionType: banner.type.trim().isEmpty ? 'offer' : banner.type.trim(),
          offerId: cleanNullableString(banner.offerId),
          externalUrl: cleanNullableString(banner.externalUrl),
          linkedProductId: refs.primaryProductId,
          comboOfferId: refs.comboOfferId,
          couponId: refs.couponId,
          linkedCategoryId: refs.categoryId,
          linkedSubCategoryId: null,
          priority: banner.priority,
          isBaseImage: banner.isBaseImage,
          startsAt: banner.startDate.toUtc(),
          endsAt: banner.endDate.toUtc(),
          status: banner.active ? 'active' : 'inactive',
          deactivatedAt: banner.active ? null : now,
          createdAt: now,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      await _syncPlacements(
        session,
        bannerId: inserted.id!,
        placements: placements,
        transaction: transaction,
      );
      await _syncLinkedProducts(
        session,
        bannerId: inserted.id!,
        productIds: linkedProductIds,
        transaction: transaction,
      );
      return inserted;
    });

    return (await getBannerById(session, row.id!.toString()))!;
  }

  Future<Banner> updateBanner(Session session, Banner banner) async {
    final parsedId = parseUuid(
      banner.bannerId ?? '',
      fieldName: 'bannerId',
    );

    await session.db.transaction<void>((transaction) async {
      final existing = await BannerRow.db.findById(
        session,
        parsedId,
        transaction: transaction,
      );
      if (existing == null) {
        throw Exception('Banner not found.');
      }

      final refs = await _resolveBannerRefs(session, banner);
      final placements = _normalizePlacements(banner.screenPlacements);
      final linkedProductIds = _normalizeLinkedProductIds(banner.linkedProductIds);
      final now = DateTime.now().toUtc();

      if (banner.isBaseImage && placements.isNotEmpty) {
        await _unsetOtherBaseImages(
          session,
          placements: placements,
          excludeBannerId: parsedId,
          transaction: transaction,
        );
      }

      await BannerRow.db.updateRow(
        session,
        existing.copyWith(
          title: banner.title.trim(),
          imageUrl: banner.imageUrl.trim(),
          actionType: banner.type.trim().isEmpty
              ? existing.actionType
              : banner.type.trim(),
          offerId: cleanNullableString(banner.offerId),
          externalUrl: cleanNullableString(banner.externalUrl),
          linkedProductId: refs.primaryProductId,
          comboOfferId: refs.comboOfferId,
          couponId: refs.couponId,
          linkedCategoryId: refs.categoryId,
          linkedSubCategoryId: null,
          priority: banner.priority,
          isBaseImage: banner.isBaseImage,
          startsAt: banner.startDate.toUtc(),
          endsAt: banner.endDate.toUtc(),
          status: banner.active ? 'active' : 'inactive',
          deactivatedAt: banner.active ? null : now,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      await _syncPlacements(
        session,
        bannerId: parsedId,
        placements: placements,
        transaction: transaction,
      );
      await _syncLinkedProducts(
        session,
        bannerId: parsedId,
        productIds: linkedProductIds,
        transaction: transaction,
      );
    });

    return (await getBannerById(session, parsedId.toString()))!;
  }

  Future<String> deleteBanner(Session session, String bannerId) async {
    final parsedId = tryParseUuid(bannerId);
    if (parsedId == null) return 'Invalid banner ID';

    final row = await BannerRow.db.findById(session, parsedId);
    if (row == null) return 'Banner not found';

    final refs = await DependencyChecker.checkBanner(session, parsedId);
    if (refs.isNotEmpty) {
      return DependencyChecker.formatRefs(refs);
    }

    final now = DateTime.now().toUtc();
    await BannerRow.db.updateRow(
      session,
      row.copyWith(
        status: 'inactive',
        deactivatedAt: now,
        updatedAt: now,
      ),
    );
    return '';
  }

  Future<void> toggleBannerActive(
    Session session,
    String bannerId,
    bool active,
  ) async {
    final parsedId = tryParseUuid(bannerId);
    if (parsedId == null) return;

    final row = await BannerRow.db.findById(session, parsedId);
    if (row == null) return;

    final now = DateTime.now().toUtc();
    await BannerRow.db.updateRow(
      session,
      row.copyWith(
        status: active ? 'active' : 'inactive',
        deactivatedAt: active ? null : now,
        updatedAt: now,
      ),
    );
  }

  Future<void> updateBannerPriority(
    Session session,
    String bannerId,
    int priority,
  ) async {
    final parsedId = tryParseUuid(bannerId);
    if (parsedId == null) return;

    final row = await BannerRow.db.findById(session, parsedId);
    if (row == null) return;

    await BannerRow.db.updateRow(
      session,
      row.copyWith(
        priority: priority,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
  }

  Future<List<Banner>> _hydrateBanners(
    Session session,
    List<BannerRow> rows,
  ) async {
    if (rows.isEmpty) return const [];

    final bannerIds = rows.map((row) => row.id!).toSet();
    final placements = await BannerPlacementRow.db.find(
      session,
      where: (t) => t.bannerId.inSet(bannerIds),
      orderBy: (t) => t.createdAt,
      orderDescending: false,
    );
    final linkedProducts = await BannerLinkedProductRow.db.find(
      session,
      where: (t) => t.bannerId.inSet(bannerIds),
      orderBy: (t) => t.sortOrder,
      orderDescending: false,
    );

    final categoryIds = rows
        .map((row) => row.linkedCategoryId)
        .whereType<UuidValue>()
        .toSet();
    final categories = categoryIds.isEmpty
        ? <CategoryRow>[]
        : await CategoryRow.db.find(
            session,
            where: (t) => t.id.inSet(categoryIds),
          );
    final categoryById = {
      for (final category in categories) category.id!.toString(): category,
    };

    final couponIds = rows
        .map((row) => row.couponId)
        .whereType<UuidValue>()
        .toSet();
    final coupons = couponIds.isEmpty
        ? <CouponRow>[]
        : await CouponRow.db.find(
            session,
            where: (t) => t.id.inSet(couponIds),
          );
    final couponById = {
      for (final coupon in coupons) coupon.id!.toString(): coupon,
    };

    final placementsByBanner = <String, List<String>>{};
    for (final placement in placements) {
      placementsByBanner
          .putIfAbsent(placement.bannerId.toString(), () => [])
          .add(placement.placementKey);
    }

    final linkedProductsByBanner = <String, List<String>>{};
    for (final link in linkedProducts) {
      linkedProductsByBanner
          .putIfAbsent(link.bannerId.toString(), () => [])
          .add(link.productId.toString());
    }

    return rows
        .map((row) {
          final linkedIds = linkedProductsByBanner[row.id!.toString()];
          final categoryName = row.linkedCategoryId == null
              ? null
              : categoryById[row.linkedCategoryId.toString()]?.name;
          final couponCode = row.couponId == null
              ? null
              : couponById[row.couponId.toString()]?.code;
          return Banner(
            bannerId: row.id!.toString(),
            title: row.title,
            imageUrl: row.imageUrl,
            type: row.actionType,
            offerId: row.offerId,
            categoryId: categoryName,
            productId:
                row.linkedProductId?.toString() ??
                (linkedIds == null || linkedIds.isEmpty ? null : linkedIds.first),
            comboId: row.comboOfferId?.toString(),
            couponCode: couponCode,
            externalUrl: row.externalUrl,
            screenPlacements:
                (placementsByBanner[row.id!.toString()] ?? const <String>[])
                    .join(','),
            priority: row.priority,
            startDate: row.startsAt,
            endDate: row.endsAt,
            active: row.status == 'active',
            isBaseImage: row.isBaseImage,
            linkedProductIds: linkedIds,
            createdAt: row.createdAt,
            updatedAt: row.updatedAt,
          );
        })
        .toList();
  }

  Future<_BannerRefs> _resolveBannerRefs(Session session, Banner banner) async {
    final linkedProductIds = _normalizeLinkedProductIds(banner.linkedProductIds);
    final primaryProductId =
        tryParseUuid(banner.productId) ??
        (linkedProductIds.isEmpty ? null : linkedProductIds.first);
    final couponId = await _resolveCouponId(session, banner.couponCode);
    final categoryId = await _resolveCategoryId(session, banner.categoryId);

    return _BannerRefs(
      primaryProductId: primaryProductId,
      comboOfferId: tryParseUuid(banner.comboId),
      couponId: couponId,
      categoryId: categoryId,
    );
  }

  Future<UuidValue?> _resolveCouponId(
    Session session,
    String? couponCode,
  ) async {
    final normalizedCode = cleanNullableString(couponCode)?.toUpperCase();
    if (normalizedCode == null) return null;

    final row = await CouponRow.db.findFirstRow(
      session,
      where: (t) => t.code.equals(normalizedCode),
    );
    return row?.id;
  }

  Future<UuidValue?> _resolveCategoryId(
    Session session,
    String? categoryValue,
  ) async {
    final normalized = cleanNullableString(categoryValue);
    if (normalized == null) return null;

    final parsedId = tryParseUuid(normalized);
    if (parsedId != null) {
      final byId = await CategoryRow.db.findById(session, parsedId);
      if (byId != null) return byId.id;
    }

    final rows = await CategoryRow.db.find(
      session,
      where: (t) => t.status.equals('active'),
    );
    final lowered = normalized.toLowerCase();
    for (final row in rows) {
      if (row.name.trim().toLowerCase() == lowered) {
        return row.id;
      }
    }
    return null;
  }

  List<String> _normalizePlacements(String rawPlacements) {
    final seen = <String>{};
    final placements = <String>[];
    for (final part in rawPlacements.split(',')) {
      final trimmed = part.trim();
      if (trimmed.isEmpty || !seen.add(trimmed)) continue;
      placements.add(trimmed);
    }
    return placements;
  }

  List<UuidValue> _normalizeLinkedProductIds(List<String>? linkedProductIds) {
    if (linkedProductIds == null || linkedProductIds.isEmpty) return const [];
    final seen = <String>{};
    final productIds = <UuidValue>[];
    for (final rawId in linkedProductIds) {
      final parsedId = tryParseUuid(rawId);
      if (parsedId == null) continue;
      if (!seen.add(parsedId.toString())) continue;
      productIds.add(parsedId);
    }
    return productIds;
  }

  Future<void> _syncPlacements(
    Session session, {
    required UuidValue bannerId,
    required List<String> placements,
    required Transaction transaction,
  }) async {
    final existing = await BannerPlacementRow.db.find(
      session,
      where: (t) => t.bannerId.equals(bannerId),
      transaction: transaction,
    );
    if (existing.isNotEmpty) {
      await BannerPlacementRow.db.delete(
        session,
        existing,
        transaction: transaction,
      );
    }

    for (final placement in placements) {
      await BannerPlacementRow.db.insertRow(
        session,
        BannerPlacementRow(
          bannerId: bannerId,
          placementKey: placement,
          createdAt: DateTime.now().toUtc(),
        ),
        transaction: transaction,
      );
    }
  }

  Future<void> _syncLinkedProducts(
    Session session, {
    required UuidValue bannerId,
    required List<UuidValue> productIds,
    required Transaction transaction,
  }) async {
    final existing = await BannerLinkedProductRow.db.find(
      session,
      where: (t) => t.bannerId.equals(bannerId),
      transaction: transaction,
    );
    if (existing.isNotEmpty) {
      await BannerLinkedProductRow.db.delete(
        session,
        existing,
        transaction: transaction,
      );
    }

    for (var i = 0; i < productIds.length; i++) {
      await BannerLinkedProductRow.db.insertRow(
        session,
        BannerLinkedProductRow(
          bannerId: bannerId,
          productId: productIds[i],
          sortOrder: i,
          createdAt: DateTime.now().toUtc(),
        ),
        transaction: transaction,
      );
    }
  }

  Future<void> _unsetOtherBaseImages(
    Session session, {
    required List<String> placements,
    required UuidValue? excludeBannerId,
    required Transaction transaction,
  }) async {
    if (placements.isEmpty) return;

    final placementRows = await BannerPlacementRow.db.find(
      session,
      where: (t) => t.placementKey.inSet(placements.toSet()),
      transaction: transaction,
    );
    final bannerIds = placementRows
        .map((row) => row.bannerId)
        .where((id) => excludeBannerId == null || id != excludeBannerId)
        .toSet();
    if (bannerIds.isEmpty) return;

    final rows = await BannerRow.db.find(
      session,
      where: (t) => t.id.inSet(bannerIds),
      transaction: transaction,
    );
    final now = DateTime.now().toUtc();
    for (final row in rows) {
      if (!row.isBaseImage) continue;
      await BannerRow.db.updateRow(
        session,
        row.copyWith(
          isBaseImage: false,
          updatedAt: now,
        ),
        transaction: transaction,
      );
    }
  }
}

class _BannerRefs {
  _BannerRefs({
    required this.primaryProductId,
    required this.comboOfferId,
    required this.couponId,
    required this.categoryId,
  });

  final UuidValue? primaryProductId;
  final UuidValue? comboOfferId;
  final UuidValue? couponId;
  final UuidValue? categoryId;
}
