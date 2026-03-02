import 'package:serverpod/serverpod.dart';

class AuthEndpoint extends Endpoint {
  Future<bool> signOut(Session session, String uid) async {
    return true;
  }
}
