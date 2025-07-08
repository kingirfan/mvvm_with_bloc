import 'package:shared_preferences/shared_preferences.dart';

const _tokenKey = 'auth_token';

abstract class TokenStorage {
  Future<void> setToken(String token);

  Future<String?> getToken();

  Future<void> clear();
}

class TokenStorageImpl implements TokenStorage {
  @override
  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
