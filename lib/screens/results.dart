import 'package:flutter/material.dart';
import 'package:hangmatch/models/event.dart';
import 'package:hangmatch/services/event_service.dart';
import 'package:hangmatch/widgets/event_tile.dart';
import 'package:hangmatch/screens/home.dart';

class ResultsScreen extends StatefulWidget {
  final String sessionId;
  final double userLat;
  final double userLng;

  const ResultsScreen({
    super.key,
    required this.sessionId,
    required this.userLat,
    required this.userLng,
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
      final ids = await eventService.fetchSessionMatches(widget.sessionId);

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

  void _exitToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Results"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 22),
            child: GestureDetector(
              onTap: _exitToHome,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  // : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Icon(Icons.home, size: 26, color: const Color(0xFFD593F7)),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                isLoading
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: matchedEvents.length,
                      itemBuilder: (_, i) => EventTile(event: matchedEvents[i]),
                    ),
          ),
        ],
      ),
    );
  }
}
