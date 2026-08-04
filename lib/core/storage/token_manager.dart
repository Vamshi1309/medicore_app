import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  TokenManager._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';

  static const String _refreshTokenKey = 'refresh_token';

  // save token to secure storage
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  // get access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // get refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // Clear tokens during logout
  static Future<void> clearTokens() async {
    debugPrint("+++++++++++++ Tokens Cleared ++++++++++++++++++++++");
    await _storage.delete(key: _accessTokenKey);

    await _storage.delete(key: _refreshTokenKey);
  }
}
