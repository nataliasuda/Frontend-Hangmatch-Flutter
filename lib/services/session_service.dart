import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hangmatch/models/session.dart';
import 'package:hangmatch/services/token_service.dart';
import 'package:http/http.dart' as http;

class SessionService {
  final baseUrl = Uri.parse('http://10.0.2.2:8000');
  final storage = const FlutterSecureStorage();

  Future<void> session(BuildContext context, Session session) async {
    final url = Uri.parse('$baseUrl/sessions/');
    final token = await TokenService().getToken();

    if (token == null) {
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(session.toJson()),
      );
      if (!context.mounted) return;

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _showSnackBar(
          context,
          responseData['message'] ?? 'Sesja utworzona!',
          true,
        );
      } else {
        _showSnackBar(
          context,
          responseData['detail'] ?? 'Błąd tworzenia sesji',
          false,
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      _showSnackBar(context, 'Wystąpił błąd: $e', false);
    }
  }

  Future<List<Session>> getMySessions(BuildContext context) async {
    try {
      final url = Uri.parse('$baseUrl/sessions/me');
      final token = await TokenService().getToken();

      if (token == null) {
        return [];
      }

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
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

  void _showSnackBar(BuildContext context, String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: success ? Colors.green : Colors.red,
        content: Text(message),
      ),
    );
  }
}
