import 'package:flutter_test/flutter_test.dart';
import 'package:animo/pages/login_page.dart';

void main() {
  testWidgets('Registration and Forgot Password Links Test',
      (WidgetTester tester) async {
    // Build the LoginPage widget
    await tester.pumpWidget(LoginPage());

    // Tap on the registration link
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    // Verify that the registration page is navigated to
    expect(find.text('Registration Page'), findsOneWidget);

    // Go back to the login page
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    // Tap on the forgot password link
    await tester.tap(find.text('Forgot Password?'));
    await tester.pumpAndSettle();

    // Verify that the forgot password page is navigated to
    expect(find.text('Forgot Password Page'), findsOneWidget);
  });
}
