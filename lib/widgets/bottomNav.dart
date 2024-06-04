import 'package:farmcast_app/claimForm.dart';
import 'package:farmcast_app/seeClaim.dart';
import 'package:farmcast_app/showData.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  int selectedIndex;

  BottomNav({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  void onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ClaimForm()),
      );
    }

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SeeClaim()),
      );
    }

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReadingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFD6F8D6),
      elevation: 30,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
      selectedIconTheme: const IconThemeData(
        color: Color(0xFF436976),
      ),
      showSelectedLabels: true,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.monetization_on),
          label: 'Claim',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Status',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: 'Readings',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: const Color(0xFF55505C),
      onTap: onItemTapped,
    );
  }
}
