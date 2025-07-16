import 'package:flutter/material.dart';
import 'package:hangmatch/screens/create_session.dart';

class NewSessionButton extends StatelessWidget {
  final VoidCallback onSessionCreated;

  const NewSessionButton({super.key, required this.onSessionCreated});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(31),
      child: ElevatedButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateSessionScreen(),
            ),
          );
          if (result == true) {
            onSessionCreated();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFD593F7).withAlpha((0.75 * 255).toInt()),
          minimumSize: Size(342, 98),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.add_box, color: Colors.white, size: 29),
            SizedBox(width: 20),
            Text(
              'New activity session',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
