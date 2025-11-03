import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hangmatch/services/token_service.dart';
import 'package:hangmatch/widgets/modern_navigation_bar.dart';
import 'package:http/http.dart' as http;
import 'package:hangmatch/models/user.dart';

class UserService {
  final baseUrl = Uri.parse('http://10.0.2.2:8000');

  Future<void> register(BuildContext context, Register register) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': register.name,
          'email': register.email,
          'password': register.password,
          'repeated_password': register.repeatPassword,
        }),
      );
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
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': login.email, 'password': login.password}),
      );
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final token = responseData['access_token'];

        if (token != null) {
          await TokenService().saveToken(token);
          await getCurrentUser(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ModernNavigationBar()),
          );
        }
      } else {
        _showSnackBar(context, responseData['detail'], false);
      }
    } catch (e) {
      _showSnackBar(context, 'An error occurred: $e', false);
    }
  }

  Future<void> getCurrentUser(BuildContext context) async {
    final token = await TokenService().getToken();

    if (token == null) {
      return;
    }

    final url = Uri.parse('$baseUrl/users/me');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _showSnackBar(context, 'message: ${responseData['name']}', true);
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
