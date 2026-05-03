import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/order_controller.dart';
import 'package:freshpickkat_flutter/controller/user_controller.dart';
import 'package:freshpickkat_flutter/services/location_service.dart';

class LocationPickerScreen extends StatefulWidget {
  /// If true, saves to OrderController (temp checkout address)
  /// If false, saves to UserController (permanent user address)
  final bool isCheckoutMode;

  /// Initial address to populate fields
  final Address? initialAddress;

  /// Label for the address (Home, Work, etc.) - only for profile mode
  final String addressLabel;

  const LocationPickerScreen({
    super.key,
    required this.isCheckoutMode,
    this.initialAddress,
    this.addressLabel = 'Home',
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late GoogleMapController _mapController;

  // Current selected location (center of map)
  late LatLng _selectedLocation;

  // Form controllers
  late TextEditingController _streetController;
  late TextEditingController _buildingController;
  late TextEditingController _landmarkController;

  // State variables
  bool _isLoadingLocation = false;
  bool _isGeocoding = false;
  Address? _currentAddress;
  bool _mapIsMoving = false; // Track if user is dragging map

  final OrderController _orderController = OrderController.instance;
  final UserController _userController = UserController.instance;

  @override
  void initState() {
    super.initState();

    // Initialize location
    if (widget.initialAddress != null &&
        widget.initialAddress!.latitude != null &&
        widget.initialAddress!.longitude != null) {
      _selectedLocation = LatLng(
        widget.initialAddress!.latitude!,
        widget.initialAddress!.longitude!,
      );
    } else {
      _selectedLocation = const LatLng(28.6139, 77.2090); // Default: Delhi
    }

    _currentAddress = widget.initialAddress;

    // Initialize form controllers
    _streetController = TextEditingController(
      text: widget.initialAddress?.street ?? '',
    );
    _buildingController = TextEditingController(
      text: widget.initialAddress?.city ?? '',
    );
    _landmarkController = TextEditingController(
      text: widget.initialAddress?.state ?? '',
    );

    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    // If no initial address, try to get current GPS location
    if (widget.initialAddress == null) {
      setState(() => _isLoadingLocation = true);
      try {
        final position = await LocationService.getCurrentLocation();
        if (position != null) {
          setState(() {
            _selectedLocation = LatLng(position.latitude, position.longitude);
          });
          // Trigger geocoding to populate fields
          await _geocodeSelectedLocation();
          _animateMapToLocation();
        }
      } catch (e) {
        _showSnackBar('Failed to get current location: $e', isError: true);
      } finally {
        if (mounted) {
          setState(() => _isLoadingLocation = false);
        }
      }
    }
  }

  /// Reverse geocode selected location and populate form fields
  Future<void> _geocodeSelectedLocation() async {
    setState(() => _isGeocoding = true);
    try {
      final address = await LocationService.reverseGeocodeLocation(
        _selectedLocation.latitude,
        _selectedLocation.longitude,
      );

      if (address != null) {
        setState(() {
          _currentAddress = address;
          _streetController.text = address.street;
          _buildingController.text = address.city;
          _landmarkController.text = address.state;
        });
      }
    } catch (e) {
      _showSnackBar('Failed to get address details: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isGeocoding = false);
      }
    }
  }

  /// Handle camera movement - track when user is dragging
  void _onCameraMove(CameraPosition position) {
    if (mounted) {
      setState(() {
        _mapIsMoving = true;
        _selectedLocation = position.target;
      });
    }
  }

  /// Handle when user stops dragging map - fetch address for center location
  Future<void> _onCameraIdle() async {
    if (mounted) {
      setState(() => _mapIsMoving = false);
    }
    // Fetch address for the new center location
    await _geocodeSelectedLocation();
  }

  void _animateMapToLocation() {
    _mapController.animateCamera(
      CameraUpdate.newLatLng(_selectedLocation),
    );
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      final position = await LocationService.getCurrentLocation();
      if (position != null) {
        setState(() {
          _selectedLocation = LatLng(position.latitude, position.longitude);
        });
        await _geocodeSelectedLocation();
        _animateMapToLocation();
        _showSnackBar('Location updated');
      }
    } catch (e) {
      _showSnackBar('Failed to get location: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoadingLocation = false);
      }
    }
  }

  Future<void> _confirmLocation() async {
    // Build address object from form fields
    final address = Address(
      street: _streetController.text.trim(),
      city: _buildingController.text.trim(),
      state: _landmarkController.text.trim(),
      zipCode: _currentAddress?.zipCode ?? '',
      country: _currentAddress?.country ?? '',
      latitude: _selectedLocation.latitude,
      longitude: _selectedLocation.longitude,
    );

    try {
      if (widget.isCheckoutMode) {
        // Checkout mode: save to OrderController (temporary)
        _orderController.setTempDeliveryAddress(address);
        _showSnackBar('Delivery address selected');
        Get.back();
      } else {
        // Profile mode: save to UserController (permanent)
        // Update user's shipping address in database
        _userController.shippingAddress.value = address;
        _showSnackBar('Address saved to profile');
        Get.back();
      }
    } catch (e) {
      _showSnackBar('Failed to save address: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _streetController.dispose();
    _buildingController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isCheckoutMode
              ? 'Select Delivery Location'
              : 'Set Your Address',
        ),
        elevation: 0,
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: 17,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: const {}, // No markers - use fixed center icon instead
            onCameraMove: _onCameraMove, // Track map movement
            onCameraIdle: _onCameraIdle, // Fetch address when movement stops
          ),

          // Center marker pin icon (fixed - shows selected location)
          const Center(
            child: Icon(
              Icons.location_on,
              size: 45,
              color: Colors.red,
            ),
          ),

          // Instructions text at top
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _mapIsMoving
                    ? 'Moving...'
                    : 'Drag the map to select your location',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Loading indicator (if getting location)
          if (_isLoadingLocation)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),

          // Bottom sheet with form and buttons
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.35,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Handle bar
                        Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Use Current Location Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isLoadingLocation
                                ? null
                                : _useCurrentLocation,
                            icon: const Icon(Icons.my_location),
                            label: const Text('Use Current Location'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Street Address
                        Text(
                          'Street Address',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _streetController,
                          decoration: InputDecoration(
                            hintText: 'Enter street address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.location_on_outlined),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Building/Apartment
                        Text(
                          'City',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _buildingController,
                          decoration: InputDecoration(
                            hintText: 'City name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.location_city),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Landmark
                        Text(
                          'State/Region',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _landmarkController,
                          decoration: InputDecoration(
                            hintText: 'State or region name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.map_outlined),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Save for future checkbox (only in checkout mode)
                        if (widget.isCheckoutMode)
                          Obx(() {
                            return CheckboxListTile(
                              value:
                                  _orderController.saveAddressForFuture.value,
                              onChanged: (value) {
                                _orderController.saveAddressForFuture.value =
                                    value ?? false;
                              },
                              title: Text(
                                'Save this address for future orders',
                                style: TextStyle(color: cs.onSurface),
                              ),
                              contentPadding: EdgeInsets.zero,
                            );
                          }),

                        const SizedBox(height: 24),

                        // Confirm Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isGeocoding ? null : _confirmLocation,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: cs.primary,
                              foregroundColor: cs.onPrimary,
                              disabledBackgroundColor: Colors.grey[300],
                            ),
                            child: Text(
                              _isGeocoding ? 'Loading...' : 'Confirm Location',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
