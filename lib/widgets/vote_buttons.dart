import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class VoteButtons extends StatelessWidget {
  final VoidCallback onLike;
  final VoidCallback onDislike;

  const VoteButtons({
    super.key,
    required this.onLike,
    required this.onDislike,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onDislike,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(97, 91),
            shape: CircleBorder(),
            backgroundColor: Color(0xFFD593F7),
          ),
          child: SvgPicture.asset(
            'assets/images/reject.svg',
            width: 31,
            height: 31,
          ),
        ),
        SizedBox(width: 107),
        ElevatedButton(
          onPressed: onLike,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(97, 91),
            shape: CircleBorder(),
            backgroundColor: Color(0xFF884EE9),
          ),
          child: SvgPicture.asset(
            'assets/images/thumb-up.svg',
            width: 37,
            height: 35,
          ),
        ),
      ],
    );
  }
}
