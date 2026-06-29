import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/services/admin_snackbar_service.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/admin_auth_failure_handler.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

class FreshPointsAdjustDialog extends StatefulWidget {
  final ActiveUserStatistics user;

  const FreshPointsAdjustDialog({super.key, required this.user});

  @override
  State<FreshPointsAdjustDialog> createState() =>
      _FreshPointsAdjustDialogState();
}

class _FreshPointsAdjustDialogState extends State<FreshPointsAdjustDialog> {
  final _client = ServerpodAdminClient().client;
  bool _isLoadingBalance = true;
  bool _isSubmitting = false;
  FreshPointsBalance? _balance;
  String? _error;
  final _pointsController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isDeduction = false;

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  @override
  void dispose() {
    _pointsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadBalance() async {
    setState(() {
      _isLoadingBalance = true;
      _error = null;
    });
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken();
      final balance = await _client.freshPoints.getUserBalance(
        widget.user.userId,
        uid,
        idToken,
      );
      if (mounted) {
        setState(() {
          _balance = balance;
          _isLoadingBalance = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoadingBalance = false;
        });
      }
    }
  }

  Future<void> _submit() async {
    final pointsText = _pointsController.text.trim();
    if (pointsText.isEmpty) return;
    final points = int.tryParse(pointsText);
    if (points == null || points <= 0) {
      AdminSnackbarService.show(context, 'Enter a valid positive number');
      return;
    }
    final description = _descriptionController.text.trim();
    if (description.isEmpty) {
      AdminSnackbarService.show(context, 'Enter a reason for the adjustment');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken();
      final request = FreshPointsAdjustRequest(
        userId: widget.user.userId,
        points: _isDeduction ? -points : points,
        transactionType: _isDeduction ? 'ADMIN_DEDUCT' : 'ADMIN_ADD',
        description: description,
      );
      await _client.freshPoints.adjustPoints(request, uid, idToken);
      if (mounted) {
        AdminSnackbarService.show(
          context,
          '${_isDeduction ? "Deducted" : "Added"} $points points ${_isDeduction ? "from" : "to"} ${widget.user.name ?? widget.user.phoneNumber}',
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        if (AdminAuthFailureHandler.isAuthFailure(e)) {
          await AdminAuthFailureHandler.handle(e);
        } else {
          AdminSnackbarService.show(context, 'Error: ${e.toString()}');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 480.w),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_isLoadingBalance) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null && _balance == null) {
      return SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 40, color: AdminAppTheme.getErrorColor(context)),
            SizedBox(height: 12.h),
            Text(
              'Failed to load balance',
              style: AdminTextStyles.body(context),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _loadBalance,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AdminAppTheme.getWarningContainerColor(context),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.monetization_on_outlined,
                  color: AdminAppTheme.getWarningColor(context),
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adjust FreshPoints',
                      style: AdminTextStyles.screenTitle(context),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      widget.user.name ?? 'Unknown',
                      style: AdminTextStyles.caption(context),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Close',
              ),
            ],
          ),
          SizedBox(height: 20.h),
          if (_balance != null) ...[
            _buildBalanceCard(context),
            SizedBox(height: 20.h),
          ],
          Row(
            children: [
              _buildToggleChip(context, 'Credit', false),
              SizedBox(width: 8.w),
              _buildToggleChip(context, 'Debit', true),
            ],
          ),
          SizedBox(height: 16.h),
          TextField(
            controller: _pointsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Points',
              hintText: 'Enter amount',
              prefixIcon: const Icon(Icons.stars_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          TextField(
            controller: _descriptionController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Reason',
              hintText: 'e.g. Signup bonus adjustment',
              prefixIcon: const Icon(Icons.description_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                backgroundColor: _isDeduction
                    ? AdminAppTheme.getErrorColor(context)
                    : AdminAppTheme.getSuccessColor(context),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      _isDeduction ? 'Deduct Points' : 'Credit Points',
                      style: AdminTextStyles.body(context)
                          .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleChip(BuildContext context, String label, bool isDeduction) {
    final selected = _isDeduction == isDeduction;
    return GestureDetector(
      onTap: () => setState(() => _isDeduction = isDeduction),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected
              ? (isDeduction
                  ? AdminAppTheme.getErrorColor(context).withValues(alpha: 0.12)
                  : AdminAppTheme.getSuccessColor(context)
                      .withValues(alpha: 0.12))
              : Colors.transparent,
          border: Border.all(
            color: selected
                ? (isDeduction
                    ? AdminAppTheme.getErrorColor(context)
                    : AdminAppTheme.getSuccessColor(context))
                : AdminAppTheme.getBorderColor(context),
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          style: AdminTextStyles.body(context).copyWith(
            fontWeight: FontWeight.w600,
            color: selected
                ? (isDeduction
                    ? AdminAppTheme.getErrorColor(context)
                    : AdminAppTheme.getSuccessColor(context))
                : AdminAppTheme.getTextSecondaryColor(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AdminAppTheme.getSubtleSurfaceColor(context),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AdminAppTheme.getBorderColor(context)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(context, 'Balance', '${_balance!.balance}'),
          _buildDivider(context),
          _buildStatItem(context, 'Earned', '${_balance!.totalEarned}'),
          _buildDivider(context),
          _buildStatItem(context, 'Redeemed', '${_balance!.totalRedeemed}'),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AdminTextStyles.screenTitle(context)
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: AdminTextStyles.caption(context),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 32.h,
      color: AdminAppTheme.getBorderColor(context),
    );
  }
}
