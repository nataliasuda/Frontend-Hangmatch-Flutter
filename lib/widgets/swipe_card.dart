import 'package:flutter/material.dart';
import '../models/event.dart';

class SwipeCard extends StatelessWidget {
  final Event event;
  const SwipeCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: SizedBox(
        height: 528,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            children: [
              Image.network(
                event.imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha((0.9 * 255).toInt()),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),

                    // Ikony lokalizacji i daty
                    Row(
                      children: [
                        Icon(Icons.place, color:Color(0xFFD593F7), size: 22),
                        SizedBox(width: 4),
                        Text(
                          event.venue,
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),

                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: Color(0xFFD593F7) ,size: 22),
                        SizedBox(width: 4),
                        Text(
                          event.date,
                          style: TextStyle(color: Colors.white70, fontSize: 14),)])
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
