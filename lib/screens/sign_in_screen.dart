import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hangmatch/components/form_component.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() {
    return _SignInScreenState();
  }
}

class _SignInScreenState extends State<SignInScreen> {
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
