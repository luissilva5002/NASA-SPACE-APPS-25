import 'package:flutter/material.dart';
import 'dart:convert';

import 'map.dart';

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
      HeatMapPage()
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
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.pin_drop),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Favourites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.handshake),
          label: 'Donate',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue,
      onTap: _onItemTapped,
    );
  }
}
