import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  const GradientButton({
    required this.text,
    required this.onPressed,
    required this.width,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF884EE9), Color(0xFFD593F7), Color(0xFFF5BBEC)],
          stops: [0.11, 0.63, 0.91],
        ),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: onPressed,

        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 22)),
      ),
    );
  }
}
