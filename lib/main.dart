import 'package:farmcast_app/claimForm.dart';
import 'package:farmcast_app/seeClaim.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainAppScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainAppScreen extends StatefulWidget {
  @override
  _MainAppScreenState createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedTabIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SeeClaim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD6F8D6),
      appBar: AppBar(
        backgroundColor: Color(0xFFD6F8D6),
        title: const Text(
          'Farmcast',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Icon(
            Icons.agriculture, // You can use any icon you want here
            size: 40, // Adjust size as per your requirement
            color: Color(0xFF55505C), // Adjust color as per your requirement
          ),
        ),
      ),
      body: _selectedTabIndex == 0 ? ClaimForm() : SeeClaim(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 45, 133, 91),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on, color: Colors.white),
            label: 'Claim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment, color: Colors.white),
            label: 'Status',
          ),
        ],
        currentIndex: _selectedTabIndex,
        selectedItemColor: Color(0xFF55505C),
        onTap: _onItemTapped,
      ),
    );
  }
}
