import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/screens/cetegoris_screen_with_stick_heder.dart';
import 'package:freshpickkat_flutter/screens/home_screen.dart';
import 'package:freshpickkat_flutter/screens/basket_screen.dart';
import 'package:freshpickkat_flutter/screens/wallet_screen.dart';
import 'package:freshpickkat_flutter/screens/more_screen.dart';
import 'package:freshpickkat_flutter/utils/protected_navigation_helper.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const CategoriesScreenWithStickyHeader(),
    const BasketScreen(),
    WalletScreen(),
    const MoreScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2 || index == 4) {
      ProtectedNavigationHelper.navigateToIndex(
        index: index,
        onNavigate: () {
          setState(() {
            _currentIndex = index;
          });
        },
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
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

        return BottomNavigationBar(
          backgroundColor: navTheme.backgroundColor,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          showUnselectedLabels: true,

          // No selectedItemColor — let selectedIconTheme + selectedLabelStyle work independently
          selectedItemColor: null,

          // Icon: slightly larger & brighter on selection, but NOT green
          selectedIconTheme: IconThemeData(
            color: selectedIconColor,
            size: 26,
          ),
          unselectedIconTheme: IconThemeData(
            color: unselectedIconColor,
            size: 23,
          ),

          // Label: only label turns green when selected
          selectedLabelStyle: const TextStyle(
            color: AppTheme.primaryGreen,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
          unselectedLabelStyle: TextStyle(
            color: unselectedIconColor,
            fontWeight: FontWeight.normal,
            fontSize: 11,
          ),

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket),
              label: 'Basket',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: 'More',
            ),
          ],
        );
      }),
    );
  }
}
