import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/user_controller.dart';
import 'package:freshpickkat_flutter/screens/edit_profile_screen.dart';
import 'package:freshpickkat_flutter/utils/app_snackbar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart'
    if (dart.library.html) 'sms_autofill_stub.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen>
    with TickerProviderStateMixin, CodeAutoFill {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _otpFocusNode = FocusNode();
  final AuthController _authController = AuthController.instance;
  final _storage = GetStorage();

  String _countryCode = '+91';
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
    {'code': '+91', 'country': 'India', 'flag': '🇮🇳'},
    {'code': '+1', 'country': 'US/CA', 'flag': '🇺🇸'},
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
    _initAnimations();
    _resumePendingVerification();
  }

  void _resumePendingVerification() {
    final pendingPhone = _authController.getPendingVerificationPhone();
    if (pendingPhone == null) return;

    // Parse country code and local number
    String localNumber;
    String countryCode;
    if (pendingPhone.startsWith('+')) {
      // Try common country codes
      final knownCodes = ['+91', '+1', '+44', '+61', '+81', '+86', '+49', '+33'];
      String? matchedCode;
      for (final code in knownCodes) {
        if (pendingPhone.startsWith(code)) {
          matchedCode = code;
          break;
        }
      }
      if (matchedCode != null) {
        countryCode = matchedCode;
        localNumber = pendingPhone.substring(matchedCode.length);
      } else {
        // Fallback: assume + followed by country code (1-3 digits)
        final codeMatch = RegExp(r'^\+(\d{1,3})').firstMatch(pendingPhone);
        if (codeMatch != null) {
          countryCode = '+${codeMatch.group(1)}';
          localNumber = pendingPhone.substring(codeMatch.group(0)!.length);
        } else {
          return;
        }
      }
    } else {
      return;
    }

    _phoneController.text = localNumber;
    _countryCode = countryCode;

    // Check if we have a saved verificationId from a previous session
    final savedVerificationId = _authController.getPendingVerificationId();
    if (savedVerificationId != null && savedVerificationId.isNotEmpty) {
      // Resume directly to OTP input without resending
      _verificationId = savedVerificationId;
      _phoneNumber = _countryCode + localNumber;
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _showOtpInput = true;
            _isLoading = false;
          });
          _otpSlideController.forward();
          _startResendTimer();
          _listenForSms();
          Future.delayed(const Duration(milliseconds: 500), () {
            _otpFocusNode.requestFocus();
          });
        }
      });
    } else {
      // Delay to let animations settle, then trigger OTP re-send
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) _sendOTP();
      });
    }
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

  // Future<void> _autoDetectCountryCode() async {
  //   try {
  //     if (Platform.isAndroid) {
  //       SimData simData = SimData();
  //       List<SimDataModel>? simCards = await simData.getSimData();
  //       if (simCards.isNotEmpty) {
  //         String? countryCode = simCards.first.countryCode;
  //         if (countryCode.isNotEmpty) {
  //           setState(() {
  //             _countryCode = countryCode.startsWith('+')
  //                 ? countryCode
  //                 : '+$countryCode';
  //           });
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint('Auto-detect failed: $e');
  //   }
  // }

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
    final localNumber = _phoneController.text.replaceAll(RegExp(r'\D'), '');

    if (localNumber.isEmpty) {
      setState(() => _errorMessage = 'Please enter your phone number');
      return;
    }

    if ((_countryCode == '+91' && localNumber.length != 10) ||
        (_countryCode != '+91' && localNumber.length < 6)) {
      setState(() => _errorMessage = 'Please enter a valid phone number');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _phoneNumber = _countryCode + localNumber;

    await _authController.sendOTP(
      phoneNumber: _phoneNumber,
      onCodeSent: (verificationId) {
        setState(() {
          _isLoading = false;
          _verificationId = verificationId;
          _showOtpInput = true;
        });
        _otpSlideController.forward();
        _startResendTimer();
        _listenForSms();
        Future.delayed(const Duration(milliseconds: 500), () {
          _otpFocusNode.requestFocus();
        });
      },
      onError: (error) {
        setState(() {
          _isLoading = false;
          _errorMessage = error;
        });
      },
      onAutoVerify: () async {
        setState(() => _isLoading = false);

        // Wait for user data to be synced
        await Future.delayed(const Duration(milliseconds: 500));

        // Check if user has profile data (name and address)
        final userController = UserController.instance;
        final hasName = userController.userName.value.isNotEmpty;
        final hasAddress = userController.shippingAddress.value != null;

        if (hasName && hasAddress) {
          // User has profile data, redirect to returnRoute or home
          if (_authController.returnRoute.value.isNotEmpty) {
            String route = _authController.returnRoute.value;
            _authController.returnRoute.value = '';
            Get.offAllNamed(route);
          } else {
            Get.offAllNamed('/home');
          }
        } else {
          // First time user or missing profile data
          // Set flag so referral sheet shows on first home screen visit
          _storage.write('pending_referral_onboarding', true);
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const EditProfileScreen(
                title: 'Setup Your Profile',
                successAction: 'navigateHome',
              ),
            ),
          );
        }
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
      if (mounted) {
        // Check if user has profile data (name and address)
        final userController = UserController.instance;
        final hasName = userController.userName.value.isNotEmpty;
        final hasAddress = userController.shippingAddress.value != null;

        if (hasName && hasAddress) {
          // User has profile data, redirect to returnRoute or home
          if (_authController.returnRoute.value.isNotEmpty) {
            String route = _authController.returnRoute.value;
            _authController.returnRoute.value = '';
            Get.offAllNamed(route);
          } else {
            Get.offAllNamed('/home');
          }
        } else {
          // First time user or missing profile data
          // Set flag so referral sheet shows on first home screen visit
          _storage.write('pending_referral_onboarding', true);
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const EditProfileScreen(
                title: 'Setup Your Profile',
                successAction: 'navigateHome',
              ),
            ),
          );
        }
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
        cancel();
        _listenForSms();
        AppSnackbar.show('Success', 'OTP resent successfully');
      },
      onError: (error) {
        setState(() {
          _isLoading = false;
          _errorMessage = error;
        });
      },
    );
  }

  void _listenForSms() {
    listenForCode();
  }

  @override
  void codeUpdated() {
    if (code != null && code!.length == 6 && mounted) {
      _otpController.text = code!;
      _verifyOTP();
    }
  }

  void _editPhoneNumber() {
    _authController.clearPendingVerification();
    _otpSlideController.reverse();
    _timer?.cancel();
    cancel();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _showOtpInput = false;
          _otpController.clear();
          _errorMessage = null;
        });
        _phoneFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    cancel();
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
    final pinWidth = ((MediaQuery.sizeOf(context).width - 64.w) / 6)
        .clamp(38.w, 50.w)
        .toDouble();
    final defaultPinTheme = PinTheme(
      width: pinWidth,
      height: 56.h.clamp(48.0, 58.0),
      textStyle: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF1B8A4C), width: 2),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1B8A4C).withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade300, width: 2),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          24.w,
                          24.h,
                          24.w,
                          24.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //app logo
                            SizedBox(height: 32.h),
                            Center(
                              child: Image.asset(
                                'lib/assets/images/name_logo.png',
                                height: 80.h.clamp(58.0, 86.0),
                              ),
                            ),
                            SizedBox(height: 32.h),

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
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _showOtpInput
                                        ? 'Enter the verification code'
                                        : 'Enter your phone number to get started',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40.h),

                            // Phone Number Input
                            SlideTransition(
                              position: _slideAnimation,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Phone Number',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      if (_showOtpInput)
                                        TextButton.icon(
                                          onPressed: _editPhoneNumber,
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 16,
                                          ),
                                          label: const Text('Edit'),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Color(0xFF1B8A4C),
                                            padding: EdgeInsets.zero,
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 12.h),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1A1A1A),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color:
                                            _errorMessage != null &&
                                                !_showOtpInput
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
                                          borderRadius:
                                              const BorderRadius.horizontal(
                                                left: Radius.circular(16),
                                              ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16.w,
                                              vertical: 18.h,
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  _countryCode,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                if (!_showOtpInput) ...[
                                                  SizedBox(width: 4.w),
                                                  Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Colors.white70,
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 1.w,
                                          height: 30.h,
                                          color: Colors.grey[600],
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
                                              color: Colors.white,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: 'Phone number',
                                              hintStyle: TextStyle(
                                                color: Colors.grey[500],
                                              ),
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 16.w,
                                                    vertical: 18.h,
                                                  ),
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                15,
                                              ),
                                            ],
                                            onChanged: (value) {
                                              if (_errorMessage != null) {
                                                setState(
                                                  () => _errorMessage = null,
                                                );
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
                              SizedBox(height: 32.h),
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
                                        color: Colors.white70,
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    Text(
                                      'Enter the 6-digit code sent to $_phoneNumber',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
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
                                          color: Color(0xFF1B8A4C),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    Center(
                                      child: _resendTimer > 0
                                          ? Text(
                                              'Resend code in ${_resendTimer}s',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white70,
                                              ),
                                            )
                                          : TextButton(
                                              onPressed: _isLoading
                                                  ? null
                                                  : _resendOTP,
                                              child: _isLoading
                                                  ? SizedBox(
                                                      width: 16.r,
                                                      height: 16.r,
                                                      child:
                                                          CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color: Color(
                                                              0xFF1B8A4C,
                                                            ),
                                                          ),
                                                    )
                                                  : const Text(
                                                      'Resend OTP',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Color(
                                                          0xFF1B8A4C,
                                                        ),
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
                              SizedBox(height: 16.h),
                              Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.red.shade300,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 16,
                                      color: Colors.red[700],
                                    ),
                                    SizedBox(width: 8.w),
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
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 24.w,
                        right: 24.w,
                        bottom: 24.h,
                        top: 8.h,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Action Button
                          SizedBox(
                            width: double.infinity,
                            height: 56.h.clamp(50.0, 62.0),
                            child: ElevatedButton(
                              onPressed: _isLoading || _isVerifying
                                  ? null
                                  : (_showOtpInput ? _verifyOTP : _sendOTP),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF1B8A4C),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                disabledBackgroundColor: Colors.grey[300],
                              ),
                              child: _isLoading || _isVerifying
                                  ? SizedBox(
                                      width: 24.r,
                                      height: 24.r,
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
                          if (!_showOtpInput) ...[
                            SizedBox(height: 20.h),
                            // Terms
                            Center(
                              child: Text(
                                'By continuing, you agree to our Terms & Privacy Policy',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Success overlay
            if (_successController.isAnimating ||
                _successController.isCompleted)
              Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: ScaleTransition(
                    scale: _successScaleAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFF1B8A4C).withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_circle,
                              color: Color(0xFF1B8A4C),
                              size: 64,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Verified!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Welcome to the app',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
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
      ),
    );
  }
}
