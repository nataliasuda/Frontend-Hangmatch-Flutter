import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hangmatch/screens/auth.dart';
import 'package:hangmatch/services/token_service.dart';
import 'package:hangmatch/widgets/modern_navigation_bar.dart';
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
          MaterialPageRoute(builder: (context) => const ModernNavigationBar()),
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

    try {
      final response = await _tokenService.authorizedGet(url);

      if (!context.mounted) return;

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _showSnackBar(context, 'Logged in: ${responseData['name']}', true);
      } else {
        _showSnackBar(context, responseData['detail'], false);
      }
    } catch (e) {
      _showSnackBar(context, 'An error occurred: $e', false);
    }
  }

  Future<void> updateProfile(BuildContext context, UserUpdate userUpdate) async {
    final url = Uri.parse('$baseUrl/users/me');

    try {
      final response = await _tokenService.authorizedPut(
        url,
        body: userUpdate.toJson(),
      );

      if (!context.mounted) return;

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _showSnackBar(context, 'Profile updated successfully', true);
      } else {
        final error = responseData['detail'];
        _showSnackBar(context, error.toString(), false);
      }
    } catch (e) {
      _showSnackBar(context, 'Network error: $e', false);
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final url = Uri.parse('$baseUrl/users/me');

    try {
      final response = await _tokenService.authorizedGet(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await _tokenService.deleteToken();

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
        (route) => false,
      );

      _showSnackBar(context, 'Logged out successfully', true);
    } catch (e) {
      if (!context.mounted) return;
      _showSnackBar(context, 'Logout error: $e', false);
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