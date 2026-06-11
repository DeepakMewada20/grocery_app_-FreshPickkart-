import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/banner_controller.dart';
import 'package:freshpickkat_flutter/controller/bogo_controller.dart';
import 'package:freshpickkat_flutter/controller/category_provider_controller.dart';
import 'package:freshpickkat_flutter/controller/combo_offer_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/utils/app_logger.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:freshpickkat_flutter/widgets/offer_widget.dart';

class HomeDataService {
  static final HomeDataService _instance = HomeDataService._internal();
  factory HomeDataService() => _instance;
  HomeDataService._internal();

  final Client _client = ServerpodClient().client;

  Future<HomePageHydratedData> fetchHomePageData() async {
    try {
      final userId = AuthController.instance.appUser?.firebaseUid;

      final data = await _client.home.getHomePageHydrated(
        userId: userId,
        productLimit: 20,
        rankingLimit: 10,
      );

      BannerController.instance.populateFromHydrated(data);
      ProductProviderController.instance.populateFromHydrated(data);
      BogoController.instance.populateFromHydrated(data);
      ComboOfferController.instance.populateFromHydrated(data);
      CategoryProviderController.instance.populateFromHydrated(data);
      OfferWidgetState.cacheHydratedOffer(data.deliveryOffer);
      return data;
    } catch (e) {
      AppLogger.error('HomeData', 'Failed to load home page data: $e');
      rethrow;
    }
  }
}
