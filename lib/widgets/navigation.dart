import 'package:eb_template/screens/favoriteScreen.dart';
import 'package:flutter/material.dart';

import '../screens/screens.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigation();
}

class _AppNavigation extends State<AppNavigation> {
  int selectedNavbarIndex = 0;


  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const FavoriteScreen(),
    ];
    return Scaffold(
      body: screens[selectedNavbarIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedNavbarIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            selectedNavbarIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorite'),
        ],
      ),
    );
  }
}