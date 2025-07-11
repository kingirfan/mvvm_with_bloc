import 'package:bloc_with_mvvm/core/app/app_widget.dart';
import 'package:bloc_with_mvvm/core/theme/app_theme.dart';
import 'package:bloc_with_mvvm/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:bloc_with_mvvm/feature/auth/presentation/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('uses AppTheme.lightTheme as theme', (tester) async {
    await tester.pumpWidget(const MyApp());

    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.theme, equals(AppTheme.lightTheme));
  });

  testWidgets('uses AppTheme.darkTheme as darkTheme', (tester) async {
    await tester.pumpWidget(const MyApp());

    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.darkTheme, equals(AppTheme.darkTheme));
  });

  testWidgets('has ThemeMode.system as themeMode', (tester) async {
    await tester.pumpWidget(const MyApp());

    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.themeMode, equals(ThemeMode.system));
  });
}
