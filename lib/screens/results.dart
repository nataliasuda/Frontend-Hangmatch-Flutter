import 'package:flutter/material.dart';
import 'package:hangmatch/models/event.dart';
import 'package:hangmatch/services/event_service.dart';
import 'package:hangmatch/widgets/event_tile.dart';

class ResultsScreen extends StatefulWidget {
  final String sessionId;

  const ResultsScreen({
    super.key,
    required this.sessionId, required userLat, required userLng,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool isLoading = true;
  List<Event> matchedEvents = [];

  @override
  void initState() {
    super.initState();
    loadResults();
  }

  Future<void> loadResults() async {
    try {
      final eventService = EventService();

      // 1. pobierz ID eventów
      final ids = await eventService.fetchSessionMatches(widget.sessionId);

      // 2. pobierz szczegóły eventów z API Ticketmaster (lub lokalnie)
      final List<Event> events = [];
      for (final id in ids) {
        final details = await eventService.fetchEventById(id);
        events.add(details);
      }

      setState(() {
        matchedEvents = events;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Results"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : matchedEvents.isEmpty
              ? const Center(
                  child: Text(
                    "No common matches yet",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: matchedEvents.length,
                  itemBuilder: (_, i) => EventTile(event: matchedEvents[i]),
                ),
    );
  }
}
