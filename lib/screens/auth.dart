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
  final _form = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredRepeatPassword = '';
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState?.save();

    print('Email entered: $_enteredEmail');
    print('Name entered: $_enteredName');
    print('Password entered: $_enteredPassword');
    if (!isSignIn) {
      print('Repeat Password entered: $_enteredRepeatPassword');
    }
  }

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
                        _form.currentState
                            ?.reset(); // resetuje walidację i wartości pól
                        _passwordController.clear();
                        _repeatPasswordController.clear();
                        _enteredName = '';
                        _enteredEmail = '';
                        _enteredPassword = '';
                        _enteredRepeatPassword = '';
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
                        _form.currentState
                            ?.reset(); // resetuje walidację i wartości pól
                        _passwordController.clear();
                        _repeatPasswordController.clear();
                        _enteredName = '';
                        _enteredEmail = '';
                        _enteredPassword = '';
                        _enteredRepeatPassword = '';
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
                  key: _form,
                  child: Column(
                    children: [
                      if (!isSignIn)
                        FormComponent(
                          text: 'Name',
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name.';
                            }
                            if (value[0] != value[0].toUpperCase()) {
                              return 'Name must start with a capital letter.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredName = value!;
                          },
                        ),
                      if (!isSignIn) SizedBox(height: 20),
                      FormComponent(
                        text: 'E-mail',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email address.';
                          }
                          if (!RegExp(
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
                          ).hasMatch(value)) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredEmail = value!;
                        },
                      ),
                      if (!isSignIn) SizedBox(height: 20),
                      if (isSignIn) SizedBox(height: 40),
                      FormComponent(
                        text: 'Password',
                        isPassword: true,
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your password.';
                          }
                          if (value.trim().length < 6) {
                            return 'Password must be at least 6 characters long.';
                          }
                          if (!RegExp(r'[0-9]').hasMatch(value)) {
                            return 'Password must contain at least one number.';
                          }
                          if (!RegExp(
                            r'[!@#$%^&*(),.?":{}|<>]',
                          ).hasMatch(value)) {
                            return 'Password must contain at least one special character.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredPassword = value!;
                        },
                      ),
                      if (!isSignIn) SizedBox(height: 20),
                      if (!isSignIn)
                        FormComponent(
                          text: 'Repeat password',
                          isPassword: true,
                          controller: _repeatPasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please repeat your password.';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredRepeatPassword = value!;
                          },
                        ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),
              GradientButton(
                text: isSignIn ? 'SIGN IN' : 'SIGN UP',
                onPressed: _submit,
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
