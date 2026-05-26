import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/screens/login_screen.dart';
import 'package:freshpickkat_admin/screens/main_screen.dart';
import 'package:freshpickkat_admin/services/admin_auth_service.dart';
import 'package:freshpickkat_admin/services/admin_notification_service.dart';
import 'package:freshpickkat_admin/services/admin_realtime_service.dart';
import 'package:freshpickkat_admin/services/network_status_service.dart';
import 'package:freshpickkat_admin/tracking/controllers/delivery_tracking_controller.dart';
import 'package:get/get.dart';

enum _AuthViewState {
  checking,
  login,
  awaitingVerification,
  authenticated,
  authenticatedOffline,
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> with WidgetsBindingObserver {
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
    WidgetsBinding.instance.addObserver(this);
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
    WidgetsBinding.instance.removeObserver(this);
    _verificationPoller?.cancel();
    _userSubscription?.cancel();
    _networkSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      _verificationPoller?.cancel();
      _verificationPoller = null;
      return;
    }

    if (state == AppLifecycleState.resumed) {
      if (Get.isRegistered<DeliveryTrackingController>()) {
        final ctrl = Get.find<DeliveryTrackingController>();
        if (ctrl.isActive.value) {
          ctrl.resumeSender();
        }
      }
      if (!user.emailVerified &&
          _viewState == _AuthViewState.awaitingVerification) {
        _startVerificationPolling();
      }
    }
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
    _verificationPoller = null;

    if (!mounted) return;
    if (user == null) {
      await AdminRealtimeService.instance.stop();
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

    if (_viewState != _AuthViewState.authenticated &&
        _viewState != _AuthViewState.authenticatedOffline) {
      setState(() {
        _viewState = _AuthViewState.authenticatedOffline;
        _authorizedUid = user.uid;
        _message = null;
      });
    }

    unawaited(_authorizeCurrentUser());
  }

  void _startVerificationPolling() {
    _verificationPoller?.cancel();
    _verificationPoller = null;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.emailVerified) return;

    _verificationPoller = Timer.periodic(const Duration(seconds: 3), (
      timer,
    ) async {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        timer.cancel();
        _verificationPoller = null;
        return;
      }

      await currentUser.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser;
      if (refreshedUser?.emailVerified == true) {
        timer.cancel();
        _verificationPoller = null;
        await _authorizeCurrentUser();
      }
    });
  }

  Future<void> _authorizeCurrentUser() async {
    if (_authorizing) return;
    _authorizing = true;
    final currentUser = FirebaseAuth.instance.currentUser;
    final previousState = _viewState;
    final wasInMainFlow =
        previousState == _AuthViewState.authenticated ||
        previousState == _AuthViewState.authenticatedOffline;

    if (mounted && !wasInMainFlow) {
      setState(() {
        _viewState = _AuthViewState.checking;
      });
    }

    try {
      if (currentUser == null) {
        if (!mounted) return;
        setState(() => _viewState = _AuthViewState.login);
        return;
      }

      await _authService.authorizeCurrentUser();
      await AdminNotificationService.init();
      _verificationPoller?.cancel();
      _verificationPoller = null;
      if (!mounted) return;
      setState(() {
        _viewState = _AuthViewState.authenticated;
        _authorizedUid = currentUser.uid;
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
          _viewState = _AuthViewState.authenticatedOffline;
          _authorizedUid = currentUser?.uid;
          _message = null;
        });
        return;
      }

      await _authService.signOut();
      _verificationPoller?.cancel();
      _verificationPoller = null;
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
      case _AuthViewState.authenticatedOffline:
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
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AdminThemeTokens.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.shopping_bag,
                size: 80,
                color: AdminAppTheme.getSuccessColor(context),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'FreshPickKart',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AdminThemeTokens.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Admin Panel',
              style: TextStyle(
                fontSize: 18,
                color: AdminThemeTokens.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 40),
            CircularProgressIndicator(color: AdminThemeTokens.white),
          ],
        ),
      ),
    );
  }
}
