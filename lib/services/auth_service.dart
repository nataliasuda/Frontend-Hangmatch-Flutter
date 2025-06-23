import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hangmatch/services/token_service.dart';
import 'package:http/http.dart' as http;
import 'package:hangmatch/models/user.dart';

class UserService {
  final baseUrl = Uri.parse('http://10.0.2.2:8000');

  Future<void> register(BuildContext context, Register register) async {
    final url = Uri.parse('$baseUrl/register');

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
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<void> login(BuildContext context, Login login) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': login.email, 'password': login.password}),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];

      if (token != null) {
        await TokenService().saveToken(token);
      }
    }
  }
}
