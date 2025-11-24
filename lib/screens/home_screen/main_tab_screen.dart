import 'package:flutter/material.dart';

import '../cart_screen/cart_screen.dart';
import '../favorites_screen/favorites_screen.dart';
import '../profile_screen/profile_screen.dart';
import 'home_screen.dart';

class MainTabScreen extends StatefulWidget {
  static const String route = '/home';

  final int initialTabIndex;

  const MainTabScreen({super.key, this.initialTabIndex = 0});

  @override
  _MainTabScreenState createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  late int _currentIndex;

  final List<Widget> _screens = [
    HomeScreen(),
    CartScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildNavItem(IconData iconData, int index) {
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Icon(
          iconData,
          color: _currentIndex == index
              ? Theme.of(context).colorScheme.onSecondary
              : Colors.grey,
          size: 28,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Color(0xFFF2F2F3)
              : Color(0xFF191A1C),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.light
                  ? Color(0xFFF2F2F3)
                  : Color(0xFF191A1C),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 0),
            _buildNavItem(Icons.shopping_bag_outlined, 1),
            _buildNavItem(Icons.favorite, 2),
            _buildNavItem(Icons.person_outline, 3),
          ],
        ),
      ),
    );
  }
}
