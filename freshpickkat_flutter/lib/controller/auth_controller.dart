import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/banner_controller.dart';
import 'package:freshpickkat_flutter/controller/bogo_controller.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/controller/category_provider_controller.dart';
import 'package:freshpickkat_flutter/services/order_realtime_service.dart';
import 'package:freshpickkat_flutter/controller/notification_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/controller/combo_offer_controller.dart';
import 'package:freshpickkat_flutter/services/appcache/user_cache_service.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:freshpickkat_flutter/utils/protected_navigation_helper.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find<AuthController>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _cacheService = UserCacheService.instance;
  String? _verificationId;
  int? _resendToken;
  bool _isRefreshing = false;

  final Rx<fb.User?> _user = Rx<fb.User?>(null);
  final Rx<AppUser?> appUserRx = Rx<AppUser?>(null);
  final RxString returnRoute = ''.obs;
  Product? _pendingProductToAdd;

  final client = ServerpodClient().client;

  @override
  void onInit() {
    super.onInit();
    _user.value = _auth.currentUser;

    if (_user.value != null) {
      _loadCachedUser();
    }

    _auth.userChanges().listen((fb.User? user) {
      if (user == null) {
        _user.value = null;
        appUserRx.value = null;
        _cacheService.clearUser();
      } else if (user.uid != _user.value?.uid) {
        _user.value = user;
        _loadCachedUser();
        refreshAppUser();
      }
    });
  }

  void _loadCachedUser() {
    final cachedUser = _cacheService.loadUser();
    if (cachedUser != null) {
      appUserRx.value = cachedUser;
      // Load cart count from cache immediately
      CartController.instance.fetchCartFromCache();
    }
  }

  Future<void> refreshAppUser() async {
    if (_user.value == null) return;
    if (_isRefreshing) return;

    _isRefreshing = true;
    try {
      var user = await client.user.getUserByFirebaseUid(_user.value!.uid);
      if (user == null) {
        user = AppUser(
          firebaseUid: _user.value!.uid,
          phoneNumber: _user.value!.phoneNumber ?? '',
          role: 'user',
        );
        user = await client.user.createOrUpdateUser(user);
      }
      appUserRx.value = user;
      await _cacheService.saveUser(user);

      // Revalidate cart from server and unlock sync
      await CartController.instance.fetchCartFromServer();
      CartController.instance.markInitialized();

      NotificationController.instance.syncTokenWithServer();
      try {
        await OrderRealtimeService.instance.startForCurrentUser();
      } catch (e) {
        debugPrint('Error starting order realtime: $e');
      }

      final pendingProduct = getPendingProductToAdd();
      if (pendingProduct != null) {
        CartController.instance.addItem(pendingProduct);
      }

      executePendingNavigation();
    } catch (e) {
      debugPrint('Error syncing AppUser: $e');
    } finally {
      _isRefreshing = false;
    }
  }

  // Get current firebase user
  fb.User? get currentUser => _user.value;

  Future<String> requireIdToken({bool forceRefresh = false}) async {
    final user = currentUser;
    if (user == null) {
      throw Exception('Login required.');
    }
    final token = await user.getIdToken(forceRefresh);
    if (token == null || token.trim().isEmpty) {
      throw Exception('Invalid login session.');
    }
    return token;
  }

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
    _user.value = null;
    appUserRx.value = null;
    _cacheService.clearUser();
    CartController.instance.clearCart();

    ProductProviderController.instance.clearCache();
    BannerController.instance.clearCache();
    CategoryProviderController.instance.clearCache();
    BogoController.instance.clearCache();
    ComboOfferController.instance.clearCache();
    await OrderRealtimeService.instance.stop();

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
