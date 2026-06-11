import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/postgres/postgres_home_service.dart';

class HomeEndpoint extends Endpoint {
  final PostgresHomeService _homeService = PostgresHomeService();

  Future<HomePageHydratedData> getHomePageHydrated(
    Session session, {
    String? userId,
    int productLimit = 20,
    int rankingLimit = 10,
  }) {
    return _homeService.getHomePageHydrated(
      session,
      userId: userId,
      productLimit: productLimit,
      rankingLimit: rankingLimit,
    );
  }
}
