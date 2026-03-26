import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'network_status_service.dart';
import 'serverpod_client.dart';

class AdminAuthService {
  static const String _sellerCollection = 'sellers';
  static const String _adminRole = 'ADMIN_SELLER';
  static const int usernameMinLength = 4;
  static const int usernameMaxLength = 24;
  static final RegExp _usernameRegex = RegExp(r'^[a-z][a-z0-9_]{3,23}$');
  static final RegExp _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static const String usernameRuleText =
      'Username must be 4-24 chars, start with a letter, and use only a-z, 0-9, _.';
  static const String emailRuleText = 'Enter a valid email address.';

  final _client = ServerpodAdminClient().client;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static bool isValidUsername(String username) {
    final normalized = username.trim().toLowerCase();
    return _usernameRegex.hasMatch(normalized);
  }

  static bool isValidEmail(String email) {
    final normalized = email.trim().toLowerCase();
    return _emailRegex.hasMatch(normalized);
  }

  Future<bool> isSetupCompleted() async {
    return _client.admin.isAdminSetupCompleted();
  }

  Future<void> createAdminWithEmail({
    required String username,
    required String email,
    required String password,
  }) async {
    _ensureValidUsername(username);
    _ensureValidEmail(email);
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim().toLowerCase(),
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw Exception('Signup failed. Please try again.');
    }

    final normalizedUsername = _normalizeUsername(username);
    if (normalizedUsername.isNotEmpty) {
      await user.updateDisplayName(normalizedUsername);
    }

    if (!user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> sendVerificationEmail() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('No active signup session found.');
    }
    await user.sendEmailVerification();
  }

  Future<void> completeAdminSetup() async {
    final user = await _reloadCurrentUser();
    if (user == null) {
      throw Exception('No authenticated admin found.');
    }
    if (!user.emailVerified) {
      throw Exception('Please verify your email first.');
    }

    final email = (user.email ?? '').trim().toLowerCase();
    if (email.isEmpty) {
      throw Exception('Email not found on authenticated user.');
    }

    await _upsertSellerProfile(
      user.uid,
      email,
      preferredUsername: user.displayName,
    );

    final idToken = await user.getIdToken(true);
    if (idToken == null || idToken.trim().isEmpty) {
      throw Exception('Failed to fetch Firebase auth token.');
    }

    await _verifyAdminToken(idToken);
  }

  Future<void> loginWithUsername({
    required String usernameOrEmail,
    required String password,
  }) async {
    final email = await resolveLoginEmail(usernameOrEmail);
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = await _reloadCurrentUser();
    if (user == null) {
      throw Exception('Login failed. Please try again.');
    }

    if (!user.emailVerified) {
      await user.sendEmailVerification();
      throw Exception(
        'Email not verified. Verification link sent to your inbox.',
      );
    }

    final idToken = await user.getIdToken(true);
    if (idToken == null || idToken.trim().isEmpty) {
      await _firebaseAuth.signOut();
      throw Exception('Failed to fetch Firebase auth token.');
    }

    try {
      await _verifyAdminToken(idToken);
    } catch (e) {
      if (NetworkStatusService.isTrueNetworkError(e)) {
        rethrow;
      }
      await _firebaseAuth.signOut();
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final normalized = email.trim().toLowerCase();
    if (normalized.isEmpty) {
      throw Exception('Email is required.');
    }
    _ensureValidEmail(normalized);
    await _firebaseAuth.sendPasswordResetEmail(email: normalized);
  }

  Future<String> sendPasswordResetForIdentity(String usernameOrEmail) async {
    final trimmed = usernameOrEmail.trim();
    if (trimmed.isEmpty) {
      throw Exception('Username or email required.');
    }

    final normalized = trimmed.toLowerCase();
    String? email;

    if (normalized.contains('@')) {
      _ensureValidEmail(normalized);
      email = normalized;
    } else {
      _ensureValidUsername(normalized);
      final resolved = await _client.admin.resolveAdminLoginEmail(normalized);
      final resolvedEmail = resolved.trim().toLowerCase();
      if (resolvedEmail.isNotEmpty && isValidEmail(resolvedEmail)) {
        email = resolvedEmail;
      }
    }

    if (email == null || email.isEmpty) {
      throw Exception('Account not found.');
    }

    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Account not found.');
      }
      if (e.code == 'invalid-email') {
        throw Exception(emailRuleText);
      }
      rethrow;
    }

    return email;
  }

  Future<String> resolveLoginEmail(String usernameOrEmail) async {
    final normalized = usernameOrEmail.trim().toLowerCase();
    if (normalized.isEmpty) {
      throw Exception('Username required.');
    }

    if (normalized.contains('@')) {
      _ensureValidEmail(normalized);
      return normalized;
    }

    _ensureValidUsername(normalized);

    final resolved = await _client.admin.resolveAdminLoginEmail(normalized);
    final email = resolved.trim().toLowerCase();
    if (email.isEmpty) {
      throw Exception('Invalid username or password.');
    }
    return email;
  }

  Future<void> authorizeCurrentUser() async {
    final user = await _reloadCurrentUser();
    if (user == null) {
      throw Exception('Login required.');
    }
    if (!user.emailVerified) {
      throw Exception('Please verify your email first.');
    }

    final email = (user.email ?? '').trim().toLowerCase();
    if (email.isEmpty) {
      throw Exception('Email not found on authenticated user.');
    }

    await _upsertSellerProfile(
      user.uid,
      email,
      preferredUsername: user.displayName,
    );

    final idToken = await user.getIdToken(true);
    if (idToken == null || idToken.trim().isEmpty) {
      throw Exception('Failed to fetch Firebase auth token.');
    }

    await _verifyAdminToken(idToken);
  }

  Future<bool> verifyCurrentSession() async {
    try {
      await authorizeCurrentUser();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<User?> _reloadCurrentUser() async {
    final current = _firebaseAuth.currentUser;
    if (current == null) return null;
    await current.reload();
    return _firebaseAuth.currentUser;
  }

  Future<void> _upsertSellerProfile(
    String uid,
    String email, {
    String? preferredUsername,
  }) async {
    final normalizedUsername = _normalizeUsername(preferredUsername ?? '');
    final usernameToStore = isValidUsername(normalizedUsername)
        ? normalizedUsername
        : _usernameFromEmail(email);

    await _firestore.collection(_sellerCollection).doc(uid).set({
      'email': email,
      'username': usernameToStore,
      'role': _adminRole,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  String _normalizeUsername(String username) {
    return username.trim().toLowerCase();
  }

  String _usernameFromEmail(String email) {
    final normalized = email.trim().toLowerCase();
    if (normalized.isEmpty) return 'admin000';
    final atIndex = normalized.indexOf('@');
    final localPart = atIndex <= 0
        ? normalized
        : normalized.substring(0, atIndex);

    var username = localPart.replaceAll(RegExp(r'[^a-z0-9_]'), '_');
    username = username.replaceAll(RegExp(r'_+'), '_');
    username = username.replaceAll(RegExp(r'^_+|_+$'), '');

    if (username.isEmpty) {
      username = 'admin';
    }
    if (!RegExp(r'^[a-z]').hasMatch(username)) {
      username = 'a$username';
    }
    if (username.length > usernameMaxLength) {
      username = username.substring(0, usernameMaxLength);
    }
    while (username.length < usernameMinLength) {
      username = '${username}0';
    }

    if (!isValidUsername(username)) {
      return 'admin000';
    }
    return username;
  }

  void _ensureValidUsername(String username) {
    if (!isValidUsername(username)) {
      throw Exception(usernameRuleText);
    }
  }

  void _ensureValidEmail(String email) {
    if (!isValidEmail(email)) {
      throw Exception(emailRuleText);
    }
  }

  Future<void> _verifyAdminToken(String idToken) async {
    final result = await _client.admin.firebaseLogin(idToken);
    if (!result.ok) {
      final message = (result.message ?? '').trim();
      if (message.isNotEmpty) {
        throw Exception(message);
      }
      throw Exception('Admin verification failed.');
    }
  }
}
