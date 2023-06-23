import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animo/pages/contact_page.dart';
import 'package:animo/pages/MaintenanceSelection_page.dart';
import 'package:animo/pages/Mainenance%20Pages/usingTheRinsingProgram_page.dart';
import 'package:animo/pages/Mainenance Pages/cleaningProgram_page.dart';

void main() {
  group('MaintenanceSelectionPage', () {
    testWidgets('Rinsing program button navigates to RinsingProgramPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MaintenanceSelectionPage(),
        ),
      );

      await tester.tap(find.text('Using the rinsing program'));
      await tester.pumpAndSettle();

      expect(find.byType(RinsingProgramPage), findsOneWidget);
    });

    testWidgets('Cleaning program button navigates to CleaningProgramPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MaintenanceSelectionPage(),
        ),
      );

      await tester.tap(find.text('Using the cleaning program'));
      await tester.pumpAndSettle();

      expect(find.byType(CleaningProgramPage), findsOneWidget);
    });

    testWidgets('Contact button navigates to ContactPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MaintenanceSelectionPage(),
        ),
      );

      await tester.tap(find.byIcon(Icons.more_horiz_sharp));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Contact'));
      await tester.pumpAndSettle();

      expect(find.byType(ContactPage), findsOneWidget);
    });
  });
}
