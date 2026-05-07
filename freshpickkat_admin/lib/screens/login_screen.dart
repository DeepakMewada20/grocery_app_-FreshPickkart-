import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/services/admin_auth_service.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.forceAwaitingVerification = false,
    this.initialMessage,
  });

  final bool forceAwaitingVerification;
  final String? initialMessage;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _authService = AdminAuthService();

  final _loginUsernameCtrl = TextEditingController();
  final _loginPasswordCtrl = TextEditingController();

  final _setupUsernameCtrl = TextEditingController();
  final _setupEmailCtrl = TextEditingController();
  final _setupPasswordCtrl = TextEditingController();
  final _setupConfirmPasswordCtrl = TextEditingController();
  final _resetIdentityCtrl = TextEditingController();

  final _loginFormKey = GlobalKey<FormState>();
  final _setupFormKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _awaitingEmailVerification = false;
  String? _pendingSetupEmail;
  String? _lastShownMessage;

  @override
  void initState() {
    super.initState();
    _syncVerificationStateWithCurrentUser(force: true);
    _showInitialMessage(widget.initialMessage);
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.forceAwaitingVerification !=
        widget.forceAwaitingVerification) {
      _syncVerificationStateWithCurrentUser();
    }
    if (oldWidget.initialMessage != widget.initialMessage) {
      _showInitialMessage(widget.initialMessage);
    }
  }

  @override
  void dispose() {
    _loginUsernameCtrl.dispose();
    _loginPasswordCtrl.dispose();
    _setupUsernameCtrl.dispose();
    _setupEmailCtrl.dispose();
    _setupPasswordCtrl.dispose();
    _setupConfirmPasswordCtrl.dispose();
    _resetIdentityCtrl.dispose();
    super.dispose();
  }

  void _syncVerificationStateWithCurrentUser({bool force = false}) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final shouldAwait =
        widget.forceAwaitingVerification ||
        (currentUser != null && !currentUser.emailVerified);

    if (force || shouldAwait != _awaitingEmailVerification) {
      setState(() {
        _awaitingEmailVerification = shouldAwait;
        _pendingSetupEmail = currentUser?.email;
      });
    }

    if (currentUser?.email != null && _setupEmailCtrl.text.trim().isEmpty) {
      _setupEmailCtrl.text = currentUser!.email!;
    }
    if (currentUser?.displayName != null &&
        _setupUsernameCtrl.text.trim().isEmpty) {
      _setupUsernameCtrl.text = currentUser!.displayName!;
    }
  }

  void _showInitialMessage(String? message) {
    final value = message?.trim();
    if (value == null || value.isEmpty) return;
    if (value == _lastShownMessage) return;
    _lastShownMessage = value;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _showMessage(value, isError: _looksLikeError(value));
    });
  }

  Future<void> _login() async {
    if (!_loginFormKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await _authService.loginWithUsername(
        usernameOrEmail: _loginUsernameCtrl.text.trim(),
        password: _loginPasswordCtrl.text.trim(),
      );
      _showMessage('Login successful.');
    } catch (e) {
      _showMessage(_friendlyError(e), isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _openPasswordResetDialog() async {
    final usernameInput = _loginUsernameCtrl.text.trim();
    _resetIdentityCtrl.text = usernameInput;
    bool isSending = false;
    bool isErrorMessage = false;
    String? statusMessage;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> handleSend() async {
              final identity = _resetIdentityCtrl.text.trim();
              if (identity.isEmpty) {
                setDialogState(() {
                  isErrorMessage = true;
                  statusMessage = 'Username or email required.';
                });
                return;
              }

              if (identity.contains('@')) {
                if (!AdminAuthService.isValidEmail(identity)) {
                  setDialogState(() {
                    isErrorMessage = true;
                    statusMessage = AdminAuthService.emailRuleText;
                  });
                  return;
                }
              } else {
                if (!AdminAuthService.isValidUsername(identity)) {
                  setDialogState(() {
                    isErrorMessage = true;
                    statusMessage = AdminAuthService.usernameRuleText;
                  });
                  return;
                }
              }

              setDialogState(() {
                isSending = true;
                isErrorMessage = false;
                statusMessage = null;
              });

              try {
                final resolvedEmail = await _authService
                    .sendPasswordResetForIdentity(identity);
                if (!mounted || !dialogContext.mounted) return;

                final maskedEmail = _maskEmailForDisplay(resolvedEmail);

                setDialogState(() {
                  isSending = false;
                  isErrorMessage = false;
                  statusMessage =
                      'Password reset link has been sent to $maskedEmail.';
                });
              } catch (e) {
                if (!mounted || !dialogContext.mounted) return;
                setDialogState(() {
                  isSending = false;
                  isErrorMessage = true;
                  statusMessage = _friendlyError(e);
                });
              }
            }

            return AlertDialog(
              constraints: AdminResponsive.dialogConstraints(context),
              title: const Text('Reset Password'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _resetIdentityCtrl,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (_) {
                        if (statusMessage == null) return;
                        setDialogState(() {
                          statusMessage = null;
                          isErrorMessage = false;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Username or Email',
                        hintText: 'Enter your username or email',
                      ),
                    ),
                    if (statusMessage != null) ...[
                      SizedBox(height: 12.h),
                      Text(
                        statusMessage!,
                        style: TextStyle(
                          color: isErrorMessage
                              ? AdminAppTheme.getErrorColor(context)
                              : AdminAppTheme.getSuccessColor(context),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSending
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: isSending ? null : handleSend,
                  child: isSending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Send Link'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _startSetup() async {
    if (!_setupFormKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final setupCompleted = await _authService.isSetupCompleted();
      if (setupCompleted) {
        throw Exception('Admin setup already completed. Please login.');
      }

      await _authService.createAdminWithEmail(
        username: _setupUsernameCtrl.text.trim(),
        email: _setupEmailCtrl.text.trim(),
        password: _setupPasswordCtrl.text.trim(),
      );

      if (!mounted) return;
      setState(() {
        _awaitingEmailVerification = true;
        _pendingSetupEmail = _setupEmailCtrl.text.trim().toLowerCase();
      });
      _showMessage(
        'Verification email sent. Click the link and app will login automatically.',
      );
    } catch (e) {
      _showMessage(_friendlyError(e), isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendVerificationEmail() async {
    setState(() => _isLoading = true);
    try {
      await _authService.sendVerificationEmail();
      _showMessage('Verification email resent.');
    } catch (e) {
      _showMessage(_friendlyError(e), isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _cancelPendingSetup() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    setState(() {
      _awaitingEmailVerification = false;
      _pendingSetupEmail = null;
    });
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AdminAppTheme.getErrorColor(context) : null,
      ),
    );
  }

  bool _looksLikeError(String message) {
    final m = message.toLowerCase();
    return m.contains('denied') ||
        m.contains('invalid') ||
        m.contains('failed') ||
        m.contains('error') ||
        m.contains('required');
  }

  String _friendlyError(Object error) {
    var text = error.toString().replaceFirst('Exception: ', '');

    if (text.startsWith('ServerpodClientException')) {
      final idx = text.lastIndexOf(':');
      if (idx != -1 && idx + 1 < text.length) {
        text = text.substring(idx + 1).trim();
      }
    }

    if (text.contains('email-already-in-use')) {
      return 'Email already in use. Please login.';
    }
    if (text.contains('invalid-email')) {
      return 'Invalid email format.';
    }
    if (text.contains('weak-password')) {
      return 'Password should be at least 6 characters.';
    }
    if (text.contains('invalid-credential')) {
      return 'Invalid username or password.';
    }
    if (text.contains('wrong-password')) {
      return 'Invalid username or password.';
    }
    if (text.contains('user-not-found')) {
      return 'Invalid username or password.';
    }
    if (text.contains('Username is required')) {
      return 'Username is required.';
    }
    if (text.contains('Username must be 4-24 chars')) {
      return AdminAuthService.usernameRuleText;
    }
    if (text.contains('Enter a valid email address.')) {
      return AdminAuthService.emailRuleText;
    }

    return text;
  }

  String? _validateLoginIdentity(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Username required';
    if (v.contains('@')) {
      return _validateEmail(v);
    }
    if (!AdminAuthService.isValidUsername(v)) {
      return AdminAuthService.usernameRuleText;
    }
    return null;
  }

  String? _validateSetupUsername(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Username required';
    if (!AdminAuthService.isValidUsername(v)) {
      return AdminAuthService.usernameRuleText;
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email required';
    if (!AdminAuthService.isValidEmail(v)) {
      return AdminAuthService.emailRuleText;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Password required';
    if (v.length < 6) return 'Password min 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Confirm password required';
    if (v != _setupPasswordCtrl.text.trim()) {
      return 'Passwords do not match';
    }
    return null;
  }

  String _maskEmailForDisplay(String email) {
    final trimmed = email.trim();
    final atIndex = trimmed.indexOf('@');
    if (atIndex <= 0) return trimmed;

    final local = trimmed.substring(0, atIndex);
    final domain = trimmed.substring(atIndex + 1);

    String maskedLocal;
    if (local.length <= 4) {
      maskedLocal = local;
    } else {
      maskedLocal =
          '${local.substring(0, 2)}${'*' * (local.length - 4)}${local.substring(local.length - 2)}';
    }

    if (domain.isEmpty) return '$maskedLocal@';
    return '$maskedLocal@$domain';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: _awaitingEmailVerification ? 1 : 0,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 520.w),
              child: Padding(
                padding: AdminResponsive.pagePadding(context),
                child: Column(
                  children: [
                    SizedBox(
                      height: AdminResponsive.isLandscape(context) ? 8.h : 24.h,
                    ),
                    Container(
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: AdminAppTheme.getSuccessColor(
                          context,
                        ).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.admin_panel_settings,
                        color: AdminAppTheme.getSuccessColor(context),
                        size: AdminResponsive.isLandscape(context)
                            ? 42.sp
                            : 52.sp.clamp(44.0, 56.0),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      'FreshPickKart Admin',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AdminTextStyles.screenTitle(
                        context,
                      ).copyWith(fontSize: 26.sp.clamp(20.0, 28.0).toDouble()),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Single Admin (ADMIN_SELLER)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AdminAppTheme.getTextSecondaryColor(context),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    const TabBar(
                      tabs: [
                        Tab(text: 'Login'),
                        Tab(text: 'First Setup'),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Expanded(
                      child: TabBarView(
                        children: [_buildLoginTab(), _buildSetupTab()],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginTab() {
    return Form(
      key: _loginFormKey,
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          TextFormField(
            controller: _loginUsernameCtrl,
            decoration: const InputDecoration(
              labelText: 'Username',
              hintText: 'admin username',
            ),
            validator: _validateLoginIdentity,
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: _loginPasswordCtrl,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: _validatePassword,
          ),
          SizedBox(height: 10.h),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _isLoading ? null : _openPasswordResetDialog,
              child: const Text('Forgot Password'),
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 52.h.clamp(48.0, 56.0),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: _isLoading
                  ? SizedBox(
                      width: 20.r,
                      height: 20.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Login'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetupTab() {
    return Form(
      key: _setupFormKey,
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          TextFormField(
            controller: _setupUsernameCtrl,
            decoration: const InputDecoration(
              labelText: 'Admin Username',
              helperText: '4-24 chars, start with letter, only a-z, 0-9, _',
            ),
            validator: _validateSetupUsername,
            enabled: !_awaitingEmailVerification,
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: _setupEmailCtrl,
            decoration: const InputDecoration(labelText: 'Admin Email'),
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            enabled: !_awaitingEmailVerification,
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: _setupPasswordCtrl,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: _validatePassword,
            enabled: !_awaitingEmailVerification,
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: _setupConfirmPasswordCtrl,
            decoration: const InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
            validator: _validateConfirmPassword,
            enabled: !_awaitingEmailVerification,
          ),
          SizedBox(height: 16.h),
          if (!_awaitingEmailVerification)
            SizedBox(
              height: 52.h.clamp(48.0, 56.0),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _startSetup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Create Admin & Send Verification'),
              ),
            ),
          if (_awaitingEmailVerification) ...[
            Text(
              'Verification pending for ${_pendingSetupEmail ?? _setupEmailCtrl.text.trim()}',
            ),
            SizedBox(height: 6.h),
            Text(
              'Click the verification link in email. App will auto-login after verification.',
              style: TextStyle(
                color: AdminAppTheme.getTextSecondaryColor(context),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 46.h.clamp(42.0, 50.0),
              child: OutlinedButton(
                onPressed: _isLoading ? null : _resendVerificationEmail,
                child: const Text('Resend Verification Email'),
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: 46.h.clamp(42.0, 50.0),
              child: TextButton(
                onPressed: _isLoading ? null : _cancelPendingSetup,
                child: const Text('Start Over'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
