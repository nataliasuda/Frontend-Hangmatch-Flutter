import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hangmatch/screens/get_started_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (ctx) => const GetStartedScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/logo.svg', width: 140, height: 199),
            const SizedBox(height: 36),
            Text(
              "HANGMATCH",
              style: TextStyle(
                color: Color(0xFF884EE9),
                fontWeight: FontWeight.w500,
                fontSize: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
