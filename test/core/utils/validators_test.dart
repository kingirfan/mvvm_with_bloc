import 'package:bloc_with_mvvm/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Email Validator - ', () {
    test('return error if email is empty', () {
      final result = Validators.validateEmail("");
      expect(result, 'Email is required');
    });

    test('Returns enter valid email', () {
      final result = Validators.validateEmail('invalid');
      expect(result, 'Enter a valid email');
    });

    test('Returns null, if entered proper email', () {
      final result = Validators.validateEmail('irfan@gmail.com');
      expect(result, null);
    });

    group('Password Validator - ', () {
      test('returns error if password is short', () {
        final result = Validators.validatePassword('');
        expect(result, 'Password must be at least 3 characters');
      });

      test('returns null for valid password', () {
        final result = Validators.validatePassword('Irfan@123');
        expect(result, null);
      });
    });

    group('Validate Field -', () {
      test('Return Error if field is Empty', () {
        final result = Validators.validateField('', 'fieldName');
        expect(result, 'fieldName is required');
      });

      test('Returns null, if proper field is entered', () {
        final result =  Validators.validateField('Irfan', 'fieldName');
        expect(result, null);
      });
    });
  });
}
