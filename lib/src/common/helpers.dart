import 'dart:convert';

class Helpers {
  static int getExpirationFromJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = json
        .decode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));

    if (payload['exp'] == null) {
      throw Exception('Token does not contain expiration');
    }

    final expirationTimestamp = payload['exp'] as int;
    final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return expirationTimestamp - currentTimestamp;
  }
}
