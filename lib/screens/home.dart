import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hangmatch/models/session.dart';
import 'package:hangmatch/services/session_service.dart';
import 'package:hangmatch/widgets/heading.dart';
import 'package:hangmatch/widgets/home/last_session_card.dart';
import 'package:hangmatch/widgets/home/new_session_button.dart';
import 'package:hangmatch/widgets/home/upcoming_event_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Session> sessions = [];

  @override
  void initState() {
    _fetchSessions();
    super.initState();
  }

  Future<void> _fetchSessions() async {
    final result = await SessionService().getMySessions(context);
    setState(() {
      sessions = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 75),
                  child: Heading(text: 'Welcome Back!', fontSize: 30),
                ),
                SizedBox(width: 33),
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: 56,
                    height: 77,
                  ),
                ),
              ],
            ),

            SizedBox(height: 11),
            NewSessionButton(onSessionCreated: _fetchSessions),

            Heading(text: 'Last session'),
            SizedBox(height: 22),
            if (sessions.isEmpty)
              const Text('No sessions found.')
            else
              Column(
                children: [
                  if (sessions.isNotEmpty)
                    LastSessionCard(title: sessions[0].name, onPressed: () {}),
                  if (sessions.length > 1) ...[
                    const SizedBox(height: 20),
                    LastSessionCard(title: sessions[1].name, onPressed: () {}),
                  ],
                ],
              ),

            SizedBox(height: 22),
            Heading(text: 'Upcoming events'),
            SizedBox(height: 22),
            UpcomingEventCard(
              title: 'Juwenalia 2025',
              date: 'May 9-10 2025',
              onPressed: () {},
            ),
            SizedBox(height: 20),
            UpcomingEventCard(
              title: 'Concert',
              date: 'May 31 2025',
              onPressed: () {},
            ),
            SizedBox(height: 20),
            UpcomingEventCard(
              title: 'Fountain show',
              date: 'June 20 2025',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
