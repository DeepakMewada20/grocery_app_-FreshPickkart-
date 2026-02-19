import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/cart_controller.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:freshpickkat_flutter/utils/protected_navigation_helper.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  // --------- SINGLETON PATTERN ---------
  static AuthController get instance =>
      Get.put(AuthController(), permanent: true);
  // -------------------------------------

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  int? _resendToken;

  // Reactive states
  final Rx<fb.User?> _user = Rx<fb.User?>(null);
  final Rx<AppUser?> appUserRx = Rx<AppUser?>(null);
  final RxString returnRoute = ''.obs;
  Product? _pendingProductToAdd; // Store product to add after login

  final client = ServerpodClient().client;

  @override
  void onInit() {
    super.onInit();
    // Bind current user to reactive variable
    _user.value = _auth.currentUser;
    if (_user.value != null) {
      refreshAppUser();
    }
    _auth.userChanges().listen((fb.User? user) {
      _user.value = user;
      if (user != null) {
        refreshAppUser();
      } else {
        appUserRx.value = null;
      }
    });
  }

  Future<void> refreshAppUser() async {
    if (_user.value == null) return;
    try {
      var user = await client.user.getUserByFirebaseUid(_user.value!.uid);
      if (user == null) {
        // Create new user if not exists
        user = AppUser(
          firebaseUid: _user.value!.uid,
          phoneNumber: _user.value!.phoneNumber ?? '',
        );
        user = await client.user.createOrUpdateUser(user);
      }
      appUserRx.value = user;
      // Fetch cart once user is synced
      CartController.instance.fetchCartFromServer();

      // Check if there's a pending product to add after login
      final pendingProduct = getPendingProductToAdd();
      if (pendingProduct != null) {
        CartController.instance.addItem(pendingProduct);
      }

      // Execute any pending navigation callbacks
      executePendingNavigation();
    } catch (e) {
      debugPrint('Error syncing AppUser: $e');
    }
  }

  // Get current firebase user
  fb.User? get currentUser => _user.value;

  // Get current app user (Serverpod)
  AppUser? get appUser => appUserRx.value;

  // Check if user is logged in
  bool get isLoggedIn => _user.value != null;

  // Send OTP to phone number
  Future<bool> sendOTP({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
    required Function() onAutoVerify,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        forceResendingToken: _resendToken,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto verification (Android only)
          await _auth.signInWithCredential(credential);
          await refreshAppUser();
          onAutoVerify();
        },
        verificationFailed: (FirebaseAuthException e) {
          String errorMessage = 'Verification failed';
          if (e.code == 'invalid-phone-number') {
            errorMessage = 'Invalid phone number format';
          } else if (e.code == 'too-many-requests') {
            errorMessage = 'Too many requests. Please try again later';
          } else if (e.code == 'quota-exceeded') {
            errorMessage = 'SMS quota exceeded. Try again tomorrow';
          }
          onError(errorMessage);
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
      return true;
    } catch (e) {
      onError('Failed to send OTP: ${e.toString()}');
      return false;
    }
  }

  // Verify OTP code
  Future<Map<String, dynamic>> verifyOTP({
    required String verificationId,
    required String otpCode,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode,
      );

      fb.UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      await refreshAppUser();

      return {
        'success': true,
        'user': userCredential.user,
        'isNewUser': userCredential.additionalUserInfo?.isNewUser ?? false,
      };
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Verification failed';
      if (e.code == 'invalid-verification-code') {
        errorMessage = 'Invalid OTP code. Please check and try again';
      } else if (e.code == 'session-expired') {
        errorMessage = 'OTP expired. Please request a new code';
      }
      return {
        'success': false,
        'error': errorMessage,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Something went wrong. Please try again',
      };
    }
  }

  // Resend OTP
  Future<bool> resendOTP({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    return await sendOTP(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onError: onError,
      onAutoVerify: () {},
    );
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get verification ID
  String? get currentVerificationId => _verificationId;

  // Set product to add after login
  void setPendingProductToAdd(Product product) {
    _pendingProductToAdd = product;
  }

  // Get and clear pending product
  Product? getPendingProductToAdd() {
    final product = _pendingProductToAdd;
    _pendingProductToAdd = null;
    return product;
  }
}
