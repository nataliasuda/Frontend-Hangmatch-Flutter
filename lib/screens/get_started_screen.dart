import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 77),
              child: Text(
                "HANGMATCH",
                style: TextStyle(
                  fontSize: 30,
                  color: Color(0xFF884EE9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 75),
            SvgPicture.asset('assets/images/logo.svg', width: 140, height: 199),
            SizedBox(height: 63),
            Text(
              textAlign: TextAlign.center,
              "Hang out\n with friends",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 23),
            Text(
              textAlign: TextAlign.center,
              'Add friends and match on\n activities you like',
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 65),
          ],
        ),
      ),
    );
  }
}
