import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:animo/pages/contact_page.dart';
import 'package:animo/pages/MaintenanceSelection_page.dart';
import 'package:animo/pages/Mainenance%20Pages/usingTheRinsingProgram_page.dart';
import 'package:animo/pages/Mainenance Pages/cleaningProgram_page.dart';

// Mock class for NavigatorObserver
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('MaintenanceSelectionPage', () {
    testWidgets('Rinsing program button navigates to RinsingProgramPage',
        (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          home: MaintenanceSelectionPage(),
          navigatorObservers: [mockObserver],
        ),
      );

      await tester.tap(find.text('Using the rinsing program'));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(isA<PageRoute>() as Route, any)).called(1);
      expect(find.byType(RinsingProgramPage), findsOneWidget);
    });

    testWidgets('Cleaning program button navigates to CleaningProgramPage',
        (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          home: MaintenanceSelectionPage(),
          navigatorObservers: [mockObserver],
        ),
      );

      await tester.tap(find.text('Using the cleaning program'));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(isA<PageRoute>() as Route, any)).called(1);
      expect(find.byType(CleaningProgramPage), findsOneWidget);
    });

    // Add more tests for other buttons in a similar way
    // ...

    testWidgets('Contact button navigates to ContactPage',
        (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          home: MaintenanceSelectionPage(),
          navigatorObservers: [mockObserver],
        ),
      );

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Contact'));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(isA<PageRoute>() as Route, any)).called(1);
      expect(find.byType(ContactPage), findsOneWidget);
    });

    // Add more tests for other menu options in a similar way
    // ...
  });
}
