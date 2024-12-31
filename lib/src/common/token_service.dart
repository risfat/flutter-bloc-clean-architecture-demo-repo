import 'dart:async';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';
import 'constants.dart';

class TokenService {
  final Dio dio;
  String? _accessToken;
  String? _refreshToken;
  DateTime? _expiryTime;

  TokenService(this.dio);

  Future<void> setTokens(
      String accessToken, String refreshToken, int expiresIn) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _expiryTime = DateTime.now().add(Duration(seconds: expiresIn));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ACCESS_TOKEN, accessToken);
    await prefs.setString(REFRESH_TOKEN, refreshToken);
    await prefs.setInt(TOKEN_EXPIRY, _expiryTime!.millisecondsSinceEpoch);
  }

  Future<String?> getAccessToken() async {
    if (_accessToken == null || _expiryTime == null) {
      await _loadTokensFromStorage();
    }

    if (_expiryTime != null && _expiryTime!.isBefore(DateTime.now())) {
      await refreshToken();
    }

    return _accessToken;
  }

  Future<void> _loadTokensFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString(ACCESS_TOKEN);
    _refreshToken = prefs.getString(REFRESH_TOKEN);
    final expiryTimestamp = prefs.getInt(TOKEN_EXPIRY);
    if (expiryTimestamp != null) {
      _expiryTime = DateTime.fromMillisecondsSinceEpoch(expiryTimestamp);
    }
  }

  Future<void> refreshToken() async {
    try {
      final response = await dio.post(
        API.REFRESH_TOKEN,
        data: {
          'token': _accessToken,
          'refreshToken': _refreshToken,
        },
      );

      final newAccessToken = response.data['accessToken'];
      final newRefreshToken = response.data['refreshToken'];
      final expiresIn = response.data['expiresIn'];

      await setTokens(newAccessToken, newRefreshToken, expiresIn);
    } catch (e) {
      // If refresh fails, clear tokens and throw an error
      await clearTokens();
      throw Exception('Token refresh failed');
    }
  }

  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    _expiryTime = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ACCESS_TOKEN);
    await prefs.remove(REFRESH_TOKEN);
    await prefs.remove(TOKEN_EXPIRY);
  }
}
