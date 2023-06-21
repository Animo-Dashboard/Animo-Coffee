import 'package:animo/pages/admin_page.dart';
import 'package:animo/pages/calciumLevels_page.dart';
import 'package:animo/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MaintenanceSelectionPage', () {
    testWidgets('AdminPage shows buttons for admin user',
        (WidgetTester tester) async {
      final adminPage = AdminPage();

      await tester.pumpWidget(MaterialApp(home: adminPage));

      expect(find.text('DASHBOARD'), findsNothing);
      expect(find.text('MACHINE PAGE'), findsNothing);
      expect(find.text('ZIP SEARCH'), findsNothing);

      await tester.pumpAndSettle();

      expect(find.text('DASHBOARD'), findsOneWidget);
      expect(find.text('MACHINE PAGE'), findsOneWidget);
      expect(find.text('ZIP SEARCH'), findsOneWidget);
    });

    testWidgets('Dashboard button navigates to DashboardPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AdminPage(),
        routes: {
          '/dashboard': (context) => DashboardPage(),
        },
      ));

      // Wait for the 'DASHBOARD' button to appear
      await tester.pumpAndSettle();

      // Find and tap the 'DASHBOARD' button
      await tester.tap(find.text('DASHBOARD'));
      await tester.pumpAndSettle();

      // Verify that the app navigated to the DashboardPage
      expect(find.byType(DashboardPage), findsOneWidget);
    });

    testWidgets('ZIP SEARCH button navigates to ZipSearchPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AdminPage(),
        routes: {
          '/api': (context) => ZipCodeSearchPage(),
        },
      ));

      // Wait for the 'ZIP SEARCH' button to appear
      await tester.pumpAndSettle();

      // Find and tap the 'ZIP SEARCH' button
      await tester.tap(find.text('ZIP SEARCH'));
      await tester.pumpAndSettle();

      // Verify that the app navigated to the ZipSearchPage
      expect(find.byType(ZipCodeSearchPage), findsOneWidget);
    });
  });
}
