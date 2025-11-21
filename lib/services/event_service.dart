import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/event.dart';

class EventService {
  final ticketmasterApiKey = dotenv.env['TICKETMASTER_API_KEY']!;

  Future<List<Event>> fetchEvents(String city) async {
    final url = Uri.parse(
      'https://app.ticketmaster.com/discovery/v2/events.json?apikey=$ticketmasterApiKey&city=$city',
    );

    final response = await http.get(url);
    final data = jsonDecode(response.body);
    final events =
        (data['_embedded']['events'] as List)
            .map((e) => Event.fromTicketmaster(e))
            .toList();
    return events;
  }
}
