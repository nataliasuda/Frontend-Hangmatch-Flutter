import 'package:flutter/material.dart';

class FriendTile extends StatelessWidget {
  final String email;
  final String status;
  final VoidCallback? onAdd;

  const FriendTile({
    super.key,
    required this.email,
    required this.status,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey.shade700,

            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  email,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _statusText(status),
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _buildTrailingIcon(status, onAdd),
        ],
      ),
    );
  }

  static String _statusText(String status) {
    switch (status) {
      case 'not_friends':
        return 'Add to friends';
      case 'pending':
        return 'Invite sent';
      case 'friends':
        return 'Already friends';
      default:
        return '';
    }
  }

  static Widget _buildTrailingIcon(String status, VoidCallback? onAdd) {
    if (status == 'not_friends') {
      return GestureDetector(
        onTap: onAdd,
        child: const Icon(Icons.person_add_alt_1, color: Colors.purpleAccent),
      );
    } else if (status == 'pending') {
      return const Icon(Icons.hourglass_bottom, color: Colors.purpleAccent);
    } else if (status == 'friends') {
      return const Icon(Icons.check, color: Color(0xFF884EE9));
    } else {
      return SizedBox.shrink();
    }
  }
}
