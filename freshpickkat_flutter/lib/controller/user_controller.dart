import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find<UserController>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxString userName = ''.obs;
  final RxString userPhone = ''.obs;
  final RxString profileImageUrl = ''.obs;

  // Use protocol Address object
  final Rx<Address?> shippingAddress = Rx<Address?>(null);

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _listenToUserProfile();
  }

  void _listenToUserProfile() {
    // Listen to current user changes in AuthController
    final auth = AuthController.instance;
    ever(auth.currentUser.obs, (user) {
      if (user == null) {
        _resetData();
      } else {
        _startFirestoreListener(user.uid, user.phoneNumber);
      }
    });

    if (auth.currentUser != null) {
      _startFirestoreListener(
        auth.currentUser!.uid,
        auth.currentUser!.phoneNumber,
      );
    }
  }

  void _resetData() {
    userName.value = '';
    userPhone.value = '';
    profileImageUrl.value = '';
    shippingAddress.value = null;
  }

  void _startFirestoreListener(String uid, String? phone) {
    userPhone.value = phone ?? '';

    _firestore.collection('users').doc(uid).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null) {
          userName.value = data['name'] ?? '';
          profileImageUrl.value = data['profileImage'] ?? '';

          // Parse structured address
          if (data['address'] != null && data['address'] is Map) {
            final addrMap = data['address'] as Map<String, dynamic>;
            shippingAddress.value = Address(
              street: addrMap['street'] ?? '',
              city: addrMap['city'] ?? '',
              state: addrMap['state'] ?? '',
              zipCode: addrMap['zipCode'] ?? '',
              country: addrMap['country'] ?? '',
              latitude: (addrMap['latitude'] as num?)?.toDouble(),
              longitude: (addrMap['longitude'] as num?)?.toDouble(),
            );
          } else {
            shippingAddress.value = null;
          }
        }
      } else {
        userName.value = 'Guest User';
      }
    });
  }

  Future<void> updateProfile({required String name, String? imageUrl}) async {
    final user = AuthController.instance.currentUser;
    if (user == null) return;

    isLoading.value = true;
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'phoneNumber': user.phoneNumber,
        'profileImage': ?imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Update local AppUser DTO for consistency in UI components relying on AuthController
      final appUser = AuthController.instance.appUser;
      if (appUser != null) {
        appUser.name = name;
      }
    } catch (e) {
      debugPrint('Error updating profile: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAddress(Address address) async {
    final user = AuthController.instance.currentUser;
    if (user == null) return;

    isLoading.value = true;
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'address': {
          'street': address.street,
          'city': address.city,
          'state': address.state,
          'zipCode': address.zipCode,
          'country': address.country,
          'latitude': address.latitude,
          'longitude': address.longitude,
        },
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Update local AppUser DTO
      final appUser = AuthController.instance.appUser;
      if (appUser != null) {
        appUser.shippingAddress = address;
      }
      shippingAddress.value = address;
    } catch (e) {
      debugPrint('Error updating address: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
