import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import '../../services/admin_session_service.dart';
import '../../services/api_client.dart';
import '../../core/exceptions.dart';
import '../network_controller.dart';

class AdminBogoController extends GetxController {
  static AdminBogoController get instance => Get.put(AdminBogoController());

  Client get client => ServerpodAdminClient().client;
  final NetworkController networkController = Get.put(
    NetworkController(),
    tag: 'AdminBogoController',
  );
  final int pageSize = 20;

  final bogoOffers = <BogoOffer>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  final nextPageToken = RxnString();
  final totalCount = 0.obs;

  void _upsertLocal(BogoOffer offer) {
    final index = bogoOffers.indexWhere(
      (item) => item.triggerProductId == offer.triggerProductId,
    );
    if (index == -1) {
      bogoOffers.add(offer);
      totalCount.value++;
    } else {
      bogoOffers[index] = offer;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadBogoOffers();
  }

  Future<void> loadBogoOffers({
    bool force = false,
    bool loadAll = false,
  }) async {
    if (force) {
      bogoOffers.clear();
      nextPageToken.value = null;
      hasMore.value = true;
      totalCount.value = 0;
    }
    if (!force && bogoOffers.isNotEmpty) {
      if (loadAll) {
        await ensureAllLoaded();
      }
      return;
    }

    await loadMore(isInitial: true);
    if (loadAll) {
      await ensureAllLoaded();
    }
  }

  Future<void> loadMore({bool isInitial = false}) async {
    if (isLoadingMore.value) return;
    if (!hasMore.value && !isInitial) return;
    try {
      if (isInitial || bogoOffers.isEmpty) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }
      networkController.hideError();
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      final page = await ApiClient().request(() async {
        return await client.bogo.getOffersPage(
          firebaseUid: uid,
          idToken: idToken,
          limit: pageSize,
          pageToken: nextPageToken.value,
        );
      });
      if (isInitial) {
        bogoOffers.assignAll(page.offers);
      } else {
        bogoOffers.addAll(page.offers);
      }
      nextPageToken.value = page.nextPageToken;
      totalCount.value = page.totalCount;
      hasMore.value = page.nextPageToken != null && page.offers.isNotEmpty;
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
      isLoadingMore.value = false;
    }
  }

  Future<void> ensureAllLoaded() async {
    while (hasMore.value && !isLoadingMore.value) {
      await loadMore();
    }
  }

  Future<bool> deleteOffer(String triggerProductId) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      await client.bogo.deleteOffer(triggerProductId, uid, idToken);
      bogoOffers.removeWhere(
        (offer) => offer.triggerProductId == triggerProductId,
      );
      if (totalCount.value > 0) totalCount.value--;
      return true;
    } catch (e) {
      print('Error deleting BOGO offer: $e');
      return false;
    }
  }

  Future<bool> upsertOffer(BogoOffer offer) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      await client.bogo.upsertOffer(offer, uid, idToken);
      _upsertLocal(offer);
      return true;
    } catch (e) {
      print('Error upserting BOGO offer: $e');
      return false;
    }
  }
}
