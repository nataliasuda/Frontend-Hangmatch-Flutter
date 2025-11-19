import 'package:flutter/material.dart';
import 'package:hangmatch/models/friend.dart';

class InviteFriendTile extends StatelessWidget {
  final Friend friend;
  final bool isSelected;
  final VoidCallback onSelected;

  const InviteFriendTile({
    super.key,
    required this.friend,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(Icons.person, color: Colors.purpleAccent.shade100),
        title: Text(
          friend.name,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        subtitle: Text(
          friend.email,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
        trailing: Checkbox(
          value: isSelected,
          onChanged: (_) => onSelected(),
          side: BorderSide(color: Colors.purple.shade300),
          activeColor: Colors.purple,
          checkColor: Colors.white,
        ),
      ),
    );
  }
}