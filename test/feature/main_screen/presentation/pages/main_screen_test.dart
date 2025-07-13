/*
import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_with_mvvm/feature/main_screen/presentation/bloc/bottom_bloc.dart';
import 'package:bloc_with_mvvm/feature/main_screen/presentation/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockBottomNavBloc extends Mock implements BottomNavBloc {}

void main() {
  late BottomNavBloc bottomNavBloc;

  setUp(() {
    bottomNavBloc = MockBottomNavBloc();
    registerFallbackValue(BottomNavEvent.home);
    registerFallbackValue(BottomNavEvent.category);
    registerFallbackValue(BottomNavEvent.favorite);
    registerFallbackValue(BottomNavEvent.settings);

    when(() => bottomNavBloc.stream)
        .thenAnswer((_) => Stream<int>.fromIterable([bottomNavBloc.state]));
  });

  tearDown(() async {
    when(() => bottomNavBloc.close()).thenAnswer((_) async {});
    await bottomNavBloc.close();
  });

  void stubBlocState(int index) {
    when(() => bottomNavBloc.state).thenReturn(index);
    when(() => bottomNavBloc.stream)
        .thenAnswer((_) => Stream<int>.fromIterable([index]));
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MainScreen(bloc: bottomNavBloc),
    );
  }


  testWidgets('shows HomeScreen when selectedIndex is 0', (tester) async {
    stubBlocState(0);
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Home'), findsOneWidget); // HomeScreen content
  });

  testWidgets('shows CategoryScreen when selectedIndex is 1', (tester) async {
    when(() => bottomNavBloc.state).thenReturn(1);
    whenListen(bottomNavBloc, Stream<int>.fromIterable([1]));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Category'), findsOneWidget); // CategoryScreen content
  });

  testWidgets('shows FavoriteScreen when selectedIndex is 2', (tester) async {
    when(() => bottomNavBloc.state).thenReturn(2);
    whenListen(bottomNavBloc, Stream<int>.fromIterable([2]));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Favorite'), findsOneWidget); // FavoriteScreen content
  });

  testWidgets('shows FavoriteScreen when selectedIndex is 3', (tester) async {
    when(() => bottomNavBloc.state).thenReturn(3);
    whenListen(bottomNavBloc, Stream<int>.fromIterable([2]));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Favorite'), findsOneWidget); // FavoriteScreen content
  });

  testWidgets('dispatches BottomNavEvent.category when Category tab is tapped', (tester) async {
    when(() => bottomNavBloc.state).thenReturn(0);
    when(() => bottomNavBloc.add(any())).thenReturn(null); // mock .add

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Category')); // tap label
    await tester.pump();

    verify(() => bottomNavBloc.add(BottomNavEvent.category)).called(1); // ✅ success
  });
}
*/


import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_with_mvvm/feature/main_screen/presentation/bloc/bottom_bloc.dart';
import 'package:bloc_with_mvvm/feature/main_screen/presentation/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockBottomNavBloc extends Mock implements BottomNavBloc {}

void main() {
  late MockBottomNavBloc bottomNavBloc;

  setUp(() {
    bottomNavBloc = MockBottomNavBloc();

    when(() => bottomNavBloc.close()).thenAnswer((_) async {});

    // Register enum fallbacks for mocktail
    registerFallbackValue(BottomNavEvent.home);
    registerFallbackValue(BottomNavEvent.category);
    registerFallbackValue(BottomNavEvent.favorite);
    registerFallbackValue(BottomNavEvent.settings);
  });

  tearDown(() async {
    when(() => bottomNavBloc.close()).thenAnswer((_) async {});
    await bottomNavBloc.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MainScreen(bloc: bottomNavBloc),
    );
  }

  void stubBlocState(int index) {
    when(() => bottomNavBloc.state).thenReturn(index);
    when(() => bottomNavBloc.stream)
        .thenAnswer((_) => Stream<int>.fromIterable([index]));
  }

  testWidgets('shows HomeScreen when selectedIndex is 0', (tester) async {
    stubBlocState(0);

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Home'), findsOneWidget); // adjust to match HomeScreen content
  });

  testWidgets('shows CategoryScreen when selectedIndex is 1', (tester) async {
    stubBlocState(1);

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Category'), findsOneWidget); // adjust to match CategoryScreen content
  });

  testWidgets('shows FavoriteScreen when selectedIndex is 2', (tester) async {
    stubBlocState(2);

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Favorite'), findsOneWidget); // adjust to match FavoriteScreen content
  });

  testWidgets('shows SettingsScreen when selectedIndex is 3', (tester) async {
    stubBlocState(3);

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Settings'), findsOneWidget); // adjust to match SettingsScreen content
  });

  testWidgets('dispatches BottomNavEvent.category when Category tab is tapped', (tester) async {
    stubBlocState(0);
    when(() => bottomNavBloc.add(any())).thenReturn(null);

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Category')); // Tap label
    await tester.pump();

    verify(() => bottomNavBloc.add(BottomNavEvent.category)).called(1);
  });

  testWidgets('shows all BottomNavigationBar labels', (tester) async {
    stubBlocState(0);

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Category'), findsOneWidget);
    expect(find.text('Favorite'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
