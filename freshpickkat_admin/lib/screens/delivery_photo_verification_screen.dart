import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/controller/admin_delivery_verification_controller.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:universal_io/io.dart';

class DeliveryPhotoVerificationScreen extends StatefulWidget {
  const DeliveryPhotoVerificationScreen({
    super.key,
    required this.order,
  });

  final Order order;

  @override
  State<DeliveryPhotoVerificationScreen> createState() =>
      _DeliveryPhotoVerificationScreenState();
}

class _DeliveryPhotoVerificationScreenState
    extends State<DeliveryPhotoVerificationScreen> {
  final AdminDeliveryVerificationController _controller =
      AdminDeliveryVerificationController.instance;

  // Step tracking
  int _step = 0; // 0=camera, 1=preview, 2=validating, 3=uploading, 4=done
  String? _imagePath;
  String? _imageUrl;
  String? _error;
  bool _isProcessing = false;

  // GPS
  double? _latitude;
  double? _longitude;
  double? _gpsAccuracy;
  String? _gpsError;

  @override
  void initState() {
    super.initState();
    _openCamera();
  }

  Future<void> _openCamera() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
      );
      if (picked == null) {
        if (mounted) Navigator.pop(context);
        return;
      }
      setState(() {
        _imagePath = picked.path;
        _step = 1;
      });
    } catch (e) {
      setState(() => _error = 'Failed to capture photo: $e');
    }
  }

  Future<void> _retakePhoto() async {
    setState(() {
      _imagePath = null;
      _imageUrl = null;
      _step = 0;
      _error = null;
    });
    await _openCamera();
  }

  Future<void> _confirmPhoto() async {
    setState(() {
      _isProcessing = true;
      _error = null;
      _step = 2;
    });

    // Step 1: Capture GPS
    final gpsOk = await _captureGps();
    if (!gpsOk) {
      setState(() => _isProcessing = false);
      return;
    }

    // Step 2: Upload image to Firebase Storage
    setState(() => _step = 3);
    final url = await _uploadImage();
    if (url == null) {
      setState(() {
        _isProcessing = false;
        _error = 'Failed to upload proof image. Please try again.';
      });
      return;
    }
    _imageUrl = url;

    // Step 3: Call server endpoint
    setState(() => _step = 4);
    try {
      await _controller.completePhotoDelivery(
        orderId: widget.order.orderId,
        imageUrl: url,
        latitude: _latitude!,
        longitude: _longitude!,
        gpsAccuracy: _gpsAccuracy!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Order delivered successfully!'),
            backgroundColor: AdminAppTheme.getSuccessColor(context),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _error = 'Delivery verification failed: $e';
        _step = 1;
      });
    }
  }

  Future<void> _retryGps() async {
    setState(() {
      _gpsError = null;
      _step = 2;
      _isProcessing = true;
    });
    final gpsOk = await _captureGps();
    if (!gpsOk) {
      setState(() => _isProcessing = false);
      return;
    }
    // GPS success — continue with upload + delivery
    setState(() => _step = 3);
    final url = await _uploadImage();
    if (url == null) {
      setState(() {
        _isProcessing = false;
        _error = 'Failed to upload proof image. Please try again.';
        _step = 1;
      });
      return;
    }
    _imageUrl = url;
    setState(() => _step = 4);
    try {
      await _controller.completePhotoDelivery(
        orderId: widget.order.orderId,
        imageUrl: url,
        latitude: _latitude!,
        longitude: _longitude!,
        gpsAccuracy: _gpsAccuracy!,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Order delivered successfully!'),
            backgroundColor: AdminAppTheme.getSuccessColor(context),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _error = 'Delivery verification failed: $e';
        _step = 1;
      });
    }
  }

  Future<bool> _captureGps() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _gpsError = 'GPS is disabled. Please enable location services.';
      });
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _gpsError = 'Location permission denied.';
        });
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _gpsError = 'Location permission permanently denied. '
            'Please grant it from app settings.';
      });
      return false;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          timeLimit: Duration(seconds: 15),
        ),
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _gpsAccuracy = position.accuracy;
      });

      if (position.accuracy > 100) {
        setState(() {
          _gpsError =
              'GPS signal too weak (accuracy: ${position.accuracy.toStringAsFixed(0)}m). '
              'Please move to an open area and try again.';
        });
        return false;
      }

      return true;
    } catch (e) {
      setState(() {
        _gpsError = 'Failed to get GPS location: $e';
      });
      return false;
    }
  }

  Future<String?> _uploadImage() async {
    try {
      final uid = AdminSessionService.requireUid();
      final now = DateTime.now().millisecondsSinceEpoch;
      final ref = FirebaseStorage.instance
          .ref()
          .child('delivery_proofs')
          .child(uid)
          .child('${now}_delivery_proof.jpg');

      if (kIsWeb) {
        final file = await _getXFile();
        if (file == null) return null;
        final bytes = await file.readAsBytes();
        await ref.putData(bytes);
      } else {
        if (_imagePath == null) return null;
        final file = File(_imagePath!);
        await ref.putFile(file);
      }

      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<XFile?> _getXFile() async {
    if (_imagePath == null) return null;
    return XFile(_imagePath!);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Photo Proof'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _isProcessing ? null : () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: _buildBody(context, cs),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ColorScheme cs) {
    if (_error != null && _imagePath == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 64, color: cs.error),
              const SizedBox(height: 16),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _retakePhoto,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: AdminResponsive.cardPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Step indicator
          _buildStepIndicator(context, cs),
          const SizedBox(height: 24),

          // Content based on step
          if (_step == 1 && _imagePath != null) _buildPreview(context, cs),

          if (_step == 2) _buildGpsCapture(context, cs),
          if (_step == 3) _buildUploading(context, cs),
          if (_step == 4) _buildCompleting(context, cs),

          if (_gpsError != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: cs.error),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _gpsError!,
                      style: TextStyle(color: cs.onErrorContainer),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _isProcessing ? null : _retryGps,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry GPS'),
            ),
          ],

          if (_error != null && _gpsError == null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: cs.error),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _error!,
                      style: TextStyle(color: cs.onErrorContainer),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _isProcessing ? null : _confirmPhoto,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepIndicator(BuildContext context, ColorScheme cs) {
    final steps = ['Capture', 'GPS', 'Upload', 'Complete'];
    return Row(
      children: List.generate(steps.length, (i) {
        final isActive = i <= _step - 1;
        final isCurrent = i == _step - 1;
        return Expanded(
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? AdminAppTheme.getSuccessColor(context)
                      : cs.outlineVariant,
                ),
                child: Center(
                  child: isCurrent
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: cs.onPrimary,
                          ),
                        )
                      : Icon(
                          isActive ? Icons.check : Icons.circle_outlined,
                          size: 16,
                          color: isActive
                              ? AdminThemeTokens.white
                              : cs.onSurfaceVariant,
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                steps[i],
                style: TextStyle(
                  fontSize: 11,
                  color: isActive ? cs.primary : cs.onSurfaceVariant,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPreview(BuildContext context, ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: kIsWeb
              ? Image.network(
                  _imagePath!,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image, size: 100),
                )
              : Image.file(
                  File(_imagePath!),
                  height: 300,
                  fit: BoxFit.cover,
                ),
        ),
        const SizedBox(height: 16),
        Text(
          'Confirm delivery proof photo',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Ensure the photo clearly shows the delivery location.',
          style: TextStyle(
            color: cs.onSurfaceVariant,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isProcessing ? null : _retakePhoto,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Retake'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: FilledButton.icon(
                onPressed: _isProcessing ? null : _confirmPhoto,
                icon: _isProcessing
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: cs.onPrimary,
                        ),
                      )
                    : const Icon(Icons.check_circle),
                label: const Text('Confirm & Capture GPS'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGpsCapture(BuildContext context, ColorScheme cs) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(strokeWidth: 4),
          ),
          const SizedBox(height: 16),
          const Text(
            'Capturing GPS location...',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Please ensure you are at the delivery location.',
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildUploading(BuildContext context, ColorScheme cs) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(strokeWidth: 4),
          ),
          const SizedBox(height: 16),
          const Text(
            'Uploading proof image...',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildCompleting(BuildContext context, ColorScheme cs) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(strokeWidth: 4),
          ),
          const SizedBox(height: 16),
          const Text(
            'Completing delivery...',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
