import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hangmatch/components/form_component.dart';
import 'package:hangmatch/components/gradient_button.dart';
import 'package:hangmatch/models/user.dart';
import 'package:hangmatch/services/auth_service.dart';

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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  final userService = UserService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
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

    if (!isSignIn) {
      final register = Register(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        repeatPassword: _repeatPasswordController.text,
      );
      userService.register(context, register);
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
                        _form.currentState?.reset();
                        _nameController.clear();
                        _emailController.clear();
                        _passwordController.clear();
                        _repeatPasswordController.clear();
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
                        _form.currentState?.reset();
                        _nameController.clear();
                        _emailController.clear();
                        _passwordController.clear();
                        _passwordController.clear();
                        _repeatPasswordController.clear();
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
                          controller: _nameController,
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
                            _nameController.text = value!;
                          },
                        ),
                      if (!isSignIn) SizedBox(height: 20),
                      FormComponent(
                        text: 'E-mail',
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
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
                          _emailController.text = value!;
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
                          _passwordController.text = value!;
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
                            _repeatPasswordController.text = value!;
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
