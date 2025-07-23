import 'package:shared_preferences/shared_preferences.dart';

const _tokenKey = 'auth_token';
const _userId = 'user_id';

abstract class TokenStorage {
  Future<void> setToken(String token);

  Future<void> setUserId(String userId);

  Future<String?> getToken();

  Future<String?> getUserId();

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
  Future<void> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userId, userId);
  }

  @override
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userId);
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
