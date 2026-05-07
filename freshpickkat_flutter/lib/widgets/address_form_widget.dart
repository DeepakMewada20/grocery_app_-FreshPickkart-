import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/screens/location_picker_screen.dart';
import 'package:freshpickkat_flutter/controller/user_controller.dart';
import 'package:get/get.dart';

class AddressFormWidget extends StatefulWidget {
  final bool showTitle;
  final void Function(Map<String, dynamic> addressData) onAddressFetched;
  final bool isDarkTheme;
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
  final bool _isLoadingLocation = false;
  final bool _showCustomAddress = false;
  int? _selectedIndex;
  final List<geo.Placemark> _nearbyPlacemarks = [];

  // Field-level error tracking
  final Map<String, String?> _fieldErrors = {
    'name': null,
    'street': null,
    'city': null,
    'state': null,
    'zipCode': null,
  };

  late TextEditingController _nameController;
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
          if (_streetController.text.isEmpty) {
            _streetController.text = address.street;
            _cityController.text = address.city;
            _stateController.text = address.state;
            _zipController.text = address.zipCode;
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

          // Location section
          Row(
            children: [
              _buildLabel('Select Address *'),
              const Spacer(),
              if (_isLoadingLocation)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.r,
                    color: widget.isDarkTheme
                        ? Colors.white
                        : const Color(0xFF00B894),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),

          // Location button - opens map picker
          _buildLocationButton(),

          // TODO: Uncomment if needed - custom address option (removed for map-only selection)
          // Custom address fields
          // if (_showCustomAddress) ...[
          //   const SizedBox(height: 12),
          //   _buildTextField(
          //     controller: _streetController,
          //     hint: 'Street Address',
          //     icon: Icons.add_home_work_outlined,
          //     errorText: _fieldErrors['street'],
          //     fieldKey: 'street',
          //   ),
          //   const SizedBox(height: 12),
          //   _buildTextField(
          //     controller: _cityController,
          //     hint: 'City',
          //     icon: Icons.location_city,
          //     errorText: _fieldErrors['city'],
          //     fieldKey: 'city',
          //   ),
          //   const SizedBox(height: 12),
          //   Row(
          //     children: [
          //       Expanded(
          //         child: _buildTextField(
          //           controller: _stateController,
          //           hint: 'State',
          //           icon: Icons.map_outlined,
          //           errorText: _fieldErrors['state'],
          //           fieldKey: 'state',
          //         ),
          //       ),
          //       const SizedBox(width: 12),
          //       Expanded(
          //         child: _buildTextField(
          //           controller: _zipController,
          //           hint: 'Zip Code',
          //           icon: Icons.numbers,
          //           errorText: _fieldErrors['zipCode'],
          //           fieldKey: 'zipCode',
          //         ),
          //       ),
          //     ],
          //   ),
          // ],
          // ],
          // ]

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
            borderRadius: BorderRadius.circular(12.r),
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
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
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

    // Validate address selection if not custom
    if (!_showCustomAddress &&
        _selectedIndex == null &&
        _nearbyPlacemarks.isNotEmpty) {
      isValid = false;
    }

    // Validate custom address fields if in custom mode
    if (_showCustomAddress) {
      if (_streetController.text.trim().isEmpty) {
        setState(() => _fieldErrors['street'] = 'Street is required');
        isValid = false;
      } else {
        setState(() => _fieldErrors['street'] = null);
      }
      if (_cityController.text.trim().isEmpty) {
        setState(() => _fieldErrors['city'] = 'City is required');
        isValid = false;
      } else {
        setState(() => _fieldErrors['city'] = null);
      }
      if (_stateController.text.trim().isEmpty) {
        setState(() => _fieldErrors['state'] = 'State is required');
        isValid = false;
      } else {
        setState(() => _fieldErrors['state'] = null);
      }
      if (_zipController.text.trim().isEmpty) {
        setState(() => _fieldErrors['zipCode'] = 'Zip code is required');
        isValid = false;
      } else {
        setState(() => _fieldErrors['zipCode'] = null);
      }
    }

    return isValid;
  }

  /// Public method to validate all fields - call from parent widget
  bool validateForm() {
    return _validateAllFields();
  }

  Widget _buildLocationButton() {
    return InkWell(
      onTap: () async {
        final result = await Get.to(
          () => LocationPickerScreen(
            isCheckoutMode: false,
          ),
        );
        if (result != null && result is Address) {
          setState(() {
            _streetController.text = result.street;
            _cityController.text = result.city;
            _stateController.text = result.state;
            _zipController.text = result.zipCode;
          });
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: widget.isDarkTheme
              ? Color(0xFF1B8A4C).withValues(alpha: 0.15)
              : const Color(0xFF00B894).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: widget.isDarkTheme
                ? Color(0xFF1B8A4C).withValues(alpha: 0.3)
                : const Color(0xFF00B894).withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: widget.isDarkTheme
                    ? Color(0xFF1B8A4C)
                    : const Color(0xFF00B894),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.my_location,
                color: Colors.white,
                size: 20.r,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Select from Map',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: _getTextColor(),
                    ),
                    maxLines: 1,
                    minFontSize: 11,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Choose your location on the map',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: _getHintColor(),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[widget.isDarkTheme ? 600 : 400],
              size: 16.r,
            ),
          ],
        ),
      ),
    );
  }
}
