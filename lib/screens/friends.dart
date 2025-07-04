import 'package:flutter/material.dart';
import 'package:hangmatch/screens/add_friend.dart';
import 'package:hangmatch/widgets/manage_friends_card.dart';
import 'package:hangmatch/widgets/heading.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading(text: 'Friends', fontWeight: FontWeight.w600),

        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(39),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddFriendScreen()),
                  );
                },

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
            SizedBox(height: 17),
            ManageFriendsCard(),

            SizedBox(height: 45),
            Heading(text: 'Friends'),
            SizedBox(height: 17),
            ManageFriendsCard(isRemovable: true),
          ],
        ),
      ),
    );
  }
}
