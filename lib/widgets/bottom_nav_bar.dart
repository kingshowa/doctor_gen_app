import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key, required this.selectedIndex});

  int selectedIndex;

  void _onItemTapped(int index, BuildContext context) {
    // Update the selected index

    print(selectedIndex);
    switch (index) {
      case 0:
        selectedIndex != 0 ? Navigator.pushNamed(context, '/home') : "";
        break;
      case 1:
        Navigator.pushNamed(context, '/chat');
        break;
      case 2:
        Navigator.pushNamed(context, '/talk');
        break;
      case 3:
        Navigator.pushNamed(context, '/tips');
        break;
      case 4:
        selectedIndex != 4 ? Navigator.pushNamed(context, '/profile') : "";

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      //backgroundColor: Theme.of(context).colorScheme.primary,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.white.withOpacity(0.6),
      type: BottomNavigationBarType.fixed, // Ensures all items are visible
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/token--chat.svg',
            width: 26,
            height: 26,
            color: Colors.white.withOpacity(0.6), // optional: tint the icon
          ),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/mingcute--mic-2-fill.svg',
            width: 26,
            height: 26,
            color: Colors.white.withOpacity(0.6), // optional: tint the icon
          ),
          label: 'Talk',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.tips_and_updates_outlined),
          label: 'Tips',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
      currentIndex: selectedIndex, // Set the initial selected index
      onTap: (int index) => _onItemTapped(index, context),
    );
  }
}
