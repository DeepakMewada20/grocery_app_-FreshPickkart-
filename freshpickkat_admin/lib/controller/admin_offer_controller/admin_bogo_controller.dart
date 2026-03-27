import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import '../../services/api_client.dart';
import '../../core/exceptions.dart';
import '../network_controller.dart';

class AdminBogoController extends GetxController {
  static AdminBogoController get instance => Get.put(AdminBogoController());

  Client get client => ServerpodAdminClient().client;
  final NetworkController networkController =
      Get.put(NetworkController(), tag: 'AdminBogoController');

  final bogoOffers = <BogoOffer>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBogoOffers();
  }

  Future<void> loadBogoOffers({bool force = false}) async {
    if (!force && bogoOffers.isNotEmpty) return;
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      networkController.hideError();
      final offers = await ApiClient().request(() async {
        return await client.bogo.getActiveOffers();
      });
      bogoOffers.assignAll(offers);
    } on NoInternetException {
      networkController.showError(onRetry: loadBogoOffers);
    } on NetworkException {
      networkController.showError(onRetry: loadBogoOffers);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadBogoOffers);
    } catch (e) {
      print('Error loading BOGO offers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteOffer(String triggerProductId) async {
    try {
      await client.bogo.deleteOffer(triggerProductId);
      await loadBogoOffers();
      return true;
    } catch (e) {
      print('Error deleting BOGO offer: $e');
      return false;
    }
  }

  Future<bool> upsertOffer(BogoOffer offer) async {
    try {
      await client.bogo.upsertOffer(offer);
      await loadBogoOffers();
      return true;
    } catch (e) {
      print('Error upserting BOGO offer: $e');
      return false;
    }
  }
}
