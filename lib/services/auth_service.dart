import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hangmatch/models/user.dart';

class UserService {
  Future<void> register(BuildContext context, Register register) async {
    final url = Uri.parse('http://10.0.2.2:8000/register');

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
}
