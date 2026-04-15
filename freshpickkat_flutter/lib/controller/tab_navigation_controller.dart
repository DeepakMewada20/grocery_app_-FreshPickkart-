import 'package:get/get.dart';

class TabNavigationController extends GetxController {
  static TabNavigationController get instance => Get.find();

  final RxInt currentTabIndex = 0.obs;

  void navigateToTab(int index) {
    currentTabIndex.value = index;
  }

  void navigateToCategories() => navigateToTab(1);
  void navigateToBasket() => navigateToTab(2);
  void navigateToHome() => navigateToTab(0);
}
