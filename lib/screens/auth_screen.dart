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
  bool isSignIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
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
              SizedBox(height: 81),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isSignIn = true;
                      });
                    },
                    child: Text(
                      'SIGN IN',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        decoration:
                            !isSignIn
                                ? TextDecoration.none
                                : TextDecoration.underline,
                        decorationThickness: 3,
                        decorationColor: Color(0xFF884EE9),
                      ),
                    ),
                  ),
                  SizedBox(width: 66),

                  TextButton(
                    onPressed: () {
                      setState(() {
                        isSignIn = false;
                      });
                    },
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        decoration:
                            isSignIn
                                ? TextDecoration.none
                                : TextDecoration.underline,
                        decorationThickness: 3,
                        decorationColor: Color(0xFF884EE9),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: isSignIn ? 30 : 20,
                ),
                child: Form(
                  child: Column(
                    children: [
                      if (!isSignIn) FormComponent(text: 'Name'),
                      if (!isSignIn) SizedBox(height: 20),
                      FormComponent(text: 'E-mail'),
                      if (!isSignIn) SizedBox(height: 20),
                      if (isSignIn) SizedBox(height: 40),
                      FormComponent(text: 'Password', isPassword: true),
                      if (!isSignIn) SizedBox(height: 20),
                      if (!isSignIn)
                        FormComponent(
                          text: 'Repeat password',
                          isPassword: true,
                        ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),
              GradientButton(
                text: isSignIn ? 'SIGN IN' : 'SIGN UP',
                onPressed: () {},
                width: 351,
                height: 63,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
