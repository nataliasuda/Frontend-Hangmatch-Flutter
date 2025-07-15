import 'package:flutter/material.dart';
import 'package:hangmatch/widgets/container.dart';

class LastSessionCard extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  const LastSessionCard({required this.title, this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFD593F7),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
