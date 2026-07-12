import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/network_controller.dart';
import 'package:freshpickkat_flutter/services/deep_link_service.dart';
import 'package:freshpickkat_flutter/utils/app_logger.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';

class ReferralOnboardingDialog extends StatefulWidget {
  const ReferralOnboardingDialog({super.key});

  @override
  State<ReferralOnboardingDialog> createState() =>
      _ReferralOnboardingDialogState();
}

class _ReferralOnboardingDialogState extends State<ReferralOnboardingDialog> {
  final _codeController = TextEditingController();
  final _client = ServerpodClient().client;
  final _auth = AuthController.instance;
  bool _isApplying = false;
  bool _isValidating = false;
  String? _validationMessage;
  bool _isValid = false;
  String? _referrerName;

  @override
  void initState() {
    super.initState();
    _autoFillFromDeepLink();
  }

  void _autoFillFromDeepLink() {
    final pendingCode = DeepLinkService.instance.consumePendingReferralCode();
    if (pendingCode != null && pendingCode.isNotEmpty) {
      _codeController.text = pendingCode;
      _validateCode();
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _validateCode() async {
    final code = _codeController.text.trim();
    if (code.length < 5) {
      setState(() {
        _validationMessage = null;
        _isValid = false;
        _referrerName = null;
      });
      return;
    }

    setState(() {
      _isValidating = true;
      _validationMessage = null;
      _isValid = false;
      _referrerName = null;
    });

    try {
      final uid = _auth.currentUser?.uid ?? '';
      final result = await _client.referral.validateReferralCode(
        code.toUpperCase(),
        uid,
      );
      if (result != null) {
        setState(() {
          _isValid = true;
          _referrerName = result.referrerName;
          _validationMessage = 'Valid code! Referred by $_referrerName';
        });
      } else {
        setState(() {
          _isValid = false;
          _validationMessage = 'Invalid or expired referral code';
        });
      }
    } catch (e) {
      AppLogger.error('ReferralOnboarding', 'Validate failed: $e');
      setState(() {
        _isValid = false;
        _validationMessage = NetworkController.instance.isConnected.value
            ? 'Error validating code'
            : 'No internet connection';
      });
    } finally {
      setState(() => _isValidating = false);
    }
  }

  Future<void> _applyCode() async {
    if (!_isValid) return;

    setState(() => _isApplying = true);
    try {
      final uid = _auth.currentUser?.uid ?? '';
      await _client.referral.applyReferralOnboarding(
        uid,
        _codeController.text.trim().toUpperCase(),
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      AppLogger.error('ReferralOnboarding', 'Apply failed: $e');
      setState(() {
        _validationMessage = NetworkController.instance.isConnected.value
            ? 'Failed to apply code. Please try again.'
            : 'No internet connection';
        _isApplying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AlertDialog(
      backgroundColor: cs.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
      title: Column(
        children: [
          Icon(Icons.card_giftcard_outlined, size: 48, color: cs.primary),
          const SizedBox(height: 12),
          Text(
            'Have a referral code?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter your friend\'s referral code to get ₹50 OFF on your first order!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _codeController,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: 'Enter referral code',
                prefixIcon: Icon(Icons.discount_outlined, color: cs.primary),
                suffixIcon: _isValidating
                    ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: cs.primary,
                          ),
                        ),
                      )
                    : (_codeController.text.length >= 5
                        ? Icon(
                            _isValid ? Icons.check_circle : Icons.cancel,
                            color: _isValid ? Colors.green : Colors.red,
                          )
                        : null),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: cs.primary, width: 2),
                ),
              ),
              onChanged: (_) => _validateCode(),
            ),
            if (_validationMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _validationMessage!,
                style: TextStyle(
                  fontSize: 13,
                  color: _isValid ? Colors.green : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isApplying
                    ? null
                    : () => Navigator.of(context).pop(false),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: cs.onSurfaceVariant),
                ),
                child: Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 16,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: (_isValid && !_isApplying) ? _applyCode : null,
                style: FilledButton.styleFrom(
                  backgroundColor: cs.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isApplying
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: cs.surface,
                        ),
                      )
                    : Text(
                        'Apply Code',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: cs.surface,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
