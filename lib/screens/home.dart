import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hangmatch/widgets/heading.dart';
import 'package:hangmatch/widgets/home/last_session_card.dart';
import 'package:hangmatch/widgets/home/new_session_button.dart';
import 'package:hangmatch/widgets/home/upcoming_event_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            NewSessionButton(),

            Heading(text: 'Last session'),
            SizedBox(height: 22),
            LastSessionCard(title: 'My birthday', onPressed: () {}),
            SizedBox(height: 20),
            LastSessionCard(title: 'Zuzia\'s meeting', onPressed: () {}),
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
