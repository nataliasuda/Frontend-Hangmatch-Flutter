import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class TokenService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String baseUrl = 'http://10.0.2.2:8000';

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt');
    await _storage.delete(key: 'refresh_token');
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  Future<http.Response> authorizedGet(Uri url) async {
    String? token = await getToken();

    http.Response response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 401) {
      final newToken = await refreshAccessToken();
      if (newToken != null) {
        response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $newToken',
          },
        );
      }
    }

    return response;
  }

  Future<http.Response> authorizedPost(Uri url, {required Map<String, dynamic> body}) async {
    String? token = await getToken();

    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 401) {
      final newToken = await refreshAccessToken();
      if (newToken != null) {
        response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $newToken',
          },
          body: jsonEncode(body),
        );
      }
    }

    return response;
  }

  Future<http.Response> authorizedPut(Uri url, {required Map<String, dynamic> body}) async {
    String? token = await getToken();

    http.Response response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 401) {
      final newToken = await refreshAccessToken();
      if (newToken != null) {
        response = await http.put(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $newToken',
          },
          body: jsonEncode(body),
        );
      }
    }

    return response;
  }

  Future<String?> refreshAccessToken() async {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return null;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/refresh?refresh_token=$refreshToken'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['access_token'];
        final newRefreshToken = data['refresh_token'];

        if (newAccessToken != null) {
          await saveToken(newAccessToken);
        }
        if (newRefreshToken != null) {
          await saveRefreshToken(newRefreshToken);
        }

        return newAccessToken;
       } else {}

    return null;
  }

Future<http.Response> authorizedDelete(Uri url) async {
  String? token = await getToken();

  http.Response response = await http.delete(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 401) {
    final newToken = await refreshAccessToken();
    if (newToken != null) {
      response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $newToken',
        },
      );
    }
  }

  return response;
}
}