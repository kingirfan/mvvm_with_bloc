import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloc_with_mvvm/core/utils/token_storage.dart';

void main() {
  late TokenStorage tokenStorage;

  setUp(() {
    SharedPreferences.setMockInitialValues({}); // Reset mock prefs
    tokenStorage = TokenStorageImpl();
  });

  test('should store token using SharedPreferences', () async {
    const token = 'sample_token';

    await tokenStorage.setToken(token);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('auth_token'), token);
  });

  test('should retrieve token from SharedPreferences', () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', 'my_token');

    final token = await tokenStorage.getToken();
    expect(token, 'my_token');
  });

  test('should clear token from SharedPreferences', () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', 'my_token');

    await tokenStorage.clear();

    expect(prefs.getString('auth_token'), isNull);
  });

  // test('should save and retrieve token', () async {
  //   const testToken = 'dummy_token';
  //
  //   await tokenStorage.setToken(testToken);
  //   final result = await tokenStorage.getToken();
  //
  //   expect(result, testToken);
  // });
  //
  // test('should clear token', () async {
  //   const testToken = 'dummy_token';
  //
  //   await tokenStorage.setToken(testToken);
  //   await tokenStorage.clear();
  //   final result = await tokenStorage.getToken();
  //
  //   expect(result, isNull);
  // });
}
