import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sim_data/sim_data.dart';
import 'package:flutter_sim_data/sim_data_model.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:pinput/pinput.dart';
import 'dart:async';
import 'dart:io';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen>
    with TickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _otpFocusNode = FocusNode();
  final AuthController _authController = AuthController();

  String _countryCode = '+1';
  bool _isLoading = false;
  bool _showOtpInput = false;
  bool _isVerifying = false;
  String? _errorMessage;
  String _verificationId = '';
  String _phoneNumber = '';
  int _resendTimer = 60;
  Timer? _timer;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _otpSlideController;
  late AnimationController _successController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<Offset> _otpSlideAnimation;
  late Animation<double> _successScaleAnimation;

  final List<Map<String, String>> _countryCodes = [
    {'code': '+1', 'country': 'US/CA', 'flag': '🇺🇸'},
    {'code': '+91', 'country': 'India', 'flag': '🇮🇳'},
    {'code': '+44', 'country': 'UK', 'flag': '🇬🇧'},
    {'code': '+61', 'country': 'Australia', 'flag': '🇦🇺'},
    {'code': '+81', 'country': 'Japan', 'flag': '🇯🇵'},
    {'code': '+86', 'country': 'China', 'flag': '🇨🇳'},
    {'code': '+49', 'country': 'Germany', 'flag': '🇩🇪'},
    {'code': '+33', 'country': 'France', 'flag': '🇫🇷'},
  ];

  @override
  void initState() {
    super.initState();
    _autoDetectCountryCode();
    _initAnimations();
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

    _otpSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _otpSlideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _otpSlideController,
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

  Future<void> _autoDetectCountryCode() async {
    try {
      if (Platform.isAndroid) {
        SimData simData = SimData();
        List<SimDataModel>? simCards = await simData.getSimData();
        if (simCards.isNotEmpty) {
          String? countryCode = simCards.first.countryCode;
          if (countryCode.isNotEmpty) {
            setState(() {
              _countryCode = countryCode.startsWith('+')
                  ? countryCode
                  : '+$countryCode';
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Auto-detect failed: $e');
    }
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Country Code',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _countryCodes.length,
                itemBuilder: (context, index) {
                  final country = _countryCodes[index];
                  return ListTile(
                    leading: Text(
                      country['flag']!,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(country['country']!),
                    trailing: Text(
                      country['code']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      setState(() => _countryCode = country['code']!);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startResendTimer() {
    _resendTimer = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _sendOTP() async {
    if (_phoneController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter your phone number');
      return;
    }

    if (_phoneController.text.length < 10) {
      setState(() => _errorMessage = 'Please enter a valid phone number');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _phoneNumber = _countryCode + _phoneController.text;

    // ADD THIS DEBUG PRINT
    debugPrint('Sending OTP to: $_phoneNumber');

    await _authController.sendOTP(
      phoneNumber: _phoneNumber,
      onCodeSent: (verificationId) {
        debugPrint('OTP sent successfully'); // ADD THIS
        setState(() {
          _isLoading = false;
          _verificationId = verificationId;
          _showOtpInput = true;
        });
        _otpSlideController.forward();
        _startResendTimer();
        Future.delayed(const Duration(milliseconds: 500), () {
          _otpFocusNode.requestFocus();
        });
      },
      onError: (error) {
        debugPrint('OTP Error: $error'); // ADD THIS
        setState(() {
          _isLoading = false;
          _errorMessage = error;
        });
      },
      onAutoVerify: () {
        debugPrint('Auto verified'); // ADD THIS
        setState(() => _isLoading = false);
        Navigator.pushReplacementNamed(context, '/home');
      },
    );
  }

  Future<void> _verifyOTP() async {
    if (_otpController.text.length < 6) {
      setState(() => _errorMessage = 'Please enter complete OTP');
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    final result = await _authController.verifyOTP(
      verificationId: _verificationId,
      otpCode: _otpController.text,
    );

    if (result['success']) {
      await _successController.forward();
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      setState(() {
        _isVerifying = false;
        _errorMessage = result['error'];
        _otpController.clear();
      });
    }
  }

  Future<void> _resendOTP() async {
    if (_resendTimer > 0) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await _authController.resendOTP(
      phoneNumber: _phoneNumber,
      onCodeSent: (verificationId) {
        setState(() {
          _isLoading = false;
          _verificationId = verificationId;
        });
        _startResendTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP resent successfully'),
            backgroundColor: Color(0xFF00B894),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      onError: (error) {
        setState(() {
          _isLoading = false;
          _errorMessage = error;
        });
      },
    );
  }

  void _editPhoneNumber() {
    setState(() {
      _showOtpInput = false;
      _otpController.clear();
      _errorMessage = null;
    });
    _otpSlideController.reverse();
    _timer?.cancel();
    Future.delayed(const Duration(milliseconds: 300), () {
      _phoneFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _phoneFocusNode.dispose();
    _otpFocusNode.dispose();
    _timer?.cancel();
    _fadeController.dispose();
    _slideController.dispose();
    _otpSlideController.dispose();
    _successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2D3436),
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00B894), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00B894).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade300, width: 2),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: Image.asset(
                        'lib/assets/images/name_logo.png',
                        height: 80,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Welcome text
                    SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome! 👋',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _showOtpInput
                                ? 'Enter the verification code'
                                : 'Enter your phone number to get started',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),

                    // Phone Number Input
                    SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Phone Number',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              if (_showOtpInput)
                                TextButton.icon(
                                  onPressed: _editPhoneNumber,
                                  icon: const Icon(Icons.edit, size: 16),
                                  label: const Text('Edit'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF00B894),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: _showOtpInput
                                  ? Colors.grey[200]
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _errorMessage != null && !_showOtpInput
                                    ? Colors.red.shade300
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: _showOtpInput
                                      ? null
                                      : _showCountryPicker,
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(16),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 18,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          _countryCode,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if (!_showOtpInput) ...[
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.grey[600],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: Colors.grey[300],
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _phoneController,
                                    focusNode: _phoneFocusNode,
                                    enabled: !_showOtpInput,
                                    keyboardType: TextInputType.phone,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Phone number',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                      ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 18,
                                          ),
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(15),
                                    ],
                                    onChanged: (value) {
                                      if (_errorMessage != null) {
                                        setState(() => _errorMessage = null);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // OTP Input Section
                    if (_showOtpInput) ...[
                      const SizedBox(height: 40),
                      SlideTransition(
                        position: _otpSlideAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Verification Code',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Enter the 6-digit code sent to $_phoneNumber',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Pinput(
                                controller: _otpController,
                                focusNode: _otpFocusNode,
                                length: 6,
                                defaultPinTheme: defaultPinTheme,
                                focusedPinTheme: focusedPinTheme,
                                errorPinTheme: _errorMessage != null
                                    ? errorPinTheme
                                    : defaultPinTheme,
                                onCompleted: (pin) => _verifyOTP(),
                                hapticFeedbackType:
                                    HapticFeedbackType.lightImpact,
                                cursor: Container(
                                  width: 2,
                                  height: 22,
                                  color: const Color(0xFF00B894),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: _resendTimer > 0
                                  ? Text(
                                      'Resend code in ${_resendTimer}s',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    )
                                  : TextButton(
                                      onPressed: _isLoading ? null : _resendOTP,
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Color(0xFF00B894),
                                              ),
                                            )
                                          : const Text(
                                              'Resend OTP',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF00B894),
                                              ),
                                            ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Error message
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 16,
                            color: Colors.red[700],
                          ),
                          const SizedBox(width: 4),
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
                    ],

                    SizedBox(height: _showOtpInput ? 60 : 200),

                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading || _isVerifying
                            ? null
                            : (_showOtpInput ? _verifyOTP : _sendOTP),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00B894),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          disabledBackgroundColor: Colors.grey[300],
                        ),
                        child: _isLoading || _isVerifying
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                _showOtpInput
                                    ? 'Verify & Continue'
                                    : 'Send OTP',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Terms
                    if (!_showOtpInput)
                      Center(
                        child: Text(
                          'By continuing, you agree to our Terms & Privacy Policy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                  ],
                ),
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
                          'Verified!',
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
}
