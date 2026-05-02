import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/postgres/postgres_banner_service.dart';

class BannerEndpoint extends Endpoint {
  final PostgresBannerService _banners = PostgresBannerService();

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
  }) {
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

  Future<Banner> createBanner(Session session, Banner banner) {
    return _banners.createBanner(session, banner);
  }

  Future<Banner> updateBanner(Session session, Banner banner) {
    return _banners.updateBanner(session, banner);
  }

  Future<void> deleteBanner(Session session, String bannerId) {
    return _banners.deleteBanner(session, bannerId);
  }

  Future<void> toggleBannerActive(
    Session session,
    String bannerId,
    bool active,
  ) {
    return _banners.toggleBannerActive(session, bannerId, active);
  }

  Future<void> updateBannerPriority(
    Session session,
    String bannerId,
    int priority,
  ) {
    return _banners.updateBannerPriority(session, bannerId, priority);
  }
}
