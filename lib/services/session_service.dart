import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hangmatch/models/session.dart';
import 'package:hangmatch/screens/searching_location.dart';
import 'package:hangmatch/services/token_service.dart';

class SessionService {
  final baseUrl = Uri.parse('http://10.0.2.2:8000');
  final TokenService _tokenService = TokenService();

  Future<Session> createDraftSession({
    required String name,
    required int locationRadius,
  }) async {
    final url = Uri.parse('$baseUrl/sessions');

    try {
      final response = await _tokenService.authorizedPost(
        url,
        body: {
          'name': name,
          'location_radius': locationRadius,
          'invited_users_ids': [],
        },
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Session.fromJson(responseData);
      } else {
        throw Exception(responseData['detail'] ?? 'Error creating session');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> inviteToSession({
    required BuildContext context,
    required String sessionId,
    required List<String> friendEmails,
  }) async {
    final url = Uri.parse('$baseUrl/sessions/invite/$sessionId');

    try {
      final response = await _tokenService.authorizedPost(
        url,
        body: {'emails': friendEmails},
      );

      if (!context.mounted) return;

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _showSnackBar(
          context,
          'Invitations sent to ${friendEmails.length} friend(s)',
          true,
        );
      } else {
        _showSnackBar(
          context,
          responseData['detail'] ?? 'Error sending invitations',
          false,
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      _showSnackBar(context, 'Network error: $e', false);
    }
  }

  Future<void> activateSession(BuildContext context, String sessionId) async {
    final url = Uri.parse('$baseUrl/sessions/activate/$sessionId');

    try {
      final response = await _tokenService.authorizedPost(url, body: {});

      if (!context.mounted) return;

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _showSnackBar(context, 'Session activated!', true);
        final locationRadius =
            responseData['location_radius']?.toDouble() ?? 5.0;

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => SearchingLocation(
                    sessionId: sessionId,
                    locationRadius: locationRadius,
                  ),
            ),
          );
        }
      } else {
        _showSnackBar(
          context,
          responseData['detail'] ?? 'Error activating session',
          false,
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      _showSnackBar(context, 'Network error: $e', false);
    }
  }

  Future<List<Session>> getMySessions(BuildContext context) async {
    final url = Uri.parse('$baseUrl/sessions/me');

    try {
      final response = await _tokenService.authorizedGet(url);

      if (!context.mounted) return [];

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData is List) {
          return responseData.map((json) => Session.fromJson(json)).toList();
        } else {
          _showSnackBar(context, 'Incorrect data format', false);
          return [];
        }
      } else {
        _showSnackBar(
          context,
          responseData['detail'] ?? 'Error downloading sessions',
          false,
        );
        return [];
      }
    } catch (e) {
      _showSnackBar(context, 'Wystąpił błąd: $e', false);
      return [];
    }
  }

  Future<void> joinSession(BuildContext context, String sessionId) async {
    final url = Uri.parse('$baseUrl/sessions/join/$sessionId');
    try {
      final response = await _tokenService.authorizedPost(url, body: {});

      if (!context.mounted) return;

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _showSnackBar(context, data['detail'] ?? 'Joined session', true);
      } else {
        _showSnackBar(
          context,
          data['detail'] ?? 'Failed to join session',
          false,
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      _showSnackBar(context, 'Error: $e', false);
    }
  }

  Future<void> rejectSession(BuildContext context, String sessionId) async {
    final url = Uri.parse('$baseUrl/sessions/reject/$sessionId');
    try {
      final response = await _tokenService.authorizedPost(url, body: {});

      if (!context.mounted) return;

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _showSnackBar(context, data['message'] ?? 'Rejected session', true);
      } else {
        _showSnackBar(
          context,
          data['detail'] ?? 'Failed to reject session',
          false,
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      _showSnackBar(context, 'Error: $e', false);
    }
  }

  Future<List<dynamic>> getMyInvitations(BuildContext context) async {
    final url = Uri.parse('$baseUrl/invitations/me');

    try {
      final response = await _tokenService.authorizedGet(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  void _showSnackBar(BuildContext context, String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: success ? Colors.green : Colors.red,
        content: Text(message),
      ),
    );
  }
}
