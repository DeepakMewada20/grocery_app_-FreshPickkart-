import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _customAddressController =
      TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  final Location _location = Location();
  final client = ServerpodClient().client;

  bool _isLoadingLocation = false;
  bool _isSaving = false;
  bool _showCustomAddress = false;
  String? _selectedAddress;
  String? _errorMessage;
  List<String> _nearbyAddresses = [];

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _successController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _successScaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _getCurrentLocation();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _slideController,
            curve: Curves.elasticOut,
          ),
        );

    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _successScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _errorMessage = null;
    });

    try {
      // Check if location service is enabled
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          setState(() {
            _isLoadingLocation = false;
            _errorMessage = 'Please enable location services';
          });
          return;
        }
      }

      // Check permissions
      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          setState(() {
            _isLoadingLocation = false;
            _errorMessage = 'Location permission required';
          });
          return;
        }
      }

      // Get current location
      LocationData locationData = await _location.getLocation();

      // Get nearby addresses using reverse geocoding
      await _getNearbyAddresses(
        locationData.latitude!,
        locationData.longitude!,
      );

      setState(() {
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
        _errorMessage = 'Failed to get location: ${e.toString()}';
      });
      debugPrint('Location error: $e');
    }
  }

  Future<void> _getNearbyAddresses(double lat, double lng) async {
    try {
      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        lat,
        lng,
      );

      List<String> addresses = [];

      for (var placemark in placemarks.take(6)) {
        String address = _formatAddress(placemark);
        if (address.isNotEmpty && !addresses.contains(address)) {
          addresses.add(address);
        }
      }

      setState(() {
        _nearbyAddresses = addresses;
        if (addresses.isNotEmpty) {
          _selectedAddress = addresses.first;
        }
      });
    } catch (e) {
      debugPrint('Geocoding error: $e');
      setState(() {
        _errorMessage = 'Failed to get nearby addresses';
      });
    }
  }

  String _formatAddress(geo.Placemark placemark) {
    List<String> parts = [];

    if (placemark.street != null && placemark.street!.isNotEmpty) {
      parts.add(placemark.street!);
    }
    if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
      parts.add(placemark.subLocality!);
    }
    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      parts.add(placemark.locality!);
    }
    if (placemark.administrativeArea != null &&
        placemark.administrativeArea!.isNotEmpty) {
      parts.add(placemark.administrativeArea!);
    }
    if (placemark.postalCode != null && placemark.postalCode!.isNotEmpty) {
      parts.add(placemark.postalCode!);
    }

    return parts.join(', ');
  }

  Future<void> _saveAddress() async {
    // Validate name
    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your name';
      });
      return;
    }

    // Validate address
    String finalAddress = _showCustomAddress
        ? _customAddressController.text.trim()
        : _selectedAddress ?? '';

    if (finalAddress.isEmpty) {
      setState(() {
        _errorMessage = 'Please select or enter an address';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final authController = AuthController.instance;
      if (!authController.isLoggedIn || authController.currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Prepare data
      final appUser =
          authController.appUser ??
          AppUser(
            firebaseUid: authController.currentUser!.uid,
            phoneNumber: authController.currentUser!.phoneNumber ?? '',
          );

      appUser.name = _nameController.text.trim();
      appUser.address = finalAddress;

      // Add optional fields to address if needed, but for now we just save the main address
      // If we want to store landmark etc., we should add them to AppUser model or format them into address string
      if (_landmarkController.text.trim().isNotEmpty ||
          _floorController.text.trim().isNotEmpty) {
        appUser.address =
            '$finalAddress (Floor: ${_floorController.text}, Landmark: ${_landmarkController.text})';
      }

      // Save to Serverpod
      await client.user.createOrUpdateUser(appUser);

      setState(() {
        _isSaving = false;
      });

      // Show success animation
      // await _successController.forward();
      // await Future.delayed(const Duration(milliseconds: 1500));

      // Navigate to home or return route
      if (mounted) {
        final authController = AuthController.instance;
        if (authController.returnRoute.value.isNotEmpty) {
          String route = authController.returnRoute.value;
          authController.returnRoute.value = ''; // Clear it
          Get.offAllNamed(route);
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
        _errorMessage = 'Failed to save: ${e.toString()}';
      });
      debugPrint('Save error: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _customAddressController.dispose();
    _landmarkController.dispose();
    _floorController.dispose();
    _instructionsController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'Setup Your Profile',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Help us deliver to the right location',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name field
                          _buildLabel('Your Name *'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _nameController,
                            hint: 'Enter your full name',
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 24),

                          // Location section
                          Row(
                            children: [
                              _buildLabel('Select Address *'),
                              const Spacer(),
                              if (_isLoadingLocation)
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF00B894),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Current location button
                          if (!_isLoadingLocation && _nearbyAddresses.isEmpty)
                            _buildLocationButton(),

                          // Nearby addresses
                          if (_nearbyAddresses.isNotEmpty &&
                              !_showCustomAddress)
                            ..._buildNearbyAddresses(),

                          // Custom address option
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _showCustomAddress = !_showCustomAddress;
                              });
                            },
                            icon: Icon(
                              _showCustomAddress
                                  ? Icons.location_on
                                  : Icons.edit_location_alt,
                              size: 20,
                            ),
                            label: Text(
                              _showCustomAddress
                                  ? 'Use detected location'
                                  : 'Enter custom address',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF00B894),
                            ),
                          ),

                          // Custom address field
                          if (_showCustomAddress) ...[
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _customAddressController,
                              hint: 'Enter complete address',
                              icon: Icons.location_on_outlined,
                              maxLines: 3,
                            ),
                          ],

                          const SizedBox(height: 24),

                          // Optional fields
                          _buildLabel('Additional Details (Optional)'),
                          const SizedBox(height: 12),

                          _buildTextField(
                            controller: _floorController,
                            hint: 'Floor / Apartment number',
                            icon: Icons.apartment_outlined,
                          ),
                          const SizedBox(height: 12),

                          _buildTextField(
                            controller: _landmarkController,
                            hint: 'Nearby landmark',
                            icon: Icons.place_outlined,
                          ),
                          const SizedBox(height: 12),

                          _buildTextField(
                            controller: _instructionsController,
                            hint: 'Delivery instructions',
                            icon: Icons.info_outline,
                            maxLines: 2,
                          ),

                          // Error message
                          if (_errorMessage != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red[700],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: TextStyle(
                                        color: Colors.red[700],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),

                  // Save button
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveAddress,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00B894),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          disabledBackgroundColor: Colors.grey[300],
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
                                'Continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Success overlay
          if (_successController.isAnimating || _successController.isCompleted)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: ScaleTransition(
                  scale: _successScaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00B894).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Color(0xFF00B894),
                            size: 64,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Profile Saved!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3436),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Welcome to the app',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.grey[600], size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        onChanged: (value) {
          if (_errorMessage != null) {
            setState(() => _errorMessage = null);
          }
        },
      ),
    );
  }

  Widget _buildLocationButton() {
    return InkWell(
      onTap: _getCurrentLocation,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF00B894).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF00B894).withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF00B894),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.my_location,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Use Current Location',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'We\'ll detect nearby addresses',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNearbyAddresses() {
    return _nearbyAddresses.map((address) {
      bool isSelected = _selectedAddress == address;
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedAddress = address;
              _errorMessage = null;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF00B894).withOpacity(0.1)
                  : Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? const Color(0xFF00B894) : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: isSelected
                      ? const Color(0xFF00B894)
                      : Colors.grey[400],
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    address,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected
                          ? const Color(0xFF2D3436)
                          : Colors.grey[700],
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}
