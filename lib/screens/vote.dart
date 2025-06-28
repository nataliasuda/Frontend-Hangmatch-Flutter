import 'package:flutter/material.dart';
import 'package:hangmatch/widgets/swipe_card.dart';

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
          SwipeCard(),
        ],
      ),
    );
  }
}
