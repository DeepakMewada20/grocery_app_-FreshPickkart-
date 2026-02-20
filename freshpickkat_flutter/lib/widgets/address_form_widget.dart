import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:freshpickkat_flutter/utils/address_utils.dart';

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
  bool _isLoadingLocation = false;
  bool _showCustomAddress = false;
  int? _selectedIndex;
  List<geo.Placemark> _nearbyPlacemarks = [];

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

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final location = await AddressUtils.getCurrentLocation();
      await _getNearbyAddresses(location.latitude, location.longitude);
      setState(() {
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
      debugPrint('Location error: $e');
    }
  }

  Future<void> _getNearbyAddresses(double lat, double lng) async {
    try {
      final placemarks = await AddressUtils.getNearbyAddresses(lat, lng);
      setState(() {
        _nearbyPlacemarks = placemarks;
        if (_nearbyPlacemarks.isNotEmpty) {
          _selectedIndex = 0;
          _showCustomAddress = false;
        }
      });
    } catch (e) {
      debugPrint('Geocoding error: $e');
    }
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showTitle) ...[
            Text(
              'Select Your Address',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _getTextColor(),
              ),
            ),
            const SizedBox(height: 16),
          ],
          // Name field
          _buildLabel('Your Name *'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _nameController,
            hint: 'Enter your full name',
            icon: Icons.person_outline,
            errorText: _fieldErrors['name'],
            fieldKey: 'name',
          ),
          const SizedBox(height: 24),

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
                    strokeWidth: 2,
                    color: widget.isDarkTheme
                        ? Colors.white
                        : const Color(0xFF00B894),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Current location button
          if (!_isLoadingLocation &&
              _nearbyPlacemarks.isEmpty &&
              !_showCustomAddress)
            _buildLocationButton(),

          // Nearby addresses
          if (_nearbyPlacemarks.isNotEmpty && !_showCustomAddress)
            ..._buildNearbyAddresses(),

          // Custom address option
          if (_nearbyPlacemarks.isNotEmpty || _showCustomAddress) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _showCustomAddress = !_showCustomAddress;
                  if (!_showCustomAddress && _nearbyPlacemarks.isNotEmpty) {
                    _selectedIndex = 0;
                  }
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
                foregroundColor: widget.isDarkTheme
                    ? Colors.white70
                    : const Color(0xFF00B894),
              ),
            ),
          ],

          // Custom address fields
          if (_showCustomAddress) ...[
            const SizedBox(height: 12),
            _buildTextField(
              controller: _streetController,
              hint: 'Street Address',
              icon: Icons.add_home_work_outlined,
              errorText: _fieldErrors['street'],
              fieldKey: 'street',
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _cityController,
              hint: 'City',
              icon: Icons.location_city,
              errorText: _fieldErrors['city'],
              fieldKey: 'city',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _stateController,
                    hint: 'State',
                    icon: Icons.map_outlined,
                    errorText: _fieldErrors['state'],
                    fieldKey: 'state',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _zipController,
                    hint: 'Zip Code',
                    icon: Icons.numbers,
                    errorText: _fieldErrors['zipCode'],
                    fieldKey: 'zipCode',
                  ),
                ),
              ],
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

          const SizedBox(height: 32),
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
            borderRadius: BorderRadius.circular(12),
            border: errorText != null
                ? Border.all(color: Colors.red.withValues(alpha: 0.5))
                : null,
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(fontSize: 15, color: _getTextColor()),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: _getHintColor(), fontSize: 14),
              prefixIcon: Icon(icon, color: Colors.grey[600], size: 22),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
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
          const SizedBox(height: 4),
          Text(
            errorText,
            style: TextStyle(
              color: Colors.red[widget.isDarkTheme ? 400 : 600],
              fontSize: 12,
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
      onTap: _getCurrentLocation,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.isDarkTheme
              ? Colors.blue.withValues(alpha: 0.15)
              : const Color(0xFF00B894).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.isDarkTheme
                ? Colors.blue.withValues(alpha: 0.3)
                : const Color(0xFF00B894).withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.isDarkTheme
                    ? Colors.blue
                    : const Color(0xFF00B894),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.my_location,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Use Current Location',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _getTextColor(),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'We\'ll detect nearby addresses',
                    style: TextStyle(
                      fontSize: 13,
                      color: _getHintColor(),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[widget.isDarkTheme ? 600 : 400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNearbyAddresses() {
    List<Widget> list = [];
    for (int i = 0; i < _nearbyPlacemarks.length; i++) {
      final placemark = _nearbyPlacemarks[i];
      bool isSelected = _selectedIndex == i;
      String formattedAddress = AddressUtils.formatAddress(placemark);

      list.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              final placemark = _nearbyPlacemarks[i];
              setState(() {
                _selectedIndex = i;
                // Auto-populate the controllers with selected address data
                _streetController.text = AddressUtils.extractStreetAndColony(
                  placemark,
                );
                _cityController.text = placemark.locality ?? '';
                _stateController.text = placemark.administrativeArea ?? '';
                _zipController.text = placemark.postalCode ?? '';
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? (widget.isDarkTheme
                          ? Colors.blue.withValues(alpha: 0.2)
                          : const Color(0xFF00B894).withValues(alpha: 0.1))
                    : _getBgColor(),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? (widget.isDarkTheme
                            ? Colors.blue
                            : const Color(0xFF00B894))
                      : (widget.isDarkTheme
                            ? Colors.grey[700]!
                            : Colors.grey[300]!),
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
                        ? (widget.isDarkTheme
                              ? Colors.blue
                              : const Color(0xFF00B894))
                        : (widget.isDarkTheme
                              ? Colors.grey[600]
                              : Colors.grey[400]),
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      formattedAddress,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? _getTextColor() : _getLabelColor(),
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
        ),
      );
    }
    return list;
  }
}
