import 'package:flutter/material.dart';
import 'package:hangmatch/widgets/swipe_card.dart';
import 'package:hangmatch/widgets/vote_buttons.dart';

class VoteScreen extends StatefulWidget {
  const VoteScreen({super.key});

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.only(top: 95), child: SwipeCard()),
          SizedBox(height: 54),
          VoteButtons(),
        ],
      ),
    );
  }
}
