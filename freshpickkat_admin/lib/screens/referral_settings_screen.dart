import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import '../controller/admin_referral_controller.dart';
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
  late TextEditingController _autoApproveThresholdCtrl;
  late TextEditingController _manualReviewThresholdCtrl;
  late TextEditingController _autoRejectThresholdCtrl;
  late TextEditingController _holdDurationHoursCtrl;
  late TextEditingController _minPaymentCtrl;
  late TextEditingController _maxDailyCtrl;
  late TextEditingController _maxPendingCtrl;
  late TextEditingController _maxSharesDayCtrl;
  late TextEditingController _maxSharesMonthCtrl;
  late TextEditingController _velocityScoreCtrl;
  late TextEditingController _velocityWindowCtrl;
  late TextEditingController _velocityThresholdCtrl;
  late TextEditingController _newAccountScoreCtrl;
  late TextEditingController _newAccountHoursCtrl;
  late TextEditingController _autoReversalDaysCtrl;
  late TextEditingController _termsTextCtrl;

  bool _isEnabled = true;
  bool _inviteeCouponEnabled = true;
  bool _referrerPointsEnabled = true;
  bool _enableFraudProtection = true;
  bool _enableReferralExpiry = false;
  bool _enableFraudScoring = true;
  bool _enableRewardHold = true;
  bool _enableAutoReject = true;
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
    _autoApproveThresholdCtrl = TextEditingController(text: s?.autoApproveThreshold.toString() ?? '40');
    _manualReviewThresholdCtrl = TextEditingController(text: s?.manualReviewThreshold.toString() ?? '69');
    _autoRejectThresholdCtrl = TextEditingController(text: s?.autoRejectThreshold.toString() ?? '90');
    _holdDurationHoursCtrl = TextEditingController(text: s?.holdDurationHours.toString() ?? '72');
    _minPaymentCtrl = TextEditingController(text: s?.minimumActualPaymentForQualification.toString() ?? '0');
    _maxDailyCtrl = TextEditingController(text: s?.maxRewardedPerDay.toString() ?? '10');
    _maxPendingCtrl = TextEditingController(text: s?.maxPendingReferrals.toString() ?? '5');
    _maxSharesDayCtrl = TextEditingController(text: s?.maxSharesPerDay.toString() ?? '20');
    _maxSharesMonthCtrl = TextEditingController(text: s?.maxSharesPerMonth.toString() ?? '100');
    _velocityScoreCtrl = TextEditingController(text: s?.referralVelocityScore.toString() ?? '30');
    _velocityWindowCtrl = TextEditingController(text: s?.velocityTimeWindowHours.toString() ?? '24');
    _velocityThresholdCtrl = TextEditingController(text: s?.velocityThreshold.toString() ?? '5');
    _newAccountScoreCtrl = TextEditingController(text: s?.newAccountScore.toString() ?? '20');
    _newAccountHoursCtrl = TextEditingController(text: s?.newAccountHours.toString() ?? '72');
    _autoReversalDaysCtrl = TextEditingController(text: s?.autoReversalWindowDays.toString() ?? '30');
    _termsTextCtrl = TextEditingController(text: s?.termsText ?? '');
    _isEnabled = s?.isEnabled ?? true;
    _inviteeCouponEnabled = s?.inviteeCouponEnabled ?? true;
    _referrerPointsEnabled = s?.referrerPointsEnabled ?? true;
    _enableFraudProtection = s?.enableFraudProtection ?? true;
    _enableReferralExpiry = s?.enableReferralExpiry ?? false;
    _enableFraudScoring = s?.enableFraudScoring ?? true;
    _enableRewardHold = s?.enableRewardHold ?? true;
    _enableAutoReject = s?.enableAutoReject ?? true;
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
    _autoApproveThresholdCtrl.dispose();
    _manualReviewThresholdCtrl.dispose();
    _autoRejectThresholdCtrl.dispose();
    _holdDurationHoursCtrl.dispose();
    _minPaymentCtrl.dispose();
    _maxDailyCtrl.dispose();
    _maxPendingCtrl.dispose();
    _maxSharesDayCtrl.dispose();
    _maxSharesMonthCtrl.dispose();
    _velocityScoreCtrl.dispose();
    _velocityWindowCtrl.dispose();
    _velocityThresholdCtrl.dispose();
    _newAccountScoreCtrl.dispose();
    _newAccountHoursCtrl.dispose();
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
      enableFraudScoring: _enableFraudScoring,
      autoApproveThreshold: int.tryParse(_autoApproveThresholdCtrl.text) ?? 40,
      manualReviewThreshold: int.tryParse(_manualReviewThresholdCtrl.text) ?? 69,
      autoRejectThreshold: int.tryParse(_autoRejectThresholdCtrl.text) ?? 90,
      enableRewardHold: _enableRewardHold,
      holdDurationHours: int.tryParse(_holdDurationHoursCtrl.text) ?? 72,
      enableAutoReject: _enableAutoReject,
      minimumActualPaymentForQualification: double.tryParse(_minPaymentCtrl.text) ?? 0,
      maxRewardedPerDay: int.tryParse(_maxDailyCtrl.text) ?? 10,
      maxPendingReferrals: int.tryParse(_maxPendingCtrl.text) ?? 5,
      maxSharesPerDay: int.tryParse(_maxSharesDayCtrl.text) ?? 20,
      maxSharesPerMonth: int.tryParse(_maxSharesMonthCtrl.text) ?? 100,
      referralVelocityScore: int.tryParse(_velocityScoreCtrl.text) ?? 30,
      velocityTimeWindowHours: int.tryParse(_velocityWindowCtrl.text) ?? 24,
      velocityThreshold: int.tryParse(_velocityThresholdCtrl.text) ?? 5,
      newAccountScore: int.tryParse(_newAccountScoreCtrl.text) ?? 20,
      newAccountHours: int.tryParse(_newAccountHoursCtrl.text) ?? 72,
      autoReversalWindowDays: int.tryParse(_autoReversalDaysCtrl.text) ?? 30,
      termsText: _termsTextCtrl.text.isNotEmpty ? _termsTextCtrl.text : null,
      updatedAt: DateTime.now(),
    );

    final ok = await _controller.saveSettings(updated);
    if (mounted) {
      Get.snackbar(
        ok ? 'Saved' : 'Error',
        ok ? 'Referral settings updated.' : 'Failed to save settings.',
        backgroundColor: ok ? Colors.green.shade50 : Colors.red.shade50,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const AdminAppBar(title: Text('Referral Settings')),
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
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'Fraud Scoring'),
              _buildSwitchTile(cs, 'Enable Fraud Scoring', _enableFraudScoring, (v) => setState(() => _enableFraudScoring = v)),
              _buildSwitchTile(cs, 'Enable Reward Hold', _enableRewardHold, (v) => setState(() => _enableRewardHold = v)),
              if (_enableRewardHold)
                _buildTextField(_holdDurationHoursCtrl, 'Hold Duration (hours)', '72'),
              _buildSwitchTile(cs, 'Enable Auto Reject', _enableAutoReject, (v) => setState(() => _enableAutoReject = v)),
              _buildTextField(_autoApproveThresholdCtrl, 'Auto-Approve Threshold (score < this)', '40'),
              _buildTextField(_manualReviewThresholdCtrl, 'Manual Review Threshold (score >= this)', '69'),
              _buildTextField(_autoRejectThresholdCtrl, 'Auto-Reject Threshold (score >= this)', '90'),
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'Qualification Hardening'),
              _buildTextField(_minPaymentCtrl, 'Minimum Actual Payment (INR)', '0'),
              _buildTextField(_maxDailyCtrl, 'Max Rewards per Referrer per Day', '10'),
              _buildTextField(_maxPendingCtrl, 'Max Pending Referrals per Referrer', '5'),
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'Share Rate Limiting'),
              _buildTextField(_maxSharesDayCtrl, 'Max Shares per Day', '20'),
              _buildTextField(_maxSharesMonthCtrl, 'Max Shares per Month', '100'),
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'Velocity Rule'),
              _buildTextField(_velocityScoreCtrl, 'Velocity Score', '30'),
              _buildTextField(_velocityWindowCtrl, 'Velocity Window (hours)', '24'),
              _buildTextField(_velocityThresholdCtrl, 'Velocity Threshold (referrals)', '5'),
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'New Account Rule'),
              _buildTextField(_newAccountScoreCtrl, 'New Account Score', '20'),
              _buildTextField(_newAccountHoursCtrl, 'New Account Threshold (hours)', '72'),
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'Reward Reversal'),
              _buildTextField(_autoReversalDaysCtrl, 'Auto-Reversal Window (days)', '30'),
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'Terms & Conditions'),
              _buildTextField(_termsTextCtrl, 'Terms Text (displayed in Invite & Earn)', ''),
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'Share Message'),
              _buildTextField(_shareMessageCtrl, 'Share Message Template (\'{CODE}\' will be replaced)', 'Join... {CODE}'),
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

  Widget _buildTextField(TextEditingController ctrl, String label, String hint, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
          isDense: true,
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
