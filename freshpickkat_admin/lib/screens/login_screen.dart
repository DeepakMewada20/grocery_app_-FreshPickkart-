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
                      height: AdminResponsive.isLandscape(context)
                          ? 12.h
                          : 28.h,
                    ),
                    // Animated Header
                    _buildHeaderSection(),
                    SizedBox(height: 28.h),
                    // Modern Tab Bar
                    _buildModernTabBar(),
                    SizedBox(height: 20.h),
                    // Tab Content
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

  Widget _buildHeaderSection() {
    final primaryColor = AdminAppTheme.getSuccessColor(context);

    return Column(
      children: [
        // Icon with gradient background
        Container(
          padding: EdgeInsets.all(18.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryColor.withValues(alpha: 0.25),
                primaryColor.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: primaryColor.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Icon(
            Icons.admin_panel_settings_rounded,
            color: primaryColor,
            size: AdminResponsive.isLandscape(context)
                ? 44.sp
                : 56.sp.clamp(48.0, 60.0),
          ),
        ),
        SizedBox(height: 20.h),
        // Title with better typography
        Text(
          'FreshPickKart Admin',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AdminTextStyles.screenTitle(context).copyWith(
            fontSize: 28.sp.clamp(22.0, 30.0),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        SizedBox(height: 8.h),
        // Subtitle
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: primaryColor.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Text(
            'Single Admin (ADMIN_SELLER)',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: primaryColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernTabBar() {
    final primaryColor = AdminAppTheme.getSuccessColor(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: TabBar(
        labelPadding: EdgeInsets.zero,
        labelColor: Colors.white,
        unselectedLabelColor: Theme.of(context).brightness == Brightness.dark
            ? AdminThemeTokens.darkTextSecondary
            : AdminThemeTokens.primary.withValues(alpha: 0.7),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryColor, primaryColor.withValues(alpha: 0.85)],
          ),
        ),
        dividerColor: Colors.transparent,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.login_rounded, size: 18.sp),
                SizedBox(width: 6.w),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.app_registration_rounded, size: 18.sp),
                SizedBox(width: 6.w),
                Text(
                  'Setup',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginTab() {
    final primaryColor = AdminAppTheme.getSuccessColor(context);
    return Form(
      key: _loginFormKey,
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          // Username/Email Field
          _buildModernInputField(
            controller: _loginUsernameCtrl,
            label: 'Username or Email',
            hint: 'Enter your admin username or email',
            icon: Icons.person_outline_rounded,
            validator: _validateLoginIdentity,
          ),
          SizedBox(height: 18.h),
          // Password Field
          _buildModernInputField(
            controller: _loginPasswordCtrl,
            label: 'Password',
            hint: 'Enter your password',
            icon: Icons.lock_outline_rounded,
            obscureText: true,
            validator: _validatePassword,
          ),
          SizedBox(height: 12.h),
          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _isLoading ? null : _openPasswordResetDialog,
              icon: Icon(Icons.help_outline_rounded, size: 18.sp),
              label: Text(
                'Forgot Password?',
                style: TextStyle(fontSize: 13.sp),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          // Login Button with gradient
          _buildModernButton(
            onPressed: _isLoading ? null : _login,
            label: 'Login to Admin',
            isLoading: _isLoading,
            icon: Icons.login_rounded,
          ),
          SizedBox(height: 12.h),
          // Info Card
          _buildInfoCard(
            icon: Icons.info_outline_rounded,
            title: 'Admin Access',
            description: 'Secure login for authorized administrators only',
            color: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSetupTab() {
    final primaryColor = AdminAppTheme.getSuccessColor(context);
    return Form(
      key: _setupFormKey,
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          // Username Field
          _buildModernInputField(
            controller: _setupUsernameCtrl,
            label: 'Admin Username',
            hint: 'Choose a unique username',
            icon: Icons.person_add_rounded,
            validator: _validateSetupUsername,
            enabled: !_awaitingEmailVerification,
            helperText: '4-24 chars, start with letter, only a-z, 0-9, _',
          ),
          SizedBox(height: 16.h),
          // Email Field
          _buildModernInputField(
            controller: _setupEmailCtrl,
            label: 'Admin Email',
            hint: 'Enter your admin email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            enabled: !_awaitingEmailVerification,
          ),
          SizedBox(height: 16.h),
          // Password Field
          _buildModernInputField(
            controller: _setupPasswordCtrl,
            label: 'Password',
            hint: 'Create a strong password',
            icon: Icons.lock_outline_rounded,
            obscureText: true,
            validator: _validatePassword,
            enabled: !_awaitingEmailVerification,
          ),
          SizedBox(height: 16.h),
          // Confirm Password Field
          _buildModernInputField(
            controller: _setupConfirmPasswordCtrl,
            label: 'Confirm Password',
            hint: 'Confirm your password',
            icon: Icons.lock_reset_rounded,
            obscureText: true,
            validator: _validateConfirmPassword,
            enabled: !_awaitingEmailVerification,
          ),
          SizedBox(height: 24.h),
          // Conditional UI based on verification state
          if (!_awaitingEmailVerification) ...[
            _buildModernButton(
              onPressed: _isLoading ? null : _startSetup,
              label: 'Create Admin & Send Verification',
              isLoading: _isLoading,
              icon: Icons.app_registration_rounded,
            ),
            SizedBox(height: 14.h),
            _buildInfoCard(
              icon: Icons.shield_rounded,
              title: 'Secure Setup',
              description:
                  'Verification email will be sent to confirm your admin account',
              color: primaryColor,
            ),
          ],
          if (_awaitingEmailVerification) ...[
            _buildVerificationPendingCard(),
            SizedBox(height: 18.h),
            _buildModernButton(
              onPressed: _isLoading ? null : _resendVerificationEmail,
              label: 'Resend Verification Email',
              isLoading: _isLoading,
              isOutlined: true,
              icon: Icons.mail_outline_rounded,
            ),
            SizedBox(height: 10.h),
            _buildModernButton(
              onPressed: _isLoading ? null : _cancelPendingSetup,
              label: 'Start Over',
              isLoading: _isLoading,
              isText: true,
              icon: Icons.restart_alt_rounded,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModernInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
    String? helperText,
  }) {
    final primaryColor = AdminAppTheme.getSuccessColor(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 12.w, right: 8.w),
          child: Icon(
            icon,
            size: 20.sp,
            color: primaryColor.withValues(alpha: 0.7),
          ),
        ),
        prefixIconConstraints: BoxConstraints(
          minHeight: 20.sp,
          minWidth: 20.sp,
        ),
        filled: true,
        fillColor: isDark
            ? AdminThemeTokens.darkSurfaceElevated.withValues(alpha: 0.6)
            : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: isDark
                ? AdminThemeTokens.darkBorder
                : primaryColor.withValues(alpha: 0.15),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: isDark
                ? AdminThemeTokens.darkBorder
                : primaryColor.withValues(alpha: 0.15),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: AdminAppTheme.getErrorColor(context),
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: AdminAppTheme.getErrorColor(context),
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        labelStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
        hintStyle: TextStyle(
          fontSize: 13.sp,
          color: AdminAppTheme.getTextSecondaryColor(context),
        ),
      ),
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      enabled: enabled,
    );
  }

  Widget _buildModernButton({
    required VoidCallback? onPressed,
    required String label,
    required IconData icon,
    bool isLoading = false,
    bool isOutlined = false,
    bool isText = false,
  }) {
    final primaryColor = AdminAppTheme.getSuccessColor(context);

    if (isText) {
      return SizedBox(
        height: 48.h.clamp(44.0, 52.0),
        width: double.infinity,
        child: TextButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 18.sp),
          label: Text(
            label,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            foregroundColor: primaryColor,
          ),
        ),
      );
    }

    if (isOutlined) {
      return SizedBox(
        height: 48.h.clamp(44.0, 52.0),
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 18.sp),
          label: Text(
            label,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            foregroundColor: primaryColor,
            side: BorderSide(
              color: primaryColor.withValues(alpha: 0.5),
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 52.h.clamp(48.0, 56.0),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: isLoading
            ? SizedBox(
                width: 18.sp,
                height: 18.sp,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(icon, size: 20.sp),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 4,
          shadowColor: primaryColor.withValues(alpha: 0.4),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: color, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AdminAppTheme.getTextSecondaryColor(context),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationPendingCard() {
    final primaryColor = AdminAppTheme.getSuccessColor(context);
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withValues(alpha: 0.1),
            primaryColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.mail_lock_rounded,
                  color: primaryColor,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verification Email Sent',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _pendingSetupEmail ?? _setupEmailCtrl.text.trim(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AdminAppTheme.getTextSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 16.sp,
                      color: primaryColor,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Next Steps',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  '• Click the verification link in the email\n• App will automatically login after verification',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AdminAppTheme.getTextSecondaryColor(context),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
