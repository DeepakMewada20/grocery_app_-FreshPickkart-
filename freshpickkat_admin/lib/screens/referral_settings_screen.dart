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
