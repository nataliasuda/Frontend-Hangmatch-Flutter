import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FormComponent extends StatefulWidget {
  final String text;
  final bool isPassword;
  const FormComponent({required this.text, this.isPassword = false, super.key});

  @override
  State<FormComponent> createState() => _FormComponentState();
}

class _FormComponentState extends State<FormComponent> {
  bool _isObscured = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.isPassword ? _isObscured : false,
      decoration: InputDecoration(
        labelText: widget.text,
        labelStyle: TextStyle(color: Colors.white),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                  icon:
                      _isObscured
                          ? SvgPicture.asset('assets/images/shown-password.svg')
                          : SvgPicture.asset(
                            'assets/images/hidden-password.svg',
                          ),
                )
                : null,
      ),
      
    );
  }
}
