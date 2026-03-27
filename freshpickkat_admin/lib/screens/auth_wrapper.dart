import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/screens/login_screen.dart';
import 'package:freshpickkat_admin/screens/main_screen.dart';
import 'package:freshpickkat_admin/services/admin_auth_service.dart';
import 'package:freshpickkat_admin/services/admin_notification_service.dart';
import 'package:freshpickkat_admin/services/network_status_service.dart';

enum _AuthViewState { checking, login, awaitingVerification, authenticated }

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final _authService = AdminAuthService();

  StreamSubscription<User?>? _userSubscription;
  StreamSubscription<bool>? _networkSubscription;
  Timer? _verificationPoller;

  _AuthViewState _viewState = _AuthViewState.checking;
  bool _authorizing = false;
  String? _message;
  String? _authorizedUid;

  @override
  void initState() {
    super.initState();
    _networkSubscription = NetworkStatusService.instance.onStatusChange.listen(
      _handleConnectivityChange,
    );
    _userSubscription = FirebaseAuth.instance.userChanges().listen(
      (user) => _handleUserChange(user),
    );
    _handleUserChange(FirebaseAuth.instance.currentUser);
  }

  @override
  void dispose() {
    _verificationPoller?.cancel();
    _userSubscription?.cancel();
    _networkSubscription?.cancel();
    super.dispose();
  }

  void _handleConnectivityChange(bool hasConnection) {
    if (!mounted) return;
    if (hasConnection &&
        FirebaseAuth.instance.currentUser != null &&
        _viewState != _AuthViewState.authenticated) {
      _authorizeCurrentUser();
    }
  }

  Future<void> _handleUserChange(User? user) async {
    _verificationPoller?.cancel();

    if (!mounted) return;
    if (user == null) {
      setState(() {
        _viewState = _AuthViewState.login;
        _authorizedUid = null;
      });
      return;
    }

    if (!user.emailVerified) {
      setState(() {
        _viewState = _AuthViewState.awaitingVerification;
        _message =
            'Email verification pending. Link sent to ${user.email ?? 'your inbox'}.';
        _authorizedUid = null;
      });
      _startVerificationPolling();
      return;
    }

    if (_viewState == _AuthViewState.authenticated &&
        _authorizedUid == user.uid) {
      return;
    }

    await _authorizeCurrentUser();
  }

  void _startVerificationPolling() {
    _verificationPoller = Timer.periodic(const Duration(seconds: 3), (
      timer,
    ) async {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        timer.cancel();
        return;
      }

      await currentUser.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser;
      if (refreshedUser?.emailVerified == true) {
        timer.cancel();
        await _authorizeCurrentUser();
      }
    });
  }

  Future<void> _authorizeCurrentUser() async {
    if (_authorizing) return;
    _authorizing = true;
    if (mounted) {
      setState(() {
        _viewState = _AuthViewState.checking;
      });
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (!mounted) return;
        setState(() => _viewState = _AuthViewState.login);
        return;
      }

      await _authService.authorizeCurrentUser();
      await AdminNotificationService.init();
      if (!mounted) return;
      setState(() {
        _viewState = _AuthViewState.authenticated;
        _authorizedUid = user.uid;
        _message = null;
      });
    } catch (e) {
      if (!mounted) return;

      final hasActualConnection = await NetworkStatusService.instance
          .hasConnection();
      final isTrueNetworkError = NetworkStatusService.isTrueNetworkError(e);

      if (!hasActualConnection || isTrueNetworkError) {
        if (!mounted) return;
        setState(() {
          _viewState = _AuthViewState.login;
          _message = 'Network error. Please try again later.';
        });
        return;
      }

      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      setState(() {
        _viewState = _AuthViewState.login;
        _authorizedUid = null;
        _message = _friendlyError(e);
      });
    } finally {
      _authorizing = false;
    }
  }

  String _friendlyError(Object error) {
    var text = error.toString().replaceFirst('Exception: ', '');
    if (text.startsWith('ServerpodClientException')) {
      final idx = text.lastIndexOf(':');
      if (idx != -1 && idx + 1 < text.length) {
        text = text.substring(idx + 1).trim();
      }
    }

    if (text.contains('invalid-credential')) {
      return 'Invalid username or password.';
    }
    if (text.contains('wrong-password')) return 'Invalid username or password.';
    if (text.contains('user-not-found')) return 'Invalid username or password.';
    return text;
  }

  @override
  Widget build(BuildContext context) {
    switch (_viewState) {
      case _AuthViewState.authenticated:
        return const MainScreen();
      case _AuthViewState.login:
      case _AuthViewState.awaitingVerification:
        return LoginScreen(
          forceAwaitingVerification:
              _viewState == _AuthViewState.awaitingVerification,
          initialMessage: _message,
        );
      case _AuthViewState.checking:
        return const _AuthLoadingScreen();
    }
  }
}

class _AuthLoadingScreen extends StatelessWidget {
  const _AuthLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.shopping_bag,
                size: 80,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'FreshPickKart',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Admin Panel',
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
