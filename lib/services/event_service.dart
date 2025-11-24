import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:hangmatch/services/token_service.dart';
import '../models/event.dart';

class EventService {
  final ticketmasterApiKey = dotenv.env['TICKETMASTER_API_KEY']!;
  final TokenService _tokenService = TokenService();
  final String baseUrl = 'http://10.0.2.2:8000';

  Future<void> sendVote(String sessionId, String eventId, String vote) async {
    final url = Uri.parse('$baseUrl/sessions/$sessionId/vote');

    final response = await _tokenService.authorizedPost(
      url,
      body: {"event_id": eventId, "vote": vote},
    );

    if (response.statusCode != 200) {
      print(response.body);
      throw Exception("Failed to send vote");
    }
  }

  Future<List<Event>> fetchEventsNearby({
    required double lat,
    required double lng,
    required double radiusKm,
  }) async {
    try {
      final url = Uri.parse(
        'https://app.ticketmaster.com/discovery/v2/events.json'
        '?apikey=$ticketmasterApiKey'
        '&latlong=$lat,$lng'
        '&radius=${radiusKm.toStringAsFixed(0)}'
        '&unit=km'
        '&size=50'
        '&sort=date,asc',
      );

      print('Fetching events from: $url');

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch events: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);

      if (data['_embedded'] == null || data['_embedded']['events'] == null) {
        print('No events found in this area');
        return [];
      }

      final events =
          (data['_embedded']['events'] as List)
              .map((e) => Event.fromTicketmaster(e))
              .toList();

      print('Found ${events.length} events near location $lat,$lng');
      return events;
    } catch (e) {
      print('Error fetching events from Ticketmaster: $e');
      rethrow;
    }
  }
}
