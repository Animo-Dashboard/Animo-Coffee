import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:animo/pages/addNewDevice_page.dart';
import 'package:animo/pages/DeviceRegistrationPage.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('DeviceRegistrationPage', () {
    testWidgets('Next button should navigate to the next page',
        (WidgetTester tester) async {
      final page = DeviceRegistrationPage(
        deviceItem: DeviceItem(model: 'Optibean XL', name: 'Jeff'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: page,
        ),
      );

      // Initially, currentPageIndex is 0
      expect(find.text('Step 1:'), findsOneWidget);
      expect(find.text('Step 2:'), findsNothing);

      // Tap on the Next button
      await tester.tap(find.text('Next'));
      await tester.pump();

      // Verify that the currentPageIndex is updated to 1
      expect(find.text('Step 1:'), findsNothing);
      expect(find.text('Step 2:'), findsOneWidget);
    });

    testWidgets('Previous button should navigate to the previous page',
        (WidgetTester tester) async {
      final page = DeviceRegistrationPage(
        deviceItem: DeviceItem(model: 'Optibean XL', name: 'Steve'),
      );

      // Set the initial currentPageIndex to 1

      await tester.pumpWidget(
        MaterialApp(
          home: page,
        ),
      );

      await tester.tap(find.text('Next'));
      await tester.pump();

      // Initially, currentPageIndex is 1
      expect(find.text('Step 1:'), findsNothing);
      expect(find.text('Step 2:'), findsOneWidget);

      // Tap on the Previous button
      await tester.tap(find.text('Previous'));
      await tester.pump();

      // Verify that the currentPageIndex is updated to 0
      expect(find.text('Step 1:'), findsOneWidget);
      expect(find.text('Step 2:'), findsNothing);
    });

    testWidgets('Finish button should pop the page',
        (WidgetTester tester) async {
      final page = DeviceRegistrationPage(
        deviceItem: DeviceItem(model: 'Optibean XL', name: 'Ben'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: page,
        ),
      );

      // Tap the "Next" button until reaching the last page
      while (find.text('Finish').evaluate().isEmpty) {
        await tester.tap(find.text('Next'));
        await tester.pump();
      }

      // Tap on the Finish button
      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle();

      // Verify that the page is popped
      expect(find.byType(DeviceRegistrationPage), findsNothing);
    });

    group('InstallationStep', () {
      testWidgets('Widget should display step number and step text',
          (WidgetTester tester) async {
        const step = InstallationStep(
          stepText: 'Step text',
          stepNumber: 1,
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: step,
            ),
          ),
        );

        expect(find.text('Step 1:'), findsOneWidget);
        expect(find.text('Step text'), findsOneWidget);
      });
    });
  });
}
