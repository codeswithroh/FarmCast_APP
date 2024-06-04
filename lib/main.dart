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
      body: const ClaimForm(),
    );
  }
}
