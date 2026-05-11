import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/controller/user_controller.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/widgets/address_form_widget.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class EditProfileScreen extends StatefulWidget {
  final String title;
  final String successAction;

  const EditProfileScreen({
    super.key,
    this.title = 'Edit Profile',
    this.successAction = 'goBack',
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipController;
  late TextEditingController _landmarkController;
  late TextEditingController _floorController;
  late TextEditingController _instructionsController;

  bool _isSaving = false;
  double? _latitude;
  double? _longitude;
  final _addressFormKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final user = AuthController.instance.appUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _streetController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _zipController = TextEditingController();
    _landmarkController = TextEditingController();
    _floorController = TextEditingController();
    _instructionsController = TextEditingController();

    // Load existing address if available
    _loadExistingAddress();
  }

  void _loadExistingAddress() {
    final userController = UserController.instance;
    final address = userController.shippingAddress.value;
    if (address != null) {
      _streetController.text = address.street;
      _cityController.text = address.city;
      _stateController.text = address.state;
      _zipController.text = address.zipCode;
      _latitude = address.latitude;
      _longitude = address.longitude;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _landmarkController.dispose();
    _floorController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    // Validate form using the global key
    try {
      final addressWidget = _addressFormKey.currentState as dynamic;
      if (addressWidget == null || !addressWidget.validateForm()) {
        return;
      }
    } catch (e) {
      debugPrint('Validation error: $e');
      return;
    }

    final name = _nameController.text.trim();
    final street = _streetController.text.trim();
    final city = _cityController.text.trim();
    final state = _stateController.text.trim();
    final zip = _zipController.text.trim();

    setState(() {
      _isSaving = true;
    });

    try {
      final userController = UserController.instance;

      // Update name and email
      final email = _emailController.text.trim();
      await userController.updateProfile(
        name: name,
        email: email.isEmpty ? null : email,
      );

      // Create address
      String combinedStreet = street;
      if (_landmarkController.text.trim().isNotEmpty) {
        combinedStreet += ', near ${_landmarkController.text.trim()}';
      }
      if (_floorController.text.trim().isNotEmpty) {
        combinedStreet += ', Floor: ${_floorController.text.trim()}';
      }
      if (_instructionsController.text.trim().isNotEmpty) {
        combinedStreet += ' (${_instructionsController.text.trim()})';
      }

      final address = Address(
        street: combinedStreet,
        city: city,
        state: state,
        zipCode: zip,
        country: 'India',
        latitude: _latitude,
        longitude: _longitude,
      );

      // Update address
      await userController.updateAddress(address);

      // Set delivery location type
      GetStorage().write('delivery_location_type', 'saved');

      // Handle success action based on source
      if (widget.successAction == 'navigateHome') {
        // For new user setup - show success and navigate home
        Get.offAllNamed('/home');
        Get.snackbar(
          'Success',
          'Profile saved successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.primaryGreen.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      } else {
        // For edit profile from more screen - go back with snackbar
        Get.back();
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.primaryGreen.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      debugPrint('Save error: $e');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppResponsive.pagePadding(context).copyWith(
            bottom:
                MediaQuery.viewInsetsOf(context).bottom +
                24.h +
                MediaQuery.paddingOf(context).bottom,
          ),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: AppResponsive.constrainContent(
            context: context,
            maxWidth: AppResponsive.maxCheckoutWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Address Form
                AddressFormWidget(
                  key: _addressFormKey,
                  showTitle: false,
                  isDarkTheme: isDark,
                  nameController: _nameController,
                  emailController: _emailController,
                  streetController: _streetController,
                  cityController: _cityController,
                  stateController: _stateController,
                  zipController: _zipController,
                  landmarkController: _landmarkController,
                  floorController: _floorController,
                  instructionsController: _instructionsController,
                  onAddressFetched: (addressData) {
                    if (addressData['latitude'] != null) {
                      _latitude = addressData['latitude'] as double?;
                      _longitude = addressData['longitude'] as double?;
                    }
                  },
                ),

                SizedBox(height: 32.h),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56.h.clamp(48.0, 64.0).toDouble(),
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      disabledBackgroundColor: Theme.of(
                        context,
                      ).disabledColor.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : AutoSizeText(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            minFontSize: 12,
                            maxLines: 1,
                          ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
