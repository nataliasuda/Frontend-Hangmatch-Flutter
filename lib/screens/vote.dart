import 'package:flutter/material.dart';
import 'package:hangmatch/models/event.dart';
import 'package:hangmatch/services/event_service.dart';
import 'package:hangmatch/widgets/gradient_button.dart';
import 'package:hangmatch/widgets/swipeable_card.dart';
import 'package:hangmatch/widgets/vote_buttons.dart';
import 'package:hangmatch/screens/results.dart';

class VoteScreen extends StatefulWidget {
  final String sessionId;
  final double userLat;
  final double userLng;
  final double locationRadius;

  const VoteScreen({
    super.key,
    required this.sessionId,
    required this.userLat,
    required this.userLng,
    required this.locationRadius,
  });

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  List<Event> events = [];
  bool isLoading = true;
  int matchCount = 0;

  @override
  void initState() {
    super.initState();
    loadEvents();
    loadMatchCount();
  }

  Future<void> loadEvents() async {
    try {
      final fetchedEvents = await EventService().fetchEventsNearby(
        lat: widget.userLat,
        lng: widget.userLng,
        radiusKm: widget.locationRadius,
      );

      setState(() {
        events = fetchedEvents;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching events: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> loadMatchCount() async {
    try {
      final matchedEvents = await EventService().fetchSessionMatches(
        widget.sessionId,
      );
      setState(() {
        matchCount = matchedEvents.length;
      });
    } catch (e) {
      print('Error loading match count: $e');
    }
  }

  void likeEvent() async {
    if (events.isEmpty) return;

    final event = events.first;

    try {
      await EventService().sendVote(widget.sessionId, event.id, 'like');
      print("Sent LIKE for: ${event.name}");

      await loadMatchCount();
    } catch (e) {
      print("Error sending like: $e");
    }

    setState(() {
      events.removeAt(0);
    });
  }

  void dislikeEvent() async {
    if (events.isEmpty) return;

    final event = events.first;

    try {
      await EventService().sendVote(widget.sessionId, event.id, 'dislike');
      print("Sent DISLIKE for: ${event.name}");

      await loadMatchCount();
    } catch (e) {
      print("Error sending dislike: $e");
    }

    setState(() {
      events.removeAt(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : events.isEmpty
              ? Padding(
                padding: const EdgeInsets.only(left: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "You're done!",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    GradientButton(
                      width: 200,
                      height: 50,
                      text: "See results",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ResultsScreen(
                                  sessionId: widget.sessionId,
                                  userLat: widget.userLat,
                                  userLng: widget.userLng,
                                ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  const SizedBox(height: 60),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF884EE9), Color(0xFFD593F7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Matches $matchCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SwipeableCard(
                          event: events.first,
                          onLike: likeEvent,
                          onDislike: dislikeEvent,
                        ),
                        const SizedBox(height: 54),
                        VoteButtons(onLike: likeEvent, onDislike: dislikeEvent),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
