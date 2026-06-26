import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import '../services/api_client.dart';

class AdminDeliveryVerificationController {
  static final AdminDeliveryVerificationController instance =
      AdminDeliveryVerificationController._();

  AdminDeliveryVerificationController._();

  final _client = ServerpodAdminClient().client;

  Future<bool> completePhotoDelivery({
    required String orderId,
    required String imageUrl,
    required double latitude,
    required double longitude,
    required double gpsAccuracy,
  }) async {
    return ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      return await _client.order.completePhotoDelivery(
        orderId,
        imageUrl,
        latitude,
        longitude,
        gpsAccuracy,
        firebaseUid: uid,
        idToken: idToken,
      );
    });
  }
}
