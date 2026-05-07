import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/controller/tab_navigation_controller.dart';
import 'package:freshpickkat_flutter/screens/cetegoris_screen_with_stick_heder.dart';
import 'package:freshpickkat_flutter/screens/home_screen.dart';
import 'package:freshpickkat_flutter/basket/basket_screen.dart';
import 'package:freshpickkat_flutter/controller/notification_controller.dart';
import 'package:freshpickkat_flutter/screens/notification_screen.dart';
import 'package:freshpickkat_flutter/screens/more_screen.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/utils/protected_navigation_helper.dart';
import 'package:freshpickkat_flutter/services/data_initialization_service.dart';
import 'package:freshpickkat_flutter/widgets/lazy_indexed_stack.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final dataInitService = DataInitializationService.instance;
  final tabController = TabNavigationController.instance;

  @override
  void initState() {
    super.initState();
    // Start global data initialization when the main app UI is ready.
    dataInitService.initializeAppData();
  }

  final List<Widget> _screens = [
    const HomePage(),
    const CategoriesScreenWithStickyHeader(),
    const BasketScreen(),
    const NotificationScreen(),
    const MoreScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2 || index == 4) {
      ProtectedNavigationHelper.navigateToIndex(
        index: index,
        onNavigate: () {
          tabController.navigateToTab(index);
        },
      );
    } else {
      tabController.navigateToTab(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final currentIndex = tabController.currentTabIndex.value;
        return LazyIndexedStack(index: currentIndex, children: _screens);
      }),
      bottomNavigationBar: Obx(() {
        // Rebuild on theme mode change
        ThemeController.instance.themeMode;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final navTheme = Theme.of(context).bottomNavigationBarTheme;

        // Icon colors: light mode → near-black, dark mode → white
        final unselectedIconColor = isDark
            ? Colors.white54
            : const Color(0xFF444444);
        final selectedIconColor = isDark ? Colors.white : Colors.black87;

        final currentIndex = tabController.currentTabIndex.value;
        return BottomNavigationBar(
          backgroundColor: navTheme.backgroundColor,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: _onItemTapped,
          showUnselectedLabels: true,

          // No selectedItemColor — let selectedIconTheme + selectedLabelStyle work independently
          selectedItemColor: null,

          // Icon: slightly larger & brighter on selection, but NOT green
          selectedIconTheme: IconThemeData(
            color: selectedIconColor,
            size: 26.r,
          ),
          unselectedIconTheme: IconThemeData(
            color: unselectedIconColor,
            size: 23.r,
          ),

          // Label: only label turns green when selected
          selectedLabelStyle: TextStyle(
            color: AppTheme.primaryGreen,
            fontWeight: FontWeight.w600,
            fontSize: 11.sp,
          ),
          unselectedLabelStyle: TextStyle(
            color: unselectedIconColor,
            fontWeight: FontWeight.normal,
            fontSize: 11.sp,
          ),

          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Obx(() {
                final count = CartController.instance.itemCount;
                return Badge(
                  label: Text('$count'),
                  isLabelVisible: count > 0,
                  backgroundColor: AppTheme.primaryGreen,
                  textColor: Colors.white,
                  child: const Icon(Icons.shopping_basket),
                );
              }),
              label: 'Basket',
            ),
            BottomNavigationBarItem(
              icon: Obx(() {
                final notificationCount =
                    NotificationController.instance.notifications.length;
                return Badge(
                  label: Text('$notificationCount'),
                  isLabelVisible: notificationCount > 0,
                  backgroundColor: AppTheme.primaryGreen,
                  textColor: Colors.white,
                  child: const Icon(Icons.notifications_outlined),
                );
              }),
              label: 'Notifications',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: 'More',
            ),
          ],
        );
      }),
    );
  }
}
