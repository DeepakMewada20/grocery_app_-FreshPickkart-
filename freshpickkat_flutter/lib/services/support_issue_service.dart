import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SupportIssueService {
  SupportIssueService._();

  static final SupportIssueService instance = SupportIssueService._();

  final _client = ServerpodClient().client;
  final _deviceInfo = DeviceInfoPlugin();

  Future<SupportIssue> submitIssue({
    required String issueType,
    required String title,
    required String description,
    String? screenshotUrl,
  }) async {
    final auth = AuthController.instance;
    final user = auth.currentUser;
    if (user == null) {
      throw Exception('Please login to submit a support issue.');
    }

    final idToken = await auth.requireIdToken();
    final appInfo = await PackageInfo.fromPlatform();
    final deviceInfo = await _buildDeviceInfo();

    return _client.support.submitIssue(
      firebaseUid: user.uid,
      idToken: idToken,
      issueType: issueType,
      title: title,
      description: description,
      screenshotUrl: screenshotUrl,
      appVersion: appInfo.version,
      buildNumber: appInfo.buildNumber,
      deviceInfo: deviceInfo,
    );
  }

  Future<PackageInfo> getAppInfo() => PackageInfo.fromPlatform();

  Future<String> _buildDeviceInfo() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final info = await _deviceInfo.androidInfo;
        return [
          'Platform: Android',
          'Model: ${info.manufacturer} ${info.model}',
          'Android: ${info.version.release}',
          'SDK: ${info.version.sdkInt}',
        ].join(' | ');
      }

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final info = await _deviceInfo.iosInfo;
        return [
          'Platform: iOS',
          'Model: ${info.utsname.machine}',
          'System: ${info.systemName} ${info.systemVersion}',
        ].join(' | ');
      }

      final info = await _deviceInfo.deviceInfo;
      return 'Platform: ${defaultTargetPlatform.name} | ${info.data}';
    } catch (_) {
      return 'Platform: ${defaultTargetPlatform.name} | Device: Unknown';
    }
  }
}
