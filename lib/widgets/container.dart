import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  final bool showBorder;

  const CustomContainer({
    super.key,
    required this.child,
    this.height = 60.0,
    this.width = 310.0,
    this.showBorder = false,
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
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border:
                showBorder
                    ? null
                    : Border.all(color: Colors.white.withValues(alpha: 0.2)),
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
