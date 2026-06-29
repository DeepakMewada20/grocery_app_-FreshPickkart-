import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import '../controller/admin_referral_controller.dart';
import '../services/admin_snackbar_service.dart';
import '../widgets/admin_app_bar.dart';
import '../utils/admin_responsive.dart';

class ReferralSettingsScreen extends StatefulWidget {
  const ReferralSettingsScreen({super.key});
  @override
  State<ReferralSettingsScreen> createState() => _ReferralSettingsScreenState();
}

class _ReferralSettingsScreenState extends State<ReferralSettingsScreen> {
  final _controller = AdminReferralController.instance;

  late TextEditingController _inviteeAmountCtrl;
  late TextEditingController _couponTemplateCtrl;
  late TextEditingController _referrerPointsCtrl;
  late TextEditingController _minOrderCtrl;
  late TextEditingController _maxMonthlyCtrl;
  late TextEditingController _expiryDaysCtrl;
  late TextEditingController _shareMessageCtrl;
  late TextEditingController _minPaymentCtrl;
  late TextEditingController _maxDailyCtrl;
  late TextEditingController _maxSharesDayCtrl;
  late TextEditingController _maxSharesMonthCtrl;
  late TextEditingController _autoReversalDaysCtrl;
  late TextEditingController _termsTextCtrl;

  bool _isEnabled = true;
  bool _inviteeCouponEnabled = true;
  bool _referrerPointsEnabled = true;
  bool _enableFraudProtection = true;
  bool _enableReferralExpiry = false;
  String _rewardTriggerStatus = 'DELIVERED';

  bool get _isSaving => _controller.isSaving.value;

  @override
  void initState() {
    super.initState();
    final s = _controller.settings.value;
    _inviteeAmountCtrl = TextEditingController(text: s?.inviteeCouponAmount.toString() ?? '50');
    _couponTemplateCtrl = TextEditingController(text: s?.inviteeCouponCodeTemplate ?? 'WELCOME{CODE}');
    _referrerPointsCtrl = TextEditingController(text: s?.referrerRewardPoints.toString() ?? '50');
    _minOrderCtrl = TextEditingController(text: s?.minimumQualifyingAmount.toString() ?? '0');
    _maxMonthlyCtrl = TextEditingController(text: s?.maxRewardedPerMonth.toString() ?? '20');
    _expiryDaysCtrl = TextEditingController(text: s?.referralExpiryDays.toString() ?? '90');
    _shareMessageCtrl = TextEditingController(
      text: s?.shareMessageTemplate ?? 'Join FreshPickKat using my referral code {CODE}. Get ₹50 OFF on your first order!',
    );
    _minPaymentCtrl = TextEditingController(text: s?.minimumActualPaymentForQualification.toString() ?? '0');
    _maxDailyCtrl = TextEditingController(text: s?.maxRewardedPerDay.toString() ?? '10');
    _maxSharesDayCtrl = TextEditingController(text: s?.maxSharesPerDay.toString() ?? '20');
    _maxSharesMonthCtrl = TextEditingController(text: s?.maxSharesPerMonth.toString() ?? '100');
    _autoReversalDaysCtrl = TextEditingController(text: s?.autoReversalWindowDays.toString() ?? '30');
    _termsTextCtrl = TextEditingController(text: s?.termsText ?? '');
    _isEnabled = s?.isEnabled ?? true;
    _inviteeCouponEnabled = s?.inviteeCouponEnabled ?? true;
    _referrerPointsEnabled = s?.referrerPointsEnabled ?? true;
    _enableFraudProtection = s?.enableFraudProtection ?? true;
    _enableReferralExpiry = s?.enableReferralExpiry ?? false;
    _rewardTriggerStatus = s?.rewardTriggerStatus ?? 'DELIVERED';
  }

  @override
  void dispose() {
    _inviteeAmountCtrl.dispose();
    _couponTemplateCtrl.dispose();
    _referrerPointsCtrl.dispose();
    _minOrderCtrl.dispose();
    _maxMonthlyCtrl.dispose();
    _expiryDaysCtrl.dispose();
    _shareMessageCtrl.dispose();
    _minPaymentCtrl.dispose();
    _maxDailyCtrl.dispose();
    _maxSharesDayCtrl.dispose();
    _maxSharesMonthCtrl.dispose();
    _autoReversalDaysCtrl.dispose();
    _termsTextCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final updated = client.ReferralSettings(
      isEnabled: _isEnabled,
      inviteeCouponEnabled: _inviteeCouponEnabled,
      inviteeCouponAmount: double.tryParse(_inviteeAmountCtrl.text) ?? 50,
      inviteeCouponCodeTemplate: _couponTemplateCtrl.text,
      referrerPointsEnabled: _referrerPointsEnabled,
      referrerRewardPoints: int.tryParse(_referrerPointsCtrl.text) ?? 50,
      minimumQualifyingAmount: double.tryParse(_minOrderCtrl.text) ?? 0,
      rewardTriggerStatus: _rewardTriggerStatus,
      maxRewardedPerMonth: int.tryParse(_maxMonthlyCtrl.text) ?? 20,
      enableFraudProtection: _enableFraudProtection,
      enableReferralExpiry: _enableReferralExpiry,
      referralExpiryDays: int.tryParse(_expiryDaysCtrl.text) ?? 90,
      shareMessageTemplate: _shareMessageCtrl.text,
      minimumActualPaymentForQualification: double.tryParse(_minPaymentCtrl.text) ?? 0,
      maxRewardedPerDay: int.tryParse(_maxDailyCtrl.text) ?? 10,
      maxSharesPerDay: int.tryParse(_maxSharesDayCtrl.text) ?? 20,
      maxSharesPerMonth: int.tryParse(_maxSharesMonthCtrl.text) ?? 100,
      autoReversalWindowDays: int.tryParse(_autoReversalDaysCtrl.text) ?? 30,
      enableFraudScoring: _controller.settings.value?.enableFraudScoring ?? true,
      autoApproveThreshold: _controller.settings.value?.autoApproveThreshold ?? 40,
      manualReviewThreshold: _controller.settings.value?.manualReviewThreshold ?? 69,
      autoRejectThreshold: _controller.settings.value?.autoRejectThreshold ?? 90,
      enableRewardHold: _controller.settings.value?.enableRewardHold ?? true,
      holdDurationHours: _controller.settings.value?.holdDurationHours ?? 72,
      enableAutoReject: _controller.settings.value?.enableAutoReject ?? true,
      maxPendingReferrals: _controller.settings.value?.maxPendingReferrals ?? 50,
      referralVelocityScore: _controller.settings.value?.referralVelocityScore ?? 30,
      velocityTimeWindowHours: _controller.settings.value?.velocityTimeWindowHours ?? 24,
      velocityThreshold: _controller.settings.value?.velocityThreshold ?? 3,
      newAccountScore: _controller.settings.value?.newAccountScore ?? 20,
      newAccountHours: _controller.settings.value?.newAccountHours ?? 48,
      termsText: _termsTextCtrl.text.isNotEmpty ? _termsTextCtrl.text : null,
      updatedAt: DateTime.now(),
    );

    final ok = await _controller.saveSettings(updated);
    if (mounted) {
      AdminSnackbarService.show(
        context,
        ok ? 'Referral settings updated.' : 'Failed to save settings.',
      );
    }
  }

  Future<void> _openDocs() async {
    const url =
        'https://deepakmewada20.github.io/grocery_app_-FreshPickkart-/referral-settings-help.html';
    final uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          AdminSnackbarService.show(context, 'Could not open documentation');
        }
      }
    } catch (_) {
      if (mounted) {
        AdminSnackbarService.show(context, 'Could not open documentation');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AdminAppBar(
        title: const Text('Referral Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Documentation',
            onPressed: _openDocs,
          ),
        ],
      ),
      body: AdminResponsive.constrainContent(
        context: context,
        child: Obx(() {
          if (_controller.isLoading.value && _controller.settings.value == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: AdminResponsive.pagePadding(context).copyWith(
              bottom: AdminResponsive.bottomInset(context),
            ),
            children: [
              _buildSectionHeader(context, 'General'),
              _buildSwitchTile(cs, 'Enable Referral Program', _isEnabled, (v) => setState(() => _isEnabled = v)),
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'Invitee Coupon'),
              _buildSwitchTile(cs, 'Enable Invitee Coupon', _inviteeCouponEnabled, (v) => setState(() => _inviteeCouponEnabled = v)),
              _buildTextField(_inviteeAmountCtrl, 'Coupon Discount Amount (INR)', '50', enabled: _inviteeCouponEnabled),
              _buildTextField(_couponTemplateCtrl, 'Coupon Code Template (\'{CODE}\' will be replaced)', 'WELCOME{CODE}', enabled: _inviteeCouponEnabled),
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'Referrer Rewards'),
              _buildSwitchTile(cs, 'Enable Referrer Points', _referrerPointsEnabled, (v) => setState(() => _referrerPointsEnabled = v)),
              _buildTextField(_referrerPointsCtrl, 'Reward Points per Referral', '50', enabled: _referrerPointsEnabled),
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'Qualification Rules'),
              _buildTextField(_minOrderCtrl, 'Minimum Qualifying Order Amount (INR)', '0'),
              _buildTriggerDropdown(cs),
              _buildTextField(_maxMonthlyCtrl, 'Max Rewards per Referrer per Month', '20'),
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'Expiry & Fraud'),
              _buildSwitchTile(cs, 'Enable Referral Expiry', _enableReferralExpiry, (v) => setState(() => _enableReferralExpiry = v)),
              if (_enableReferralExpiry)
                _buildTextField(_expiryDaysCtrl, 'Expiry (days)', '90'),
              _buildSwitchTile(cs, 'Enable Fraud Protection', _enableFraudProtection, (v) => setState(() => _enableFraudProtection = v)),
              _buildSectionHeader(context, 'Qualification Hardening'),
              _buildTextField(_minPaymentCtrl, 'Minimum Actual Payment (INR)', '0'),
              _buildTextField(_maxDailyCtrl, 'Max Rewards per Referrer per Day', '10'),
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'Share Rate Limiting'),
              _buildTextField(_maxSharesDayCtrl, 'Max Shares per Day', '20'),
              _buildTextField(_maxSharesMonthCtrl, 'Max Shares per Month', '100'),
              _buildSectionHeader(context, 'Reward Reversal'),
              _buildTextField(_autoReversalDaysCtrl, 'Auto-Reversal Window (days)', '30'),
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'Terms & Conditions'),
              _buildTextField(_termsTextCtrl, 'Terms Text (displayed in Invite & Earn)', '',
                  maxLines: 6, minLines: 3),
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'Share Message'),
              _buildTextField(_shareMessageCtrl, 'Share Message Template (\'{CODE}\' will be replaced)', 'Join... {CODE}',
                  maxLines: 4, minLines: 2),
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'System Settings (Read Only)'),
              _buildReadOnlyField(context, 'Enable Fraud Scoring',
                  _controller.settings.value?.enableFraudScoring == true ? 'Enabled' : 'Disabled'),
              _buildReadOnlyField(context, 'Auto-Approve Threshold',
                  _controller.settings.value?.autoApproveThreshold.toString() ?? '40'),
              _buildReadOnlyField(context, 'Manual Review Threshold',
                  _controller.settings.value?.manualReviewThreshold.toString() ?? '69'),
              _buildReadOnlyField(context, 'Auto-Reject Threshold',
                  _controller.settings.value?.autoRejectThreshold.toString() ?? '90'),
              _buildReadOnlyField(context, 'Enable Reward Hold',
                  _controller.settings.value?.enableRewardHold == true ? 'Enabled' : 'Disabled'),
              _buildReadOnlyField(context, 'Hold Duration (hours)',
                  _controller.settings.value?.holdDurationHours.toString() ?? '72'),
              _buildReadOnlyField(context, 'Enable Auto Reject',
                  _controller.settings.value?.enableAutoReject == true ? 'Enabled' : 'Disabled'),
              _buildReadOnlyField(context, 'Max Pending Referrals per Referrer',
                  _controller.settings.value?.maxPendingReferrals.toString() ?? '50'),
              _buildReadOnlyField(context, 'Velocity Score',
                  _controller.settings.value?.referralVelocityScore.toString() ?? '30'),
              _buildReadOnlyField(context, 'Velocity Window (hours)',
                  _controller.settings.value?.velocityTimeWindowHours.toString() ?? '24'),
              _buildReadOnlyField(context, 'Velocity Threshold (referrals)',
                  _controller.settings.value?.velocityThreshold.toString() ?? '3'),
              _buildReadOnlyField(context, 'New Account Score',
                  _controller.settings.value?.newAccountScore.toString() ?? '20'),
              _buildReadOnlyField(context, 'New Account Threshold (hours)',
                  _controller.settings.value?.newAccountHours.toString() ?? '48'),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _isSaving ? null : _save,
                icon: _isSaving
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.save),
                label: Text(_isSaving ? 'Saving...' : 'Save Settings'),
              ),
              const SizedBox(height: 32),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w600,
      )),
    );
  }

  Widget _buildSwitchTile(ColorScheme cs, String label, bool value, ValueChanged<bool> onChanged) {
    return Card(
      child: SwitchListTile(
        title: Text(label),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, String hint,
      {bool enabled = true, int? maxLines, int? minLines}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        enabled: enabled,
        maxLines: maxLines,
        minLines: minLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(BuildContext context, String label, String value) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: ListTile(
          dense: true,
          title: Text(label, style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
          trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  Widget _buildTriggerDropdown(ColorScheme cs) {
    const statuses = ['PLACED', 'CONFIRMED', 'PACKED', 'OUT_FOR_DELIVERY', 'DELIVERED'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: _rewardTriggerStatus,
        decoration: const InputDecoration(
          labelText: 'Reward Trigger Status',
          border: OutlineInputBorder(),
          isDense: true,
        ),
        items: statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
        onChanged: (v) => setState(() => _rewardTriggerStatus = v ?? 'DELIVERED'),
      ),
    );
  }
}
