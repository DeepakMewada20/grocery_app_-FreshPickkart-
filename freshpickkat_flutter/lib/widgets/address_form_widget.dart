import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/user_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import 'package:freshpickkat_flutter/core/design_system/app_icons.dart';
import 'package:get/get.dart';

class AddressFormWidget extends StatefulWidget {
  final bool showTitle;
  final void Function(Map<String, dynamic> addressData) onAddressFetched;
  final bool isDarkTheme;
  final TextEditingController? emailController;
  final TextEditingController? nameController;
  final TextEditingController? streetController;
  final TextEditingController? cityController;
  final TextEditingController? stateController;
  final TextEditingController? zipController;
  final TextEditingController? landmarkController;
  final TextEditingController? floorController;
  final TextEditingController? instructionsController;

  const AddressFormWidget({
    super.key,
    this.showTitle = true,
    required this.onAddressFetched,
    this.isDarkTheme = false,
    this.emailController,
    this.nameController,
    this.streetController,
    this.cityController,
    this.stateController,
    this.zipController,
    this.landmarkController,
    this.floorController,
    this.instructionsController,
  });

  @override
  State<AddressFormWidget> createState() => _AddressFormWidgetState();
}

class _AddressFormWidgetState extends State<AddressFormWidget> {
  Address? _selectedAddress;

  // Field-level error tracking
  final Map<String, String?> _fieldErrors = {
    'name': null,
    'street': null,
    'city': null,
    'state': null,
    'zipCode': null,
  };

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipController;
  late TextEditingController _landmarkController;
  late TextEditingController _floorController;
  late TextEditingController _instructionsController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = widget.nameController ?? TextEditingController();
    _emailController = widget.emailController ?? TextEditingController();
    _streetController = widget.streetController ?? TextEditingController();
    _cityController = widget.cityController ?? TextEditingController();
    _stateController = widget.stateController ?? TextEditingController();
    _zipController = widget.zipController ?? TextEditingController();
    _landmarkController = widget.landmarkController ?? TextEditingController();
    _floorController = widget.floorController ?? TextEditingController();
    _instructionsController =
        widget.instructionsController ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.nameController == null) _nameController.dispose();
    if (widget.emailController == null) _emailController.dispose();
    if (widget.streetController == null) _streetController.dispose();
    if (widget.cityController == null) _cityController.dispose();
    if (widget.stateController == null) _stateController.dispose();
    if (widget.zipController == null) _zipController.dispose();
    if (widget.landmarkController == null) _landmarkController.dispose();
    if (widget.floorController == null) _floorController.dispose();
    if (widget.instructionsController == null) {
      _instructionsController.dispose();
    }
    super.dispose();
  }

  Color _getBgColor() {
    return widget.isDarkTheme ? const Color(0xFF1A1A1A) : Colors.grey[100]!;
  }

  Color _getTextColor() {
    return widget.isDarkTheme ? Colors.white : const Color(0xFF2D3436);
  }

  Color _getHintColor() {
    return widget.isDarkTheme ? Colors.white54 : Colors.grey[400]!;
  }

  Color _getLabelColor() {
    return widget.isDarkTheme ? Colors.white70 : Colors.grey[700]!;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final address = UserController.instance.shippingAddress.value;
      if (address != null && address.street.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_selectedAddress?.street != address.street) {
            _selectedAddress = address;
            _streetController.text = address.street;
            _cityController.text = address.city;
            _stateController.text = address.state;
            _zipController.text = address.zipCode;
            widget.onAddressFetched({
              'address': address,
              'latitude': address.latitude,
              'longitude': address.longitude,
            });
            if (mounted) setState(() {});
          }
        });
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showTitle) ...[
            Text(
              'Select Your Address',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: _getTextColor(),
              ),
            ),
            SizedBox(height: 16.h),
          ],
          // Name field
          _buildLabel('Your Name *'),
          SizedBox(height: 8.h),
          _buildTextField(
            controller: _nameController,
            hint: 'Enter your full name',
            icon: Icons.person_outline,
            errorText: _fieldErrors['name'],
            fieldKey: 'name',
          ),
          SizedBox(height: 24.h),

          // Email field
          _buildLabel('Email (Optional)'),
          SizedBox(height: 8.h),
          _buildTextField(
            controller: _emailController,
            hint: 'Enter your email',
            icon: Icons.email_outlined,
          ),
          SizedBox(height: 24.h),

          // Location section
          _buildLabel('Select Address *'),
          SizedBox(height: 12.h),

          // Location display card
          _buildLocationCard(),
          SizedBox(height: 24.h),

          // Optional fields (always visible - map provides the address)
          _buildLabel('Additional Details (Optional)'),
          SizedBox(height: 12.h),

          _buildTextField(
            controller: _floorController,
            hint: 'Floor / Apartment number',
            icon: Icons.apartment_outlined,
          ),
          SizedBox(height: 12.h),

          _buildTextField(
            controller: _landmarkController,
            hint: 'Nearby landmark',
            icon: Icons.place_outlined,
          ),
          SizedBox(height: 12.h),

          _buildTextField(
            controller: _instructionsController,
            hint: 'Delivery instructions',
            icon: Icons.info_outline,
            maxLines: 2,
          ),

          SizedBox(height: 32.h),
        ],
      );
    });
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: _getLabelColor(),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? errorText,
    String? fieldKey,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: _getBgColor(),
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: errorText != null
                ? Border.all(color: Colors.red.withValues(alpha: 0.5))
                : null,
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(fontSize: 15.sp, color: _getTextColor()),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: _getHintColor(), fontSize: 14.sp),
              prefixIcon: Icon(icon, color: Colors.grey[600], size: 22.r),
              border: InputBorder.none,
              contentPadding: AppSpacing.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            onChanged: (value) {
              if (fieldKey != null) {
                _validateField(fieldKey, value);
              }
            },
          ),
        ),
        if (errorText != null) ...[
          SizedBox(height: 4.h),
          Text(
            errorText,
            style: TextStyle(
              color: Colors.red[widget.isDarkTheme ? 400 : 600],
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  void _validateField(String fieldKey, String value) {
    final trimmed = value.trim();
    setState(() {
      if (trimmed.isEmpty) {
        _fieldErrors[fieldKey] = 'This field is required';
      } else {
        _fieldErrors[fieldKey] = null;
      }
    });
  }

  bool _validateAllFields() {
    bool isValid = true;

    // Validate name
    if (_nameController.text.trim().isEmpty) {
      setState(() => _fieldErrors['name'] = 'Name is required');
      isValid = false;
    } else {
      setState(() => _fieldErrors['name'] = null);
    }

    // Validate address selection
    if (_selectedAddress == null) {
      isValid = false;
    }

    return isValid;
  }

  /// Public method to validate all fields - call from parent widget
  bool validateForm() {
    return _validateAllFields();
  }

  Widget _buildLocationCard() {
    final address = _selectedAddress;
    final hasAddress = address != null;
    return InkWell(
      onTap: () async {
        final result = await Get.toNamed(
          '/location-picker',
          arguments: {
            'isCheckoutMode': false,
          },
        );
        final address = result is Address ? result : null;
        if (address != null) {
          setState(() {
            _selectedAddress = address;
            _streetController.text = address.street;
            _cityController.text = address.city;
            _stateController.text = address.state;
            _zipController.text = address.zipCode;
          });
          widget.onAddressFetched({
            'address': address,
            'latitude': address.latitude,
            'longitude': address.longitude,
          });
        }
      },
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: Container(
        width: double.infinity,
        padding: AppSpacing.all(16),
        decoration: BoxDecoration(
          color: widget.isDarkTheme
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.green.shade50,
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on,
              color: hasAddress ? Colors.green : Colors.grey,
              size: AppIcons.extraLarge,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    hasAddress ? 'Selected Location' : 'No Location Selected',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: _getTextColor(),
                    ),
                    maxLines: 1,
                    minFontSize: 11,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    hasAddress
                        ? '${address.street}, ${address.city}, ${address.state} - ${address.zipCode}'
                        : 'Tap "Select from Map" to add your address',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: _getHintColor(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: AppSpacing.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen,
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: AutoSizeText(
                hasAddress ? 'Change' : 'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
                minFontSize: 9,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
