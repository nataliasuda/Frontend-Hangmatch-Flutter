import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hangmatch/components/form_component.dart';
import 'package:hangmatch/components/gradient_button.dart';

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
            Text(
              'HANGMATCH',
              style: TextStyle(
                fontSize: 30,
                color: Color(0xFF884EE9),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height:81),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'SIGN IN',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 66),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
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
            SizedBox(height: 24),
            GradientButton(text: 'SIGN IN', onPressed: (){}, width: 351, height: 63),
          ],
        ),
      ),
    );
  }
}
