import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hangmatch/components/form_component.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 68),
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                width: 98,
                height: 139,
              ),
            ),
            SizedBox(height: 32),
            Text('HANGMATCH'),
            SizedBox(height: 81),
            Row(
              children: [
                TextButton(onPressed: () {}, child: Text('Sign in')),
                SizedBox(width: 66),
                TextButton(onPressed: () {}, child: Text('Sign Up')),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 65),
              child: Form(
                child: Column(
                  children: [
                    FormComponent(text: 'E-mail'),
                    SizedBox(height: 42),
                    FormComponent(text: 'Password'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
