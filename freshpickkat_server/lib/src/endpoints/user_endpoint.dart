import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/postgres/postgres_user_service.dart';

class UserEndpoint extends Endpoint {
  final PostgresUserService _users = PostgresUserService();

  Future<AppUser?> getUserByFirebaseUid(Session session, String uid) async {
    return _users.getUserByFirebaseUid(session, uid);
  }

  Future<AppUser> createOrUpdateUser(Session session, AppUser user) async {
    return _users.createOrUpdateUser(session, user);
  }

  Future<bool> updateCart(
    Session session,
    String uid,
    List<CartItem> cart,
  ) async {
    return _users.updateCart(session, uid, cart);
  }

  Future<bool> updateFcmToken(
    Session session,
    String uid,
    String token,
  ) async {
    return _users.updateFcmToken(session, uid, token);
  }
}
