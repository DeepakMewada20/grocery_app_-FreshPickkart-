import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:freshpickkat_admin/services/admin_image_upload_service.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/admin_snackbar_service.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/widgets/admin_app_bar.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _usernameController = TextEditingController();
  final _usernamePasswordController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _newEmailController = TextEditingController();
  final _emailPasswordController = TextEditingController();

  bool _isSavingUsername = false;
  bool _isChangingPassword = false;
  bool _isChangingEmail = false;
  bool _isUploadingPhoto = false;
  String? _photoError;
  String? _usernameError;
  String? _passwordError;
  String? _emailError;

  User? get _user => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _usernameController.text = _user?.displayName ?? '';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _usernamePasswordController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newEmailController.dispose();
    _emailPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePhoto() async {
    final source = await AdminImageUploadService.pickImageSource(context);
    if (source == null || !mounted) return;

    setState(() {
      _isUploadingPhoto = true;
      _photoError = null;
    });

    try {
      final url = await AdminImageUploadService.pickCropAndUploadImage(
        source: source,
        folder: 'profile_images',
        toolbarTitle: 'Crop Profile Photo',
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      );

      if (url == null) {
        setState(() => _isUploadingPhoto = false);
        return;
      }

      await _user?.updatePhotoURL(url);
      await _user?.reload();

      if (mounted) {
        setState(() => _isUploadingPhoto = false);
        AdminSnackbarService.show(context, 'Profile photo updated successfully');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploadingPhoto = false;
          _photoError = 'Failed to update photo: $e';
        });
      }
    }
  }

  Future<void> _saveUsername() async {
    final newUsername = _usernameController.text.trim().toLowerCase();
    final password = _usernamePasswordController.text;
    final email = _user?.email;
    final currentUsername = _user?.displayName ?? '';

    if (newUsername.isEmpty) {
      setState(() => _usernameError = 'Username cannot be empty');
      return;
    }
    if (newUsername == currentUsername.toLowerCase()) {
      setState(() => _usernameError = 'New username is same as current');
      return;
    }
    if (password.isEmpty) {
      setState(() => _usernameError = 'Please enter your password to confirm');
      return;
    }

    final usernameRegex = RegExp(r'^[a-z][a-z0-9_]{3,23}$');
    if (!usernameRegex.hasMatch(newUsername)) {
      setState(() => _usernameError =
          'Username must be 4-24 characters, start with a letter, '
          'and contain only lowercase letters, digits, and underscores.');
      return;
    }

    setState(() {
      _isSavingUsername = true;
      _usernameError = null;
    });

    try {
      // 1. Reauthenticate
      if (email != null && email.isNotEmpty) {
        final credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        await _user?.reauthenticateWithCredential(credential);
      }

      // 2. Update Firebase Auth displayName
      await _user?.updateDisplayName(newUsername);
      await _user?.reload();

      // 3. Update server AppUserRow.name
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken();
      await ServerpodAdminClient().client.admin.updateAdminUsername(
        uid,
        idToken,
        newUsername,
      );

      _usernamePasswordController.clear();

      if (mounted) {
        setState(() => _isSavingUsername = false);
        AdminSnackbarService.show(context, 'Username updated successfully');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isSavingUsername = false;
        _usernameError = _firebaseAuthErrorMessage(e);
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSavingUsername = false;
          _usernameError = 'Failed to update username: $e';
        });
      }
    }
  }

  Future<void> _changePassword() async {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final email = _user?.email;

    if (email == null || email.isEmpty) {
      setState(() => _passwordError = 'No email associated with this account');
      return;
    }
    if (currentPassword.isEmpty) {
      setState(() => _passwordError = 'Please enter your current password');
      return;
    }
    if (newPassword.length < 6) {
      setState(() => _passwordError = 'New password must be at least 6 characters');
      return;
    }
    if (newPassword != confirmPassword) {
      setState(() => _passwordError = 'New passwords do not match');
      return;
    }

    setState(() {
      _isChangingPassword = true;
      _passwordError = null;
    });

    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );
      await _user?.reauthenticateWithCredential(credential);
      await _user?.updatePassword(newPassword);

      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      if (mounted) {
        setState(() => _isChangingPassword = false);
        AdminSnackbarService.show(context, 'Password changed successfully');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isChangingPassword = false;
        _passwordError = _firebaseAuthErrorMessage(e);
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isChangingPassword = false;
          _passwordError = 'Failed to change password: $e';
        });
      }
    }
  }

  Future<void> _changeEmail() async {
    final newEmail = _newEmailController.text.trim();
    final password = _emailPasswordController.text;
    final email = _user?.email;

    if (email == null || email.isEmpty) {
      setState(() => _emailError = 'No email associated with this account');
      return;
    }
    if (newEmail.isEmpty || !newEmail.contains('@')) {
      setState(() => _emailError = 'Please enter a valid email address');
      return;
    }
    if (newEmail == email) {
      setState(() => _emailError = 'New email is same as current email');
      return;
    }
    if (password.isEmpty) {
      setState(() => _emailError = 'Please enter your password to confirm');
      return;
    }

    setState(() {
      _isChangingEmail = true;
      _emailError = null;
    });

    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await _user?.reauthenticateWithCredential(credential);
      await _user?.verifyBeforeUpdateEmail(newEmail);

      _newEmailController.clear();
      _emailPasswordController.clear();

      if (mounted) {
        setState(() => _isChangingEmail = false);
        AdminSnackbarService.show(
          context,
          'Verification link sent to $newEmail. '
          'Email will be updated after you click the link.',
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isChangingEmail = false;
        _emailError = _firebaseAuthErrorMessage(e);
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isChangingEmail = false;
          _emailError = 'Failed to change email: $e';
        });
      }
    }
  }

  String _firebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'wrong-password':
        return 'Current password is incorrect';
      case 'invalid-credential':
        return 'Current password is incorrect';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'requires-recent-login':
        return 'Please log out and log in again before changing sensitive information.';
      case 'email-already-in-use':
        return 'This email is already in use by another account.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      default:
        return e.message ?? 'An error occurred';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final user = _user;

    return Scaffold(
      appBar: AdminAppBar(title: const Text('Profile')),
      body: AdminResponsive.constrainContent(
        context: context,
        child: ListView(
          padding: AdminResponsive.pagePadding(context),
          children: [
            _buildSectionHeader(context, 'Admin Information'),
            SizedBox(height: 8.h),
            _buildInfoCard(context, cs, user),
            SizedBox(height: 24.h),
            _buildSectionHeader(context, 'Username'),
            SizedBox(height: 8.h),
            _buildUsernameCard(context, cs),
            SizedBox(height: 24.h),
            _buildSectionHeader(context, 'Email Address'),
            SizedBox(height: 8.h),
            _buildEmailCard(context, cs),
            SizedBox(height: 24.h),
            _buildSectionHeader(context, 'Change Password'),
            SizedBox(height: 8.h),
            _buildPasswordCard(context, cs),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 15.sp.clamp(13.0, 17.0),
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, ColorScheme cs, User? user) {
    final photoUrl = user?.photoURL;
    final displayName = user?.displayName ?? 'Admin';
    final email = user?.email ?? '';
    final emailVerified = user?.emailVerified ?? false;
    final creationTime = user?.metadata.creationTime;
    final memberSince = creationTime != null
        ? '${creationTime.day.toString().padLeft(2, '0')}-${creationTime.month.toString().padLeft(2, '0')}-${creationTime.year}'
        : 'N/A';

    return Card(
      child: Padding(
        padding: AdminResponsive.cardPadding(context),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50.r.clamp(42.0, 56.0),
                  backgroundColor: cs.primary.withValues(alpha: 0.12),
                  backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                      ? NetworkImage(photoUrl)
                      : null,
                  child: photoUrl == null || photoUrl.isEmpty
                      ? Icon(
                          Icons.person,
                          size: 50.sp.clamp(40.0, 54.0),
                          color: AdminThemeTokens.white,
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _isUploadingPhoto ? null : _updatePhoto,
                    child: Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: cs.surface, width: 2),
                      ),
                      child: _isUploadingPhoto
                          ? SizedBox(
                              width: 16.r,
                              height: 16.r,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: cs.onPrimary,
                              ),
                            )
                          : Icon(
                              Icons.camera_alt,
                              size: 16.r,
                              color: AdminThemeTokens.white,
                            ),
                    ),
                  ),
                ),
              ],
            ),
            if (_photoError != null) ...[
              SizedBox(height: 8.h),
              Text(
                _photoError!,
                style: TextStyle(
                  color: AdminAppTheme.getErrorColor(context),
                  fontSize: 12.sp.clamp(10.0, 13.0),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            SizedBox(height: 12.h),
            Text(
              displayName,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18.sp.clamp(16.0, 20.0),
                color: cs.onSurface,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              email,
              style: TextStyle(
                fontSize: 14.sp.clamp(12.0, 16.0),
                color: cs.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 4.h,
              alignment: WrapAlignment.center,
              children: [
                _buildBadge(context, 'ADMIN_SELLER', cs.primary),
                _buildBadge(
                  context,
                  emailVerified ? 'Verified' : 'Unverified',
                  emailVerified
                      ? AdminAppTheme.getSuccessColor(context)
                      : AdminAppTheme.getErrorColor(context),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              'Member since $memberSince',
              style: TextStyle(
                fontSize: 12.sp.clamp(10.0, 13.0),
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp.clamp(10.0, 13.0),
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildUsernameCard(BuildContext context, ColorScheme cs) {
    return Card(
      child: Padding(
        padding: AdminResponsive.cardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current: ${_user?.displayName ?? 'N/A'}',
              style: TextStyle(
                fontSize: 13.sp.clamp(11.0, 15.0),
                color: cs.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'New Username',
                hintText: '4-24 chars, lowercase, letters/digits/underscores',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _usernamePasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Old username will no longer work for login.',
              style: TextStyle(
                fontSize: 11.sp.clamp(9.0, 12.0),
                color: AdminAppTheme.getErrorColor(context),
              ),
            ),
            if (_usernameError != null) ...[
              SizedBox(height: 4.h),
              Text(
                _usernameError!,
                style: TextStyle(
                  color: AdminAppTheme.getErrorColor(context),
                  fontSize: 12.sp.clamp(10.0, 13.0),
                ),
              ),
            ],
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSavingUsername ? null : _saveUsername,
                icon: _isSavingUsername
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: cs.onPrimary,
                        ),
                      )
                    : const Icon(Icons.person_outline),
                label: Text(
                    _isSavingUsername ? 'Saving...' : 'Change Username'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailCard(BuildContext context, ColorScheme cs) {
    return Card(
      child: Padding(
        padding: AdminResponsive.cardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current: ${_user?.email ?? 'N/A'}',
              style: TextStyle(
                fontSize: 13.sp.clamp(11.0, 15.0),
                color: cs.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _newEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'New Email Address',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _emailPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'A verification link will be sent to the new email address.',
              style: TextStyle(
                fontSize: 11.sp.clamp(9.0, 12.0),
                color: cs.onSurfaceVariant,
              ),
            ),
            if (_emailError != null) ...[
              SizedBox(height: 4.h),
              Text(
                _emailError!,
                style: TextStyle(
                  color: AdminAppTheme.getErrorColor(context),
                  fontSize: 12.sp.clamp(10.0, 13.0),
                ),
              ),
            ],
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isChangingEmail ? null : _changeEmail,
                icon: _isChangingEmail
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: cs.onPrimary,
                        ),
                      )
                    : const Icon(Icons.email_outlined),
                label: Text(
                    _isChangingEmail ? 'Sending...' : 'Change Email'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordCard(BuildContext context, ColorScheme cs) {
    return Card(
      child: Padding(
        padding: AdminResponsive.cardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You will need to enter your current password to set a new one.',
              style: TextStyle(
                fontSize: 12.sp.clamp(10.0, 13.0),
                color: cs.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
            if (_passwordError != null) ...[
              SizedBox(height: 4.h),
              Text(
                _passwordError!,
                style: TextStyle(
                  color: AdminAppTheme.getErrorColor(context),
                  fontSize: 12.sp.clamp(10.0, 13.0),
                ),
              ),
            ],
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isChangingPassword ? null : _changePassword,
                icon: _isChangingPassword
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: cs.onPrimary,
                        ),
                      )
                    : const Icon(Icons.lock_outline),
                label: Text(
                    _isChangingPassword ? 'Changing...' : 'Change Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
