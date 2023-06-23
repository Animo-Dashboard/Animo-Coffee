import 'package:animo/pages/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ContactPage displays contact information',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ContactPage()));

    // Verify that the contact information is displayed
    expect(find.text('Contact Information'), findsOneWidget);
    expect(find.text('Phone: +31 (0)592 - 376376'), findsOneWidget);
    expect(
        find.text('Email: info@animo.nl '), findsOneWidget); // Corrected line
    expect(find.text('Address: Dr. A.F. Philipsweg 47'), findsOneWidget);
  });

  testWidgets('ContactPage shows form when button is pressed',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ContactPage()));

    // Find and tap the button to show the form
    await tester.tap(find.text('If you wish to leave feedback, click this'));
    await tester.pump();

    // Verify that the form is displayed
    expect(find.text('Contact Form'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(5));
    expect(find.text('Submit'), findsOneWidget);
  });

  testWidgets('Submitting contact form shows success message',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ContactPage()));

    // Find and tap the button to show the form
    await tester.tap(find.text('If you wish to leave feedback, click this'));
    await tester.pump();

    // Enter values in the form fields
    await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'johndoe@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), '1234567890');
    await tester.enterText(find.byType(TextFormField).at(3), 'Subject');
    await tester.enterText(find.byType(TextFormField).at(4), 'Message');
    await tester.pump();

    // Scroll the Submit button into view
    await tester.ensureVisible(find.text('Submit'));

    // Tap the Submit button
    await tester.tap(find.text('Submit'));
    await tester.pump();

    // Wait for the success message to appear
    await tester.pumpAndSettle();

    // Verify that the success message dialog is displayed
    expect(find.text('Success'), findsOneWidget);
    expect(find.text('Message sent successfully!'), findsOneWidget);

    // Tap the OK button on the success message dialog
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Verify that the success message dialog is dismissed
    expect(find.text('Success'), findsNothing);
    expect(find.text('Message sent successfully!'), findsNothing);
  });
}
