import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:animo/pages/machineSpecs_page.dart';

void main() {
  setUpAll(() async {
    await Firebase.initializeApp();
  });
  testWidgets('MachineSpecsPage - Retrieve Specs', (WidgetTester tester) async {
    // Pump the widget tree and wait for the app to load

    await tester.pumpWidget(MaterialApp(home: MachineSpecsPage()));

    // Verify the initial state of the page
    expect(find.text('Machine Specifications Page'), findsOneWidget);
    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(2));
    expect(find.byType(ExpansionTile), findsNothing);

    // Tap the "Retrieve Specs" button
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();

    // Verify that the expansion tiles are displayed
    expect(find.byType(ExpansionTile), findsWidgets);

    // Tap the "Can't find the machine you are looking for?" option
    await tester.tap(find.text("Can't find the machine you are looking for?"));
    await tester.pumpAndSettle();

    // Verify the UI after selecting the custom model option
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);

    // Enter a custom model name and tap the "Confirm" button
    await tester.enterText(find.byType(TextField), 'Custom Model');
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    // Verify the UI after confirming the custom model
    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(2));

    // Tap the "Retrieve Specs" button again
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();

    // Verify that the expansion tiles are displayed again
    expect(find.byType(ExpansionTile), findsWidgets);

    // Verify the "No specifications found" text is not present
    expect(find.text('No specifications found'), findsNothing);
  });
}
