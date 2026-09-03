import 'package:flutter/material.dart';
import 'dart:async';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[600],
      body: Center(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ 
          Image.asset('assets/images/logo.png'),
          SizedBox(height: 20),

          Text(
            'Coma Bem',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
            SizedBox(height: 20),
          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
          ]
        ),
      ),
    );
  }
}