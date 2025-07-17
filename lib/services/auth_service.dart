import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hangmatch/screens/home.dart';
import 'package:hangmatch/services/token_service.dart';
import 'package:hangmatch/models/user.dart';

class UserService {
  final baseUrl = Uri.parse('http://10.0.2.2:8000');
  final TokenService _tokenService = TokenService();

  Future<void> register(BuildContext context, Register register) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      final response = await _tokenService.authorizedPost(
        url,
        body: register.toJson(),
      );

      if (!context.mounted) return;

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _showSnackBar(context, responseData['message'], true);
      } else {
        _showSnackBar(context, responseData['detail'], false);
      }
    } catch (e) {
      _showSnackBar(context, 'An error occurred: $e', false);
    }
  }

  Future<void> login(BuildContext context, Login login) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await _tokenService.authorizedPost(
        url,
        body: login.toJson(),
      );

      if (!context.mounted) return;

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final accessToken = responseData['access_token'];
        final refreshToken = responseData['refresh_token'];

        if (accessToken != null) {
          await _tokenService.saveToken(accessToken);
        }
        if (refreshToken != null) {
          await _tokenService.saveRefreshToken(refreshToken);
        }
        if (!context.mounted) return;

        await getCurrentUser(context);

        if (!context.mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        _showSnackBar(context, responseData['detail'], false);
      }
    } catch (e) {
      _showSnackBar(context, 'An error occurred: $e', false);
    }
  }

  Future<void> getCurrentUser(BuildContext context) async {
    final url = Uri.parse('$baseUrl/users/me');

    final response = await _tokenService.authorizedGet(url);

    if (!context.mounted) return;

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _showSnackBar(context, 'Zalogowano jako: ${responseData['name']}', true);
    } else {
      _showSnackBar(context, responseData['detail'], false);
    }
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
