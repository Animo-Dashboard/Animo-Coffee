import 'package:animo/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  group('DashboardPage', () {
    late DashboardPage dashboardPage;

    setUp(() {
      dashboardPage = DashboardPage();
    });

    testWidgets('displays "Nothing to display" when there is no data',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: dashboardPage));
      await tester.pumpAndSettle();

      expect(find.text('Nothing to display'), findsOneWidget);
      expect(find.byType(BarChart), findsNothing);
      expect(find.byType(PieChart), findsNothing);
    });
  });
}
