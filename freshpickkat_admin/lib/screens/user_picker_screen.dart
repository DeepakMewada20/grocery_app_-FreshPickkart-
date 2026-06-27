import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/widgets/admin_app_bar.dart';
import 'package:freshpickkat_admin/widgets/fresh_points_adjust_dialog.dart';
import 'package:freshpickkat_admin/widgets/user_search_filter_widget.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

class UserPickerScreen extends StatefulWidget {
  const UserPickerScreen({super.key});

  @override
  State<UserPickerScreen> createState() => _UserPickerScreenState();
}

class _UserPickerScreenState extends State<UserPickerScreen> {
  final _client = ServerpodAdminClient().client;
  bool _isLoading = true;
  String? _error;
  List<ActiveUserStatistics> _users = [];
  ActiveUserStatistics? _selectedUser;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken();
      final results = await _client.admin.getActiveUsersWithStats(uid, idToken, limit: 100);
      if (mounted) {
        setState(() {
          _users = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _onSelectionChanged(List<ActiveUserStatistics> selected) {
    setState(() {
      _selectedUser = selected.isNotEmpty ? selected.first : null;
    });
  }

  void _confirm() {
    if (_selectedUser == null) return;
    showDialog(
      context: context,
      builder: (_) => FreshPointsAdjustDialog(user: _selectedUser!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: const Text('Select User'),
        actions: [
          if (_selectedUser != null)
            TextButton.icon(
              onPressed: _confirm,
              icon: const Icon(Icons.check, size: 18),
              label: const Text('Confirm'),
            ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                size: 48, color: AdminAppTheme.getErrorColor(context)),
            SizedBox(height: 12.h),
            Text('Failed to load users', style: AdminTextStyles.body(context)),
            SizedBox(height: 16.h),
            ElevatedButton(onPressed: _loadUsers, child: const Text('Retry')),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: AdminResponsive.pagePadding(context),
            child: UserSearchFilterWidget(
              allUsers: _users,
              enableSelection: true,
              singleSelect: true,
              isMobileLayout: !AdminResponsive.isTablet(context),
              onSelectionChanged: _onSelectionChanged,
            ),
          ),
        ),
        if (_selectedUser != null)
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirm,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Adjust Points for ${_selectedUser!.name ?? _selectedUser!.phoneNumber}',
                    style: AdminTextStyles.body(context)
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
