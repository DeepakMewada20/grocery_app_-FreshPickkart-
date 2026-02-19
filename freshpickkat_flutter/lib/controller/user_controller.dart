import 'package:flutter/foundation.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find<UserController>();

  final RxString userName = ''.obs;
  final RxString userPhone = ''.obs;
  final RxString profileImageUrl = ''.obs;
  final Rx<Address?> shippingAddress = Rx<Address?>(null);
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
    profileImageUrl.value = '';
    shippingAddress.value = null;
  }

  void _updateFromAppUser(AppUser user) {
    userName.value = user.name ?? '';
    userPhone.value = user.phoneNumber;
    shippingAddress.value = user.shippingAddress;
    // profileImageUrl.value = user.profileImage ?? '';
  }

  Future<void> updateProfile({required String name, String? imageUrl}) async {
    final auth = AuthController.instance;
    final appUser = auth.appUserRx.value;
    if (appUser == null) return;
    isLoading.value = true;
    try {
      final updatedUser = AppUser(
        firebaseUid: appUser.firebaseUid,
        phoneNumber: appUser.phoneNumber,
        name: name,
        shippingAddress: appUser.shippingAddress,
        cart: appUser.cart,
      );
      final result = await client.user.createOrUpdateUser(updatedUser);
      auth.appUserRx.value = result;
      userName.value = result.name ?? '';
    } catch (e) {
      debugPrint('Error updating profile: $e');
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
      );
      final result = await client.user.createOrUpdateUser(updatedUser);
      auth.appUserRx.value = result;
      shippingAddress.value = result.shippingAddress;
    } catch (e) {
      debugPrint('Error updating address: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh user data from backend
  Future<void> refreshUserDataFromServer() async {
    final auth = AuthController.instance;
    if (auth.currentUser == null) return;
    try {
      final freshUser = await client.user.getUserByFirebaseUid(
        auth.currentUser!.uid,
      );
      if (freshUser != null) {
        auth.appUserRx.value = freshUser;
        _updateFromAppUser(freshUser);
      }
    } catch (e) {
      debugPrint('Error refreshing user data: $e');
    }
  }
}
