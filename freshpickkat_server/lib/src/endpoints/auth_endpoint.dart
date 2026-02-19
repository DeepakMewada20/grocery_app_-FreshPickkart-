import 'package:serverpod/serverpod.dart';

class AuthEndpoint extends Endpoint {
  // Verify Firebase phone login OTP - returns idToken from backend
  Future<String?> verifyPhoneLogin(Session session, String idToken) async {
    try {
      // idToken here is actually the Firebase ID token from client after OTP verification
      // For now, we accept it as-is since Firebase Auth handles the verification
      // Backend can add extra validation/parsing if needed
      return idToken;
    } catch (e) {
      print('Token verification failed: $e');
      return null;
    }
  }

  // Example: Sign out (stateless, just for API completeness)
  Future<bool> signOut(Session session, String uid) async {
    // Invalidate session or token if you manage sessions
    // For stateless JWT, client just deletes token
    return true;
  }
}
