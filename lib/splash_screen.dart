import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trendy_stack/Home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color(0xFFFF7043), // Inner Orange
              Color(0xFFFFA726), // Middle lighter Orange
              Colors.white,      // Outside fade
            ],
            stops: [0.0, 0.5, 1.0],
            center: Alignment.topCenter,
            radius: 1.2,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 60),
            // 🔥 Title at top
            const Text(
              "Trendy Stack 🚀",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            // 🔥 Logo in middle with rounded corners
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40), // roundness
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover, // fills rounded container
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
