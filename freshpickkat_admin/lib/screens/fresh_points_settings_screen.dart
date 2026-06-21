import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/controller/admin_fresh_points_controller.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_admin/widgets/admin_app_bar.dart';

class FreshPointsSettingsScreen extends StatefulWidget {
  const FreshPointsSettingsScreen({super.key});

  @override
  State<FreshPointsSettingsScreen> createState() =>
      _FreshPointsSettingsScreenState();
}

class _FreshPointsSettingsScreenState extends State<FreshPointsSettingsScreen> {
  final _controller = AdminFreshPointsController.instance;

  late TextEditingController _percentCtrl;
  late TextEditingController _minOrderCtrl;
  late TextEditingController _expiryDaysCtrl;
  bool _isEnabled = true;
  bool _allowCOD = true;
  bool _enableExpiry = true;
  bool _enableAdminAdjustments = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final s = _controller.settings.value;
    _percentCtrl = TextEditingController(
      text: s?.redemptionPercentageLimit.toString() ?? '50',
    );
    _minOrderCtrl = TextEditingController(
      text: s?.minimumOrderForRedemption.toString() ?? '0',
    );
    _expiryDaysCtrl = TextEditingController(
      text: s?.pointExpiryDays.toString() ?? '365',
    );
    _isEnabled = s?.isEnabled ?? true;
    _allowCOD = s?.allowRedemptionOnCOD ?? true;
    _enableExpiry = s?.enablePointExpiry ?? true;
    _enableAdminAdjustments = s?.enableAdminAdjustments ?? true;
  }

  @override
  void didUpdateWidget(covariant FreshPointsSettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final s = _controller.settings.value;
    if (s != null) {
      _percentCtrl.text = s.redemptionPercentageLimit.toString();
      _minOrderCtrl.text = s.minimumOrderForRedemption.toString();
      _expiryDaysCtrl.text = s.pointExpiryDays.toString();
      _isEnabled = s.isEnabled;
      _allowCOD = s.allowRedemptionOnCOD;
      _enableExpiry = s.enablePointExpiry;
      _enableAdminAdjustments = s.enableAdminAdjustments;
    }
  }

  @override
  void dispose() {
    _percentCtrl.dispose();
    _minOrderCtrl.dispose();
    _expiryDaysCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const AdminAppBar(title: Text('FreshPoints Settings')),
      body: AdminResponsive.constrainContent(
        context: context,
        child: Obx(() {
          if (_controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: AdminResponsive.pagePadding(context).copyWith(
              bottom: AdminResponsive.bottomInset(context),
            ),
            children: [
              Text(
                'Configuration',
                style: AdminTextStyles.sectionTitle(context),
              ),
              SizedBox(height: 16),
              _buildSwitchTile(
                context,
                'Enable FreshPoints',
                'Allow users to earn and redeem points',
                Icons.monetization_on_outlined,
                _isEnabled,
                (v) => setState(() => _isEnabled = v),
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _percentCtrl,
                label: 'Redemption Limit (%)',
                hint: 'Max % of order value redeemable (default: 50)',
                icon: Icons.percent,
                enabled: _isEnabled,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _minOrderCtrl,
                label: 'Minimum Order (₹)',
                hint: 'Minimum order amount to redeem points',
                icon: Icons.shopping_cart_outlined,
                enabled: _isEnabled,
              ),
              SizedBox(height: 16),
              _buildSwitchTile(
                context,
                'Allow Redemption on COD',
                'Users can apply points on Cash on Delivery orders',
                Icons.money_outlined,
                _allowCOD,
                (v) => setState(() => _allowCOD = v),
                enabled: _isEnabled,
              ),
              SizedBox(height: 16),
              Divider(color: cs.outlineVariant),
              SizedBox(height: 16),
              _buildSwitchTile(
                context,
                'Enable Point Expiry',
                'Points expire after a set number of days',
                Icons.timer_outlined,
                _enableExpiry,
                (v) => setState(() => _enableExpiry = v),
                enabled: _isEnabled,
              ),
              if (_enableExpiry) ...[
                SizedBox(height: 16),
                _buildTextField(
                  controller: _expiryDaysCtrl,
                  label: 'Expiry Days',
                  hint: 'Days after which points expire (default: 365)',
                  icon: Icons.calendar_today,
                  enabled: _isEnabled,
                ),
              ],
              SizedBox(height: 16),
              _buildSwitchTile(
                context,
                'Enable Admin Adjustments',
                'Allow admins to manually add or deduct points',
                Icons.admin_panel_settings_outlined,
                _enableAdminAdjustments,
                (v) => setState(() => _enableAdminAdjustments = v),
                enabled: _isEnabled,
              ),
              SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _isSaving ? null : _save,
                icon: _isSaving
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: cs.onPrimary,
                        ),
                      )
                    : Icon(Icons.save),
                label: Text(_isSaving ? 'Saving...' : 'Save Settings'),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged, {
    bool enabled = true,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: SwitchListTile(
        secondary: Icon(icon, color: cs.primary),
        title: Text(title, style: AdminTextStyles.body(context)),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: cs.onSurfaceVariant,
          ),
        ),
        value: value,
        onChanged: enabled ? onChanged : null,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool enabled,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _save() async {
    final percent = double.tryParse(_percentCtrl.text.trim());
    final minOrder = double.tryParse(_minOrderCtrl.text.trim());
    final expiryDays = int.tryParse(_expiryDaysCtrl.text.trim());

    if (percent == null || percent <= 0 || percent > 100) {
      _showError('Redemption limit must be between 1 and 100.');
      return;
    }
    if (minOrder == null || minOrder < 0) {
      _showError('Minimum order amount must be 0 or more.');
      return;
    }
    if (_enableExpiry && (expiryDays == null || expiryDays < 1)) {
      _showError('Expiry days must be at least 1.');
      return;
    }

    setState(() => _isSaving = true);
    final updated = FreshPointsSettings(
      isEnabled: _isEnabled,
      redemptionPercentageLimit: percent,
      allowRedemptionOnCOD: _allowCOD,
      minimumOrderForRedemption: minOrder,
      enablePointExpiry: _enableExpiry,
      pointExpiryDays: expiryDays ?? 365,
      enableAdminAdjustments: _enableAdminAdjustments,
      updatedAt: DateTime.now(),
    );
    final success = await _controller.saveSettings(updated);
    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      Get.snackbar(
        'Success',
        'FreshPoints settings saved.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      _showError('Failed to save settings. Please try again.');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Theme.of(context).colorScheme.error,
      colorText: Colors.white,
    );
  }
}
