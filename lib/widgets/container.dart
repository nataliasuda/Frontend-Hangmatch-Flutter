import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;

  const CustomContainer({
    super.key,
    required this.child,
    this.height = 60.0,
    this.width = 310.0,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 34),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha((0.1 * 255).toInt()),

            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.1 * 255).toInt()),
                blurRadius: 10.0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 11, left: 30),
            child: child,
          ),
        ),
      ),
    );
  }
}
