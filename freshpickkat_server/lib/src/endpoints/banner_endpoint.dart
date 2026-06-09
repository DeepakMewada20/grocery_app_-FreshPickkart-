import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_banner_service.dart';

class BannerEndpoint extends Endpoint {
  final PostgresBannerService _banners = PostgresBannerService();
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();

  Future<List<Banner>> getInactiveBanners(Session session) async {
    return _banners.getInactiveBanners(session);
  }

  Future<List<Banner>> getBanners(
    Session session, {
    String? screen,
    bool activeOnly = true,
  }) async {
    try {
      return _banners.getBanners(
        session,
        screen: screen,
        activeOnly: activeOnly,
      );
    } catch (error) {
      session.log(
        'BannerEndpoint.getBanners error: $error',
        level: LogLevel.error,
      );
      return const [];
    }
  }

  Future<BannerPage> getBannersPage(
    Session session, {
    int limit = 20,
    String? pageToken,
    bool activeOnly = false,
    String? screen,
    String? firebaseUid,
    String? idToken,
  }) async {
    if (!activeOnly) {
      await _ensureAdmin(session, firebaseUid, idToken);
    }
    return _banners.getBannersPage(
      session,
      limit: limit,
      pageToken: pageToken,
      activeOnly: activeOnly,
      screen: screen,
    );
  }

  Future<Banner?> getBannerById(Session session, String bannerId) {
    return _banners.getBannerById(session, bannerId);
  }

  Future<Banner> createBanner(
    Session session,
    Banner banner,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _banners.createBanner(session, banner);
  }

  Future<Banner> updateBanner(
    Session session,
    Banner banner,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _banners.updateBanner(session, banner);
  }

  Future<String> deleteBanner(
    Session session,
    String bannerId,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _banners.deleteBanner(session, bannerId);
  }

  Future<void> toggleBannerActive(
    Session session,
    String bannerId,
    bool active,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _banners.toggleBannerActive(session, bannerId, active);
  }

  Future<void> updateBannerPriority(
    Session session,
    String bannerId,
    int priority,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _banners.updateBannerPriority(session, bannerId, priority);
  }

  Future<void> _ensureAdmin(
    Session session,
    String? firebaseUid,
    String? idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid ?? '',
      idToken: idToken ?? '',
    );
  }
}
