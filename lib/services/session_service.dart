import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hangmatch/models/session.dart';
import 'package:hangmatch/services/token_service.dart';

class SessionService {
  final baseUrl = Uri.parse('http://10.0.2.2:8000');
  final TokenService _tokenService = TokenService();

  Future<void> createSession(BuildContext context, Session session) async {
    final url = Uri.parse('$baseUrl/sessions');

    try {
      final response = await _tokenService.authorizedPost(
        url,
        body: session.toJson(),
      );

      if (!context.mounted) return;

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _showSnackBar(
          context,
          responseData['message'] ?? 'Session created!',
          true,
        );
      } else {
        _showSnackBar(
          context,
          responseData['detail'] ?? 'Error creating session',
          false,
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      _showSnackBar(context, 'An error occurred: $e', false);
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
          _showSnackBar(context, 'Niepoprawny format danych.', false);
          return [];
        }
      } else {
        _showSnackBar(
          context,
          responseData['detail'] ?? 'Błąd pobierania sesji',
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
      _showSnackBar(context, data['detail'] ?? 'Failed to join session', false);
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
      _showSnackBar(context, data['detail'] ?? 'Failed to reject session', false);
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
