import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hangmatch/models/friend.dart';
import 'package:hangmatch/models/friend_request.dart';
import 'package:hangmatch/services/token_service.dart';
import 'package:http/http.dart' as http;

final baseUrl = Uri.parse('http://10.0.2.2:8000');

class FriendService {
  Future<List<Friend>> searchFriends(String query) async {
    final url = Uri.http('10.0.2.2:8000', '/friends/search', {'query': query});
    final token = await TokenService().getToken();

    if (token == null) {}

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((userJson) => Friend.fromJson(userJson)).toList();
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['detail'] ?? 'Błąd podczas wyszukiwania');
    }
  }

  Future<void> inviteFriend(BuildContext context, String email) async {
    final url = Uri.parse('$baseUrl/invite');
    final token = await TokenService().getToken();
    if (token == null) {
      return;
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'receiver_email': email}),
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _showSnackBar(context, responseData['message'], true);
    } else {
      _showSnackBar(context, responseData['detail'], false);
    }
  }
}

Future<void> respondToFriend(
  BuildContext context,
  int requestId,
  bool accept,
) async {
  final url = Uri.parse('$baseUrl/friends/respond/$requestId');
  final token = await TokenService().getToken();
  if (token == null) {
    return;
  }

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({'accept': accept}),
  );

  final responseData = jsonDecode(response.body);
  if (response.statusCode == 200) {
    _showSnackBar(context, responseData['message'], true);
  } else {
    _showSnackBar(context, responseData['detail'], false);
  }
}

Future<List<FriendRequest>> getMyRequests() async {
  final url = Uri.parse('$baseUrl/friends/requests');
  final token = await TokenService().getToken();
  if (token == null) {
    return [];
  }

  final response = await http.get(
    url,
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 200) {
    final List<dynamic> responseData = jsonDecode(response.body);
    return responseData.map((json) => FriendRequest.fromJson(json)).toList();
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['detail'] ?? 'Unable to download invitations');
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
