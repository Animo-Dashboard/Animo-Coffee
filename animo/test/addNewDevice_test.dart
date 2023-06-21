import 'package:animo/pages/deviceInstallationPage%20.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animo/pages/addNewDevice_page.dart';

void main() {
  group('AddNewDevicePage', () {
    testWidgets('Adding a new device', (WidgetTester tester) async {
      // Build the AddNewDevicePage widget
      await tester.pumpWidget(const MaterialApp(home: AddNewDevicePage()));

      // Verify that there are no devices initially
      expect(find.byType(ListTile), findsNothing);

      // Tap the floating action button to add a new device
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      // Verify that a new device is added
      expect(find.byType(ListTile), findsOneWidget);
    });

    testWidgets('Viewing installation guide', (WidgetTester tester) async {
      // Create a mock device item

      // Build the AddNewDevicePage widget with the mock device item
      await tester.pumpWidget(const MaterialApp(home: AddNewDevicePage()));

      // Verify that there are no devices initially
      expect(find.byType(ListTile), findsNothing);

      // Tap the floating action button to add a new device
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      // Verify that a new device is added
      expect(find.byType(ListTile), findsOneWidget);

      // Tap the device item to view the installation guide
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // Verify that the DeviceInstallationPage is pushed to the navigator
      expect(find.byType(DeviceInstallationPage), findsOneWidget);
    });
  });
}
