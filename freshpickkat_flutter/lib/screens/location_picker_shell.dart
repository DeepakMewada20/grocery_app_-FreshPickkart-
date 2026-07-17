import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/screens/location_picker_screen.dart'
    deferred as location_picker_screen;
import 'package:freshpickkat_flutter/services/process_recovery/process_recovery_service.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import 'package:freshpickkat_flutter/core/design_system/app_icons.dart';
import 'package:freshpickkat_flutter/core/design_system/app_text.dart';

class LocationPickerShell extends StatefulWidget {
  const LocationPickerShell({super.key});

  @override
  State<LocationPickerShell> createState() => _LocationPickerShellState();
}

class _LocationPickerShellState extends State<LocationPickerShell> {
  bool _loaded = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      await location_picker_screen.loadLibrary();
      if (mounted) setState(() => _loaded = true);
    } catch (_) {
      if (mounted) setState(() => _error = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Could not load map. Please try again.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    if (!_loaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final args = Get.arguments as Map<String, dynamic>?
        ?? ProcessRecoveryService.recoveredArgs
        ?? {};
    final isCheckoutMode = args['isCheckoutMode'] as bool? ?? false;
    final initialAddress = args['initialAddress'] as Address?;
    final addressLabel = args['addressLabel'] as String? ?? 'Home';

    return location_picker_screen.LocationPickerScreen(
      isCheckoutMode: isCheckoutMode,
      initialAddress: initialAddress,
      addressLabel: addressLabel,
    );
  }
}
