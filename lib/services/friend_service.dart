import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hangmatch/models/friend.dart';
import 'package:hangmatch/models/friend_request.dart';
import 'package:hangmatch/services/token_service.dart';

class FriendService {
  final baseUrl = Uri.parse('http://10.0.2.2:8000');
  final TokenService _tokenService = TokenService();

  Future<List<Friend>> searchFriends(String query) async {
    final url = Uri.parse('$baseUrl/friends/search?query=$query');

    try {
      final response = await _tokenService.authorizedGet(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData
            .map((userJson) => Friend.fromJson(userJson))
            .toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Error during search');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> inviteFriend(BuildContext context, String email) async {
    final url = Uri.parse('$baseUrl/invite');

    try {
      final response = await _tokenService.authorizedPost(
        url,
        body: {'receiver_email': email},
      );

      if (!context.mounted) return;

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _showSnackBar(context, responseData['message'] ?? 'Invite sent', true);
      }
    } catch (e) {
      print('Error in inviteFriend: $e');
      if (!context.mounted) return;
      _showSnackBar(context, 'Network error: ${e.toString()}', false);
    }
  }

  Future<void> respondToRequest(
    BuildContext context,
    String requestId,
    bool accept,
  ) async {
    final url = Uri.parse('$baseUrl/friends/respond/$requestId');

    try {
      final response = await _tokenService.authorizedPost(
        url,
        body: {'accept': accept},
      );

      if (!context.mounted) return;

      if (response.statusCode == 200) {
        _showSnackBar(
          context,
          accept ? 'Friend request accepted' : 'Friend request rejected',
          true,
        );
      }
    } catch (e) {
      print('Error in respondToRequest: $e');
      if (!context.mounted) return;
      _showSnackBar(context, 'Error: ${e.toString()}', false);
    }
  }

  Future<List<FriendRequest>> getMyRequests() async {
    final url = Uri.parse('$baseUrl/friends/requests');

    try {
      final response = await _tokenService.authorizedGet(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData
            .map((json) => FriendRequest.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Failed to load friend requests: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error in getMyRequests: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<List<Friend>> getFriends() async {
    final url = Uri.parse('$baseUrl/friends');

    try {
      final response = await _tokenService.authorizedGet(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((json) => Friend.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load friends: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getFriends: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<void> removeFriend(BuildContext context, String friendId) async {
    final url = Uri.parse('$baseUrl/friends/remove/$friendId');

    try {
      final response = await _tokenService.authorizedDelete(url);

      if (!context.mounted) return;

      if (response.statusCode == 200) {
        _showSnackBar(context, 'Friend removed successfully', true);
      }
    } catch (e) {
      print('Error in removeFriend: $e');
      if (!context.mounted) return;
      _showSnackBar(context, 'Error: ${e.toString()}', false);
    }
  }

  void _showSnackBar(BuildContext context, String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: success ? Colors.green : Colors.red,
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
