import 'package:flutter/material.dart';
import 'package:hangmatch/widgets/container.dart';

class UpcomingEventCard extends StatelessWidget {
  final String title;
  final String date;
  final VoidCallback? onPressed;

  const UpcomingEventCard({
    required this.title,
    required this.date,

    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: 69,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF5BBEC),
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
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
