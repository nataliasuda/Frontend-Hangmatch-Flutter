import 'package:flutter/material.dart';
import 'package:hangmatch/widgets/container.dart';

class ManageFriendsCard extends StatelessWidget {
  final bool isRemovable;
  const ManageFriendsCard({super.key, this.isRemovable = false});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: 71,
      width: 342,
      child: Row(
        children: [
          CircleAvatar(child: Icon(Icons.person)),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'Zuza',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isRemovable)
            IconButton(
              onPressed: () {},
              iconSize: 27,
              icon: Icon(Icons.delete),
              color: Color(0xFFF5BBEC),
            )
          else ...[
            IconButton(
              icon: Icon(Icons.check),
              color: Color(0xFF884EE9),
              
              iconSize: 27,
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.close),
              color: Color(0xFFF5BBEC),
              iconSize: 27,
              onPressed: () {},
            ),
          ],
        ],
      ),
    );
  }
}
