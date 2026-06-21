import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/services/appcache/user_cache_service.dart';
import 'package:freshpickkat_flutter/utils/app_logger.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find<UserController>();

  final _cacheService = UserCacheService.instance;

  final RxString userName = ''.obs;
  final RxString userPhone = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString profileImageUrl = ''.obs;
  final Rx<Address?> shippingAddress = Rx<Address?>(null);
  final RxInt currentFreshPoints = 0.obs;
  final RxInt totalFreshPointsEarned = 0.obs;
  final RxInt totalFreshPointsRedeemed = 0.obs;
  final RxBool isLoading = false.obs;

  final client = ServerpodClient().client;

  @override
  void onInit() {
    super.onInit();
    _listenToUserProfile();
  }

  void _listenToUserProfile() {
    final auth = AuthController.instance;
    ever<AppUser?>(auth.appUserRx, (appUser) {
      if (appUser == null) {
        _resetData();
      } else {
        _updateFromAppUser(appUser);
      }
    });
    final appUser = auth.appUserRx.value;
    if (appUser != null) {
      _updateFromAppUser(appUser);
    }
  }

  void _resetData() {
    userName.value = '';
    userPhone.value = '';
    userEmail.value = '';
    profileImageUrl.value = '';
    shippingAddress.value = null;
    currentFreshPoints.value = 0;
    totalFreshPointsEarned.value = 0;
    totalFreshPointsRedeemed.value = 0;
  }

  void _updateFromAppUser(AppUser user) {
    userName.value = user.name ?? '';
    userPhone.value = user.phoneNumber;
    userEmail.value = user.email ?? '';
    shippingAddress.value = user.shippingAddress;
    currentFreshPoints.value = user.currentFreshPoints;
    totalFreshPointsEarned.value = user.totalEarned;
    totalFreshPointsRedeemed.value = user.totalRedeemed;
  }

  Future<void> updateProfile({
    required String name,
    String? email,
    String? imageUrl,
  }) async {
    final auth = AuthController.instance;
    final appUser = auth.appUserRx.value;
    if (appUser == null) return;
    isLoading.value = true;
    try {
      final updatedUser = AppUser(
        firebaseUid: appUser.firebaseUid,
        phoneNumber: appUser.phoneNumber,
        name: name,
        email: email ?? appUser.email,
        shippingAddress: appUser.shippingAddress,
        cart: appUser.cart,
        role: appUser.role,
        fcmToken: appUser.fcmToken,
        currentFreshPoints: appUser.currentFreshPoints,
        totalEarned: appUser.totalEarned,
        totalRedeemed: appUser.totalRedeemed,
      );
      final result = await client.user.createOrUpdateUser(updatedUser);
      auth.appUserRx.value = result;
      await _cacheService.saveUser(result);
      userName.value = result.name ?? '';
      userEmail.value = result.email ?? '';
      currentFreshPoints.value = result.currentFreshPoints;
      totalFreshPointsEarned.value = result.totalEarned;
      totalFreshPointsRedeemed.value = result.totalRedeemed;
    } catch (e) {
      AppLogger.error('User', 'UpdateProfile: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAddress(Address address) async {
    final auth = AuthController.instance;
    final appUser = auth.appUserRx.value;
    if (appUser == null) return;
    isLoading.value = true;
    try {
      final updatedUser = AppUser(
        firebaseUid: appUser.firebaseUid,
        phoneNumber: appUser.phoneNumber,
        name: appUser.name,
        shippingAddress: address,
        cart: appUser.cart,
        role: appUser.role,
        fcmToken: appUser.fcmToken,
        currentFreshPoints: appUser.currentFreshPoints,
        totalEarned: appUser.totalEarned,
        totalRedeemed: appUser.totalRedeemed,
      );
      final result = await client.user.createOrUpdateUser(updatedUser);
      auth.appUserRx.value = result;
      await _cacheService.saveUser(result);
      shippingAddress.value = result.shippingAddress;
      currentFreshPoints.value = result.currentFreshPoints;
      totalFreshPointsEarned.value = result.totalEarned;
      totalFreshPointsRedeemed.value = result.totalRedeemed;
    } catch (e) {
      AppLogger.error('User', 'UpdateAddress: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshUserDataFromServer() async {
    final auth = AuthController.instance;
    if (auth.currentUser == null) return;
    try {
      final freshUser = await client.user.getUserByFirebaseUid(
        auth.currentUser!.uid,
      );
      if (freshUser != null) {
        auth.appUserRx.value = freshUser;
        await _cacheService.saveUser(freshUser);
        _updateFromAppUser(freshUser);
      }
    } catch (e) {
      AppLogger.error('User', 'RefreshData: $e');
    }
  }
}
