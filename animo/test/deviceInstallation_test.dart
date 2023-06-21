import 'package:animo/pages/deviceInstallationPage%20.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:animo/pages/addNewDevice_page.dart';

void main() {
  group('DeviceInstallationPage', () {
    // Test cases for DeviceInstallationPage

    testWidgets('Next button should navigate to the next page',
        (WidgetTester tester) async {
      final page = DeviceInstallationPage(
        deviceItem: DeviceItem(model: 'Optibean XL', name: 'Jeff'),
        markStep5Completed: (deviceItem) {},
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
  });
}
