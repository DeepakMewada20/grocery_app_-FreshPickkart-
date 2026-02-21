import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/screens/cetegoris_screen_with_stick_heder.dart';
import 'package:freshpickkat_flutter/screens/home_screen.dart';
import 'package:freshpickkat_flutter/screens/basket_screen.dart';
import 'package:freshpickkat_flutter/screens/wallet_screen.dart';
import 'package:freshpickkat_flutter/screens/more_screen.dart';
import 'package:freshpickkat_flutter/utils/protected_navigation_helper.dart';

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
    // Basket (index 2) and More (index 4) require login
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF1B8A4C),
        unselectedItemColor: Colors.white,
        selectedIconTheme: const IconThemeData(color: Colors.grey),
        showUnselectedLabels: true,
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
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
    );
  }
}
