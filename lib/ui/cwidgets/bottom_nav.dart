import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.group), label: "Groups"),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: "Activity"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
      ],
    );
  }
}
