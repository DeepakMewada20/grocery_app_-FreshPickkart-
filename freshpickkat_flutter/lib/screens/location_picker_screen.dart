import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/order_controller.dart';
import 'package:freshpickkat_flutter/controller/user_controller.dart';
import 'package:freshpickkat_flutter/services/location_service.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  late TextEditingController _pincodeController;

  // State variables
  bool _isLoadingLocation = false;
  bool _isGeocoding = false;
  Address? _currentAddress;
  final Set<Marker> _markers = {}; // Track if user is dragging map

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
    _pincodeController = TextEditingController(
      text: widget.initialAddress?.zipCode ?? '',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });
  }

  Future<void> _initializeLocation() async {
    _updateMarker(_selectedLocation);
    if (widget.initialAddress == null) {
      setState(() => _isLoadingLocation = true);
      try {
        await _fetchAndSetCurrentLocation();
      } on LocationException catch (e) {
        switch (e.type) {
          case LocationErrorType.serviceDisabled:
            await _showLocationSettingsDialog();
            try {
              await _fetchAndSetCurrentLocation();
              return;
            } on LocationException {
              // Still not available — fall through to finally
            }
          case LocationErrorType.permissionDenied:
            _showSnackBar(e.message, isError: true);
          case LocationErrorType.permissionPermanentlyDenied:
            await _showAppSettingsDialog();
            try {
              await _fetchAndSetCurrentLocation();
              return;
            } on LocationException {
              // Still not available — fall through to finally
            }
          case LocationErrorType.unknown:
            _showSnackBar(e.message, isError: true);
        }
      } catch (e) {
        // unknown error — skip silently
      } finally {
        if (mounted) {
          setState(() => _isLoadingLocation = false);
        }
      }
    }
  }

  Future<void> _fetchAndSetCurrentLocation() async {
    final position = await LocationService.getCurrentLocation();
    setState(() {
      _selectedLocation = LatLng(position.latitude, position.longitude);
    });
    _updateMarker(_selectedLocation);
    await _geocodeSelectedLocation();
    _animateMapToLocation();
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
          if (address.zipCode.isNotEmpty) {
            _pincodeController.text = address.zipCode;
          }
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

  void _updateMarker(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('selected_location'),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
    _updateMarker(location);
    _geocodeSelectedLocation();
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
      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
      });
      _updateMarker(_selectedLocation);
      await _geocodeSelectedLocation();
      _animateMapToLocation();
      _showSnackBar('Location updated');
    } on LocationException catch (e) {
      switch (e.type) {
        case LocationErrorType.serviceDisabled:
          _showLocationSettingsDialog();
        case LocationErrorType.permissionDenied:
          _showSnackBar(e.message, isError: true);
        case LocationErrorType.permissionPermanentlyDenied:
          _showAppSettingsDialog();
        case LocationErrorType.unknown:
          _showSnackBar(e.message, isError: true);
      }
    } catch (e) {
      _showSnackBar('Something went wrong. Please try again.', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoadingLocation = false);
      }
    }
  }

  Future<void> _showLocationSettingsDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Location is Off'),
        content: const Text(
          'Please turn on GPS in your phone settings to find your current location.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
    if (result == true) {
      await Geolocator.openLocationSettings();
    }
  }

  Future<void> _showAppSettingsDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Permission Blocked'),
        content: const Text(
          'Location permission is permanently blocked. Please enable it from App Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Open App Settings'),
          ),
        ],
      ),
    );
    if (result == true) {
      await Geolocator.openAppSettings();
    }
  }

  Future<void> _confirmLocation() async {
    // Build address object from form fields
    final address = Address(
      street: _streetController.text.trim(),
      city: _buildingController.text.trim(),
      state: _landmarkController.text.trim(),
      zipCode: _pincodeController.text.trim(),
      country: _currentAddress?.country ?? '',
      latitude: _selectedLocation.latitude,
      longitude: _selectedLocation.longitude,
    );

    try {
      if (widget.isCheckoutMode) {
        _orderController.setTempDeliveryAddress(address);
        if (_orderController.saveAddressForFuture.value) {
          _userController.updateAddress(address);
        }
        Get.back(result: address);
      } else {
        _userController.shippingAddress.value = address;
        Get.back(result: address);
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
    _pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLandscape = AppResponsive.isLandscape(context);
    final viewInsets = MediaQuery.viewInsetsOf(context);

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
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: _markers,
            onTap: _onMapTap,
          ),

          // Instructions text at top
          Positioned(
            top: 16.h,
            left: 16.w,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Tap on the map to select your location',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
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

          // Current location FAB
          Positioned(
            bottom: 320.h,
            right: 16.w,
            child: FloatingActionButton(
              mini: true,
              onPressed: _isLoadingLocation ? null : _useCurrentLocation,
              backgroundColor: cs.surface,
              child: Icon(
                Icons.my_location,
                color: cs.primary,
              ),
            ),
          ),

          // Bottom sheet with form and buttons
          DraggableScrollableSheet(
            initialChildSize: isLandscape ? 0.62 : 0.35,
            minChildSize: isLandscape ? 0.48 : 0.35,
            maxChildSize: isLandscape ? 0.95 : 0.85,
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
                    padding: EdgeInsets.fromLTRB(
                      20.w,
                      20.h,
                      20.w,
                      20.h + viewInsets.bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Handle bar
                        Center(
                          child: Container(
                            width: 40.w,
                            height: 5.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Street Address
                        Text(
                          'Street Address',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface,
                          ),
                        ),
                        SizedBox(height: 8.h),
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
                        SizedBox(height: 16.h),

                        // Building/Apartment
                        Text(
                          'City',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface,
                          ),
                        ),
                        SizedBox(height: 8.h),
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
                        SizedBox(height: 16.h),

                        // Landmark
                        Text(
                          'State/Region',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface,
                          ),
                        ),
                        SizedBox(height: 8.h),
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
                        SizedBox(height: 16.h),

                        // Pincode
                        Text(
                          'Pincode',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: _pincodeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter pincode',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.numbers),
                          ),
                        ),
                        SizedBox(height: 16.h),

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

                        SizedBox(height: 24.h),

                        // Confirm Location button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isGeocoding ? null : _confirmLocation,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              backgroundColor: cs.primary,
                              foregroundColor: cs.onPrimary,
                              disabledBackgroundColor: Colors.grey[300],
                            ),
                            child: Text(
                              _isGeocoding ? 'Loading...' : 'Confirm Location',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ));
              },
            ),

          ],
        ),
    );
  }
}
