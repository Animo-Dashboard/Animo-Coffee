import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animo/pages/addNewDevice_page.dart';

void main() {
  testWidgets('AddNewDevicePage - Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: AddNewDevicePage(),
    ));

    // Verify the initial state
    expect(find.text('Add new device'), findsOneWidget);
    expect(find.byIcon(Icons.plus_one), findsOneWidget);

    // Tap on the FloatingActionButton to add a new device
    await tester.tap(find.byIcon(Icons.plus_one));
    await tester.pump();

    // Verify that the new device is added
    expect(find.byType(ListTile), findsOneWidget);

    // Tap on the added device to view the installation guide
    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();

    // Verify that the installation guide page is displayed
    expect(find.text('Installation Guide'), findsOneWidget);

    // Tap on the Next button to navigate to the next step
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Verify that the current step is updated
    expect(find.text('Step 1:'), findsNothing);
    expect(find.text('Step 2:'), findsOneWidget);

    // Tap on the Next button again
    // Tap on the device again to view the registration guide
  });

  testWidgets('AddNewDevicePage - Add Multiple Devices',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: AddNewDevicePage(),
    ));

    // Verify the initial state
    expect(find.byType(ListTile), findsNothing);

    // Tap on the FloatingActionButton to add the first device
    await tester.tap(find.byIcon(Icons.plus_one));
    await tester.pump();

    // Verify that the first device is added
    expect(find.byType(ListTile), findsOneWidget);

    // Tap on the FloatingActionButton to add the second device
    await tester.tap(find.byIcon(Icons.plus_one));
    await tester.pump();

    // Verify that the second device is added
    expect(find.byType(ListTile), findsNWidgets(2));
  });

  testWidgets('AddNewDevicePage - Tap Installed Device',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: AddNewDevicePage(),
    ));

    // Verify the initial state
    expect(find.byType(ListTile), findsNothing);

    // Tap on the FloatingActionButton to add a new device
    await tester.tap(find.byIcon(Icons.plus_one));
    await tester.pump();

    // Verify that the new device is added
    expect(find.byType(ListTile), findsOneWidget);

    // Tap on the added device (installed) to view the registration guide
    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();
  });
}
