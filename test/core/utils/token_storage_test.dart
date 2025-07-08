import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloc_with_mvvm/core/utils/token_storage.dart';

void main() {
  late TokenStorage tokenStorage;

  setUp(() {
    SharedPreferences.setMockInitialValues({}); // Reset mock prefs
    tokenStorage = TokenStorageImpl();
  });

  test('should save and retrieve token', () async {
    const testToken = 'dummy_token';

    await tokenStorage.setToken(testToken);
    final result = await tokenStorage.getToken();

    expect(result, testToken);
  });

  test('should clear token', () async {
    const testToken = 'dummy_token';

    await tokenStorage.setToken(testToken);
    await tokenStorage.clear();
    final result = await tokenStorage.getToken();

    expect(result, isNull);
  });
}
