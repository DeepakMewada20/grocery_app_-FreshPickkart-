import 'dart:convert';

import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserCacheService {
  UserCacheService._();
  static UserCacheService get instance => Get.isRegistered<UserCacheService>()
      ? Get.find<UserCacheService>()
      : Get.put(UserCacheService._(), permanent: true);

  static const String _cachedUserKey = 'cached_app_user';
  final GetStorage _storage = GetStorage();

  Future<void> saveUser(AppUser user) async {
    try {
      final json = user.toJson();
      json.remove('cart');
      await _storage.write(_cachedUserKey, jsonEncode(json));
    } catch (_) {
      // Ignore cache errors
    }
  }

  AppUser? loadUser() {
    try {
      final cached = _storage.read<String>(_cachedUserKey);
      if (cached != null) {
        final json = jsonDecode(cached) as Map<String, dynamic>;
        return AppUser.fromJson(json);
      }
    } catch (_) {
      // Ignore cache errors
    }
    return null;
  }

  Future<void> clearUser() async {
    try {
      await _storage.remove(_cachedUserKey);
    } catch (_) {
      // Ignore cache errors
    }
  }
}
