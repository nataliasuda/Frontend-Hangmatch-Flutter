import 'package:flutter/material.dart';
import 'package:hangmatch/models/event.dart';
import 'package:hangmatch/services/event_service.dart';
import 'package:hangmatch/widgets/swipe_card.dart';
import 'package:hangmatch/widgets/vote_buttons.dart';

class VoteScreen extends StatefulWidget {
  const VoteScreen({super.key});

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  List<Event> events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    try {
      final fetchedEvents = await EventService().fetchEvents('Wroclaw');
      setState(() {
        events = fetchedEvents;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching events: $e');
      setState(() => isLoading = false);
    }
  }

  void likeEvent() {
    if (events.isEmpty) return;

    print("Liked: ${events.first.name}");

    setState(() {
      events.removeAt(0);
    });
  }

  void dislikeEvent() {
    if (events.isEmpty) return;

    print("Disliked: ${events.first.name}");

    setState(() {
      events.removeAt(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : events.isEmpty
              ? Center(child: Text('No more events to show'))
              : Column(
                children: [
                  SizedBox(height: 95),
                  SwipeCard(event: events.first),
                  SizedBox(height: 54),
                  VoteButtons(onLike: likeEvent, onDislike: dislikeEvent),
                ],
              ),
    );
  }
}
