import 'package:farmcast_app/claimForm.dart';
import 'package:farmcast_app/seeClaim.dart';
import 'package:farmcast_app/widgets/bottomNav.dart';
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
      body: const ClaimForm(),
    );
  }
}
