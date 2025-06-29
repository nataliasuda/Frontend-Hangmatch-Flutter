import 'package:flutter/material.dart';
import 'package:hangmatch/widgets/heading.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(39),
            child: ElevatedButton(
              onPressed: () {},

              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF884EE9),
                foregroundColor: Colors.white,
                minimumSize: Size(338, 61),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add, size: 28),
                  SizedBox(width: 12),
                  Text('Add new friend', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),

          Heading(text: 'Acceptable'),
          SizedBox(height: 32),
          Heading(text: 'Friends'),
        ],
      ),
    );
  }
}
