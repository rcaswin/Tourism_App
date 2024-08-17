import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:trip_to_kumari/mediaquery.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Define the route names for each page
    final List<String> pageRoutes = [
      '/homepage',
      '/expore',
      '/mappage',
      '/chatbot',
      '/menu'
    ];

    Navigator.pushNamed(context, pageRoutes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      iconSize: IconSizeScaler.scaleIconSize(context, 24.0),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      type: BottomNavigationBarType.fixed,
      onTap: _onItemTapped,
      selectedFontSize: TextSizeScaler.scaleTextSize(context, 8),
      fixedColor: const Color.fromARGB(255, 32, 100, 231),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      unselectedFontSize: TextSizeScaler.scaleTextSize(context, 8),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Ionicons.home,
            color: Color.fromARGB(255, 32, 100, 231),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Ionicons.search,
            color: Color.fromARGB(255, 32, 100, 231),
          ),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Ionicons.map_sharp,
            color: Color.fromARGB(255, 32, 100, 231),
          ),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Ionicons.chatbubbles_outline,
            color: Color.fromARGB(255, 32, 100, 231),
          ),
          label: 'Chatsbot',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Ionicons.menu_sharp,
            color: Color.fromARGB(255, 32, 100, 231),
          ),
          label: 'menu',
        ),
      ],
    );
  }
}
