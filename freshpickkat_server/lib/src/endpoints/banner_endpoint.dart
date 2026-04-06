import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/firebase_service.dart';
import '../services/id_generator.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;

class BannerEndpoint extends Endpoint {
  static const String bannerCollection = 'Banners';
  static const String projectId = 'freshpickkart-a6824';
  final String _database = 'projects/$projectId/databases/(default)/documents';

  Future<List<Banner>> getBanners(
    Session session, {
    String? screen,
    bool activeOnly = true,
  }) async {
    final firestore = await FirebaseService.getFirestoreClient();

    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: bannerCollection)],
    );

    final response = await firestore.projects.databases.documents.runQuery(
      firestore_api.RunQueryRequest(structuredQuery: query),
      _database,
    );

    final now = DateTime.now();
    final banners = <Banner>[];

    for (final res in response) {
      if (res.document == null) continue;
      final fields = res.document!.fields!;

      DateTime startDate = DateTime.now();
      DateTime endDate = DateTime.now().add(const Duration(days: 30));

      if (fields['startDate']?.timestampValue != null) {
        startDate =
            DateTime.tryParse(fields['startDate']!.timestampValue!) ??
            DateTime.now();
      }

      if (fields['endDate']?.timestampValue != null) {
        endDate =
            DateTime.tryParse(fields['endDate']!.timestampValue!) ??
            DateTime.now();
      }

      banners.add(
        Banner(
          bannerId: res.document!.name!.split('/').last,
          title: fields['title']?.stringValue ?? '',
          imageUrl: fields['imageUrl']?.stringValue ?? '',
          type: fields['type']?.stringValue ?? 'offer',
          offerId: fields['offerId']?.stringValue,
          categoryId: fields['categoryId']?.stringValue,
          productId: fields['productId']?.stringValue,
          comboId: fields['comboId']?.stringValue,
          couponCode: fields['couponCode']?.stringValue,
          externalUrl: fields['externalUrl']?.stringValue,
          screenPlacements: fields['screenPlacements']?.stringValue ?? '',
          priority:
              int.tryParse(fields['priority']?.integerValue ?? '99') ?? 99,
          startDate: startDate,
          endDate: endDate,
          active: fields['active']?.booleanValue ?? false,
          createdAt:
              DateTime.tryParse(fields['createdAt']?.timestampValue ?? '') ??
              DateTime.now(),
          updatedAt: fields['updatedAt'] != null
              ? DateTime.tryParse(fields['updatedAt']!.timestampValue ?? '')
              : null,
        ),
      );
    }

    var filteredBanners = banners.toList();

    if (activeOnly) {
      filteredBanners = filteredBanners.where((b) => b.active).toList();
    }

    filteredBanners = filteredBanners.where((b) {
      return now.isAfter(b.startDate.subtract(const Duration(days: 1))) &&
          now.isBefore(b.endDate.add(const Duration(days: 1)));
    }).toList();

    if (screen != null && screen.isNotEmpty) {
      filteredBanners = filteredBanners.where((b) {
        final placements = b.screenPlacements
            .split(',')
            .map((s) => s.trim())
            .toList();
        return placements.contains(screen);
      }).toList();
    }

    filteredBanners.sort((a, b) => a.priority.compareTo(b.priority));

    return filteredBanners;
  }

  Future<BannerPage> getBannersPage(
    Session session, {
    int limit = 20,
    String? pageToken,
    bool activeOnly = false,
    String? screen,
  }) async {
    final allBanners = await getBanners(
      session,
      activeOnly: activeOnly,
      screen: screen,
    );
    final offset = int.tryParse(pageToken ?? '') ?? 0;
    final safeOffset = offset.clamp(0, allBanners.length);
    final end = (safeOffset + limit).clamp(0, allBanners.length);
    final pageItems = allBanners.sublist(safeOffset, end);
    final nextOffset = end < allBanners.length ? '$end' : null;

    return BannerPage(
      banners: pageItems,
      nextPageToken: nextOffset,
      totalCount: allBanners.length,
    );
  }

  Future<Banner?> getBannerById(Session session, String bannerId) async {
    final firestore = await FirebaseService.getFirestoreClient();

    try {
      final doc = await firestore.projects.databases.documents.get(
        '$_database/$bannerCollection/$bannerId',
      );

      if (doc.fields == null) return null;

      final fields = doc.fields!;

      DateTime startDate = DateTime.now();
      DateTime endDate = DateTime.now().add(const Duration(days: 30));

      if (fields['startDate']?.timestampValue != null) {
        startDate =
            DateTime.tryParse(fields['startDate']!.timestampValue!) ??
            DateTime.now();
      }

      if (fields['endDate']?.timestampValue != null) {
        endDate =
            DateTime.tryParse(fields['endDate']!.timestampValue!) ??
            DateTime.now();
      }

      return Banner(
        bannerId: bannerId,
        title: fields['title']?.stringValue ?? '',
        imageUrl: fields['imageUrl']?.stringValue ?? '',
        type: fields['type']?.stringValue ?? 'offer',
        offerId: fields['offerId']?.stringValue,
        categoryId: fields['categoryId']?.stringValue,
        productId: fields['productId']?.stringValue,
        comboId: fields['comboId']?.stringValue,
        couponCode: fields['couponCode']?.stringValue,
        externalUrl: fields['externalUrl']?.stringValue,
        screenPlacements: fields['screenPlacements']?.stringValue ?? '',
        priority: int.tryParse(fields['priority']?.integerValue ?? '99') ?? 99,
        startDate: startDate,
        endDate: endDate,
        active: fields['active']?.booleanValue ?? false,
        createdAt:
            DateTime.tryParse(fields['createdAt']?.timestampValue ?? '') ??
            DateTime.now(),
        updatedAt: fields['updatedAt'] != null
            ? DateTime.tryParse(fields['updatedAt']!.timestampValue ?? '')
            : null,
      );
    } catch (e) {
      return null;
    }
  }

  Future<Banner> createBanner(Session session, Banner banner) async {
    final firestore = await FirebaseService.getFirestoreClient();

    String? bannerId = banner.bannerId;
    if (bannerId == null || bannerId.trim().isEmpty) {
      bannerId = IdGenerator.generateBannerId();
    }

    final now = DateTime.now();

    final fields = _bannerToFields(banner, now);

    await firestore.projects.databases.documents.createDocument(
      firestore_api.Document(fields: fields),
      _database,
      bannerCollection,
      documentId: bannerId,
    );

    return (await getBannerById(session, bannerId))!;
  }

  Future<Banner> updateBanner(Session session, Banner banner) async {
    if (banner.bannerId == null) {
      throw Exception('Banner ID is required for update');
    }

    final firestore = await FirebaseService.getFirestoreClient();
    final docPath = '$_database/$bannerCollection/${banner.bannerId}';
    final fields = _bannerToFields(banner, DateTime.now());

    await firestore.projects.databases.documents.patch(
      firestore_api.Document(fields: fields),
      docPath,
      updateMask_fieldPaths: fields.keys.toList(),
    );

    return (await getBannerById(session, banner.bannerId!))!;
  }

  Future<void> deleteBanner(Session session, String bannerId) async {
    final firestore = await FirebaseService.getFirestoreClient();

    await firestore.projects.databases.documents.delete(
      '$_database/$bannerCollection/$bannerId',
    );
  }

  Future<void> toggleBannerActive(
    Session session,
    String bannerId,
    bool active,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final docPath = '$_database/$bannerCollection/$bannerId';

    await firestore.projects.databases.documents.patch(
      firestore_api.Document(
        fields: {
          'active': firestore_api.Value(booleanValue: active),
          'updatedAt': firestore_api.Value(
            timestampValue: DateTime.now().toUtc().toIso8601String(),
          ),
        },
      ),
      docPath,
      updateMask_fieldPaths: ['active', 'updatedAt'],
    );
  }

  Future<void> updateBannerPriority(
    Session session,
    String bannerId,
    int priority,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final docPath = '$_database/$bannerCollection/$bannerId';

    await firestore.projects.databases.documents.patch(
      firestore_api.Document(
        fields: {
          'priority': firestore_api.Value(integerValue: priority.toString()),
          'updatedAt': firestore_api.Value(
            timestampValue: DateTime.now().toUtc().toIso8601String(),
          ),
        },
      ),
      docPath,
      updateMask_fieldPaths: ['priority', 'updatedAt'],
    );
  }

  Map<String, firestore_api.Value> _bannerToFields(
    Banner banner,
    DateTime timestamp,
  ) {
    final fields = <String, firestore_api.Value>{
      'title': firestore_api.Value(stringValue: banner.title),
      'imageUrl': firestore_api.Value(stringValue: banner.imageUrl),
      'type': firestore_api.Value(stringValue: banner.type),
      'screenPlacements': firestore_api.Value(
        stringValue: banner.screenPlacements,
      ),
      'priority': firestore_api.Value(integerValue: banner.priority.toString()),
      'startDate': firestore_api.Value(
        timestampValue: banner.startDate.toUtc().toIso8601String(),
      ),
      'endDate': firestore_api.Value(
        timestampValue: banner.endDate.toUtc().toIso8601String(),
      ),
      'active': firestore_api.Value(booleanValue: banner.active),
      'createdAt': firestore_api.Value(
        timestampValue: timestamp.toUtc().toIso8601String(),
      ),
    };

    if (banner.offerId != null) {
      fields['offerId'] = firestore_api.Value(stringValue: banner.offerId!);
    }
    if (banner.categoryId != null) {
      fields['categoryId'] = firestore_api.Value(
        stringValue: banner.categoryId!,
      );
    }
    if (banner.productId != null) {
      fields['productId'] = firestore_api.Value(stringValue: banner.productId!);
    }
    if (banner.comboId != null) {
      fields['comboId'] = firestore_api.Value(stringValue: banner.comboId!);
    }
    if (banner.couponCode != null) {
      fields['couponCode'] = firestore_api.Value(
        stringValue: banner.couponCode!,
      );
    }
    if (banner.externalUrl != null) {
      fields['externalUrl'] = firestore_api.Value(
        stringValue: banner.externalUrl!,
      );
    }

    return fields;
  }
}
