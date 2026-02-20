import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/user_controller.dart';
import 'package:freshpickkat_flutter/widgets/address_form_widget.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipController;
  late TextEditingController _landmarkController;
  late TextEditingController _floorController;
  late TextEditingController _instructionsController;

  bool _isSaving = false;
  final _addressFormKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final user = AuthController.instance.appUser;
    _nameController = TextEditingController(text: user?.name ?? '');
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
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
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

      // Update name
      await userController.updateProfile(name: name);

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
      );

      // Update address
      await userController.updateAddress(address);

      Get.back();
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
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
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddressFormWidget(
                key: _addressFormKey,
                showTitle: false,
                isDarkTheme: true,
                nameController: _nameController,
                streetController: _streetController,
                cityController: _cityController,
                stateController: _stateController,
                zipController: _zipController,
                landmarkController: _landmarkController,
                floorController: _floorController,
                instructionsController: _instructionsController,
                onAddressFetched: (addressData) {
                  // Handle address data if needed
                },
              ),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    disabledBackgroundColor: Colors.grey[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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
                      : const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
