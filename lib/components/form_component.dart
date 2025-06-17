import 'package:flutter/material.dart';

class FormComponent extends StatelessWidget {
  final String text;
  const FormComponent({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: text,
        labelStyle: TextStyle(color: Colors.white),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
