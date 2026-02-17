import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class UserEndpoint extends Endpoint {
  Future<AppUser?> getUserByFirebaseUid(Session session, String uid) async {
    return await AppUser.db.findFirstRow(
      session,
      where: (t) => t.firebaseUid.equals(uid),
    );
  }

  Future<AppUser> createOrUpdateUser(Session session, AppUser user) async {
    var existingUser = await getUserByFirebaseUid(session, user.firebaseUid);
    if (existingUser != null) {
      user.id = existingUser.id;
      return await AppUser.db.updateRow(session, user);
    } else {
      return await AppUser.db.insertRow(session, user);
    }
  }

  Future<bool> updateCart(
    Session session,
    String uid,
    List<CartItem> cart,
  ) async {
    var user = await getUserByFirebaseUid(session, uid);
    if (user != null) {
      user.cart = cart;
      await AppUser.db.updateRow(session, user);
      return true;
    }
    return false;
  }
}
