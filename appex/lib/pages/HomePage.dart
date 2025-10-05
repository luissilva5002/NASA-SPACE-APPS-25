import 'package:appex/pages/profile/profile.dart';
import 'package:flutter/material.dart';
import 'Donate.dart';
import 'Map.dart';

class HomePage extends StatefulWidget {
  final int? selectedIndex; // Changed to a non-private named parameter

  const HomePage({Key? key, this.selectedIndex}) : super(key: key);

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  late int _selectedIndex;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex ?? 0;
  }


  // Function to handle bottom navigation bar item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> pages = [
      HeatMapPage(),
      SharkAdoptionPage(),
      MenuPage(),
    ];

    return Scaffold(
      appBar: null,
      body: pages[_selectedIndex],
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }


  // bottomNavigationBar
  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // prevents shifting
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.pin_drop),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.handshake),
          label: 'Donate',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey, // keeps them visible when unselected
      onTap: _onItemTapped,
    );
  }
}
