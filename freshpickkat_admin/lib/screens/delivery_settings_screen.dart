import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/controller/admin_delivery_settings_controller.dart';
import 'package:freshpickkat_admin/services/admin_snackbar_service.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/widgets/admin_app_bar.dart';

class DeliverySettingsScreen extends StatefulWidget {
  const DeliverySettingsScreen({super.key});

  @override
  State<DeliverySettingsScreen> createState() => _DeliverySettingsScreenState();
}

class _DeliverySettingsScreenState extends State<DeliverySettingsScreen> {
  final AdminDeliverySettingsController _controller =
      AdminDeliverySettingsController.instance;

  final TextEditingController _radiusController = TextEditingController();
  late bool _cameraOnlyCapture;
  late bool _gpsRequired;
  late bool _strictDistanceValidation;
  late String _defaultMethod;

  @override
  void initState() {
    super.initState();
    _populateFromSettings();
  }

  void _populateFromSettings() {
    final s = _controller.settings.value;
    _defaultMethod = s?.defaultVerificationMethod ?? 'otp';
    _cameraOnlyCapture = s?.cameraOnlyCapture ?? true;
    _gpsRequired = s?.gpsRequired ?? true;
    _strictDistanceValidation = s?.strictDistanceValidation ?? true;
    _radiusController.text =
        (s?.maxAllowedRadiusMeters ?? 200).toString();
  }

  @override
  void dispose() {
    _radiusController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final radius = int.tryParse(_radiusController.text.trim());
    if (radius == null || radius < 10) {
      AdminSnackbarService.show(
        context,
        'Max allowed radius must be at least 10 meters.',
      );
      return;
    }
    if (radius > 5000) {
      AdminSnackbarService.show(
        context,
        'Max allowed radius cannot exceed 5000 meters.',
      );
      return;
    }

    final updated = DeliverySettings(
      defaultVerificationMethod: _defaultMethod,
      cameraOnlyCapture: _cameraOnlyCapture,
      gpsRequired: _gpsRequired,
      strictDistanceValidation: _strictDistanceValidation,
      maxAllowedRadiusMeters: radius,
      updatedAt: DateTime.now(),
    );

    try {
      await _controller.saveSettings(updated);
      if (context.mounted) {
        AdminSnackbarService.show(
          context,
          'Delivery settings updated successfully.',
        );
      }
    } catch (e) {
      if (context.mounted) {
        AdminSnackbarService.show(
          context,
          'Failed to save settings: $e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(title: Text('Delivery Settings')),
      body: Obx(() {
        if (_controller.isLoading.value && _controller.settings.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        // Re-populate if settings changed
        if (_controller.settings.value != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _defaultMethod !=
                (_controller.settings.value?.defaultVerificationMethod ?? 'otp')) {
              _populateFromSettings();
              setState(() {});
            }
          });
        }
        return _buildForm(context);
      }),
    );
  }

  Widget _buildForm(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AdminResponsive.constrainContent(context: context,
      child: ListView(
        padding: AdminResponsive.pagePadding(context),
        children: [
          _buildSectionHeader(context, 'Verification Method'),
          SizedBox(height: 8.h),
          Card(
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Default Delivery Verification Method',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp.clamp(12.0, 16.0),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'New orders will use this method by default.',
                    style: TextStyle(
                      fontSize: 12.sp.clamp(10.0, 13.0),
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  DropdownButtonFormField<String>(
                    initialValue: _defaultMethod,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'otp', child: Text('OTP')),
                      DropdownMenuItem(value: 'photo', child: Text('Photo')),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => _defaultMethod = v);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),

          _buildSectionHeader(context, 'Capture Settings'),
          SizedBox(height: 8.h),
          _buildSwitchTile(
            context,
            'Camera Only Capture',
            'Disable gallery/image selection for delivery proof. Recommended: always enabled.',
            _cameraOnlyCapture,
            (v) => setState(() => _cameraOnlyCapture = v),
          ),
          SizedBox(height: 16.h),

          _buildSectionHeader(context, 'GPS & Location'),
          SizedBox(height: 8.h),
          _buildSwitchTile(
            context,
            'GPS Required',
            'Delivery completion fails if GPS is disabled or location unavailable.',
            _gpsRequired,
            (v) => setState(() => _gpsRequired = v),
          ),
          SizedBox(height: 8.h),
          _buildSwitchTile(
            context,
            'Strict Distance Validation',
            'Validate that delivery proof location is within allowed radius of customer address.',
            _strictDistanceValidation,
            (v) => setState(() => _strictDistanceValidation = v),
          ),
          SizedBox(height: 16.h),

          _buildSectionHeader(context, 'Delivery Radius'),
          SizedBox(height: 8.h),
          Card(
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Maximum Allowed Delivery Radius (Meters)',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp.clamp(12.0, 16.0),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Common: 100, 150, 200, 250, 500 meters',
                    style: TextStyle(
                      fontSize: 12.sp.clamp(10.0, 13.0),
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: _radiusController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '200',
                      suffixText: 'm',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _controller.isSaving.value ? null : _save,
              icon: _controller.isSaving.value
                  ? SizedBox(
                      width: 18.sp,
                      height: 18.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: cs.onPrimary,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(
                _controller.isSaving.value ? 'Saving...' : 'Save Settings',
              ),
            ),
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 15.sp.clamp(13.0, 17.0),
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Card(
      child: SwitchListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14.sp.clamp(12.0, 16.0),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12.sp.clamp(10.0, 13.0),
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
