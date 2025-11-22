import 'package:flutter/material.dart';
import '../widgets/swipe_card.dart';
import '../widgets/vote_buttons.dart';
import '../services/event_service.dart';
import '../models/event.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : events.isEmpty
              ? Center(child: Text('No events found.'))
              : Column(
                  children: [
                    SizedBox(height: 95),
                    SwipeCard(event: events.first),
                    SizedBox(height: 54),
                    VoteButtons(),
                  ],
                ),
    );
  }
}
