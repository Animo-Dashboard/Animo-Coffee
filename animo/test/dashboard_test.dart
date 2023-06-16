import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';

// Import the file that contains the code you want to test
import 'package:animo/pages/dashboard_page.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  group('DashboardPage', () {
    late MockFirebaseFirestore mockFirestore;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
    });

    testWidgets('Displays "Nothing to display" when snapshot has no data',
        (WidgetTester tester) async {
      final mockCollectionReference = MockCollectionReference();
      when(mockFirestore.collection('Machines'))
          .thenReturn(mockCollectionReference);
      when(mockCollectionReference.get())
          // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
          .thenAnswer((_) async => MockQuerySnapshot([]));

      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardPage(),
        ),
      );

      expect(find.text('Nothing to display'), findsOneWidget);
    });

    testWidgets('Displays bar chart when "Current errors" is selected',
        (WidgetTester tester) async {
      final errorData = [
        {'Error': 'Error 1'},
        {'Error': 'Error 2'},
        {'Error': 'Error 1'},
        {'Error': 'Error 3'},
      ];

      final mockCollectionReference = MockCollectionReference();
      when(mockFirestore.collection('Machines'))
          .thenReturn(mockCollectionReference);
      when(mockCollectionReference.get())
          .thenAnswer((_) async => MockQuerySnapshot(errorData));

      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardPage(),
        ),
      );

      // Select 'Current errors' from the dropdown
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Current errors').last);
      await tester.pumpAndSettle();

      // Verify that the bar chart is displayed
      expect(find.byType(BarChart), findsOneWidget);
    });

    testWidgets('Displays pie chart when "Distribution of drinks" is selected',
        (WidgetTester tester) async {
      final drinkData = [
        {'CoffeeBrewed': 20, 'TeaBrewed': 15, 'HotChocolateBrewed': 10},
      ];

      final mockCollectionReference = MockCollectionReference();
      when(mockFirestore.collection('Machines'))
          .thenReturn(mockCollectionReference);
      when(mockCollectionReference.get())
          .thenAnswer((_) async => MockQuerySnapshot(drinkData));

      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardPage(),
        ),
      );

      // Select 'Distribution of drinks' from the dropdown
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Distribution of drinks').last);
      await tester.pumpAndSettle();

      // Verify that the pie chart is displayed
      expect(find.byType(PieChart), findsOneWidget);
    });
  });
}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {
  final List<Map<String, dynamic>> data;

  MockQuerySnapshot(this.data);

  @override
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get docs =>
      data.map((d) => MockQueryDocumentSnapshot(d)).toList();
}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {
  final Map<String, dynamic> documentData;

  MockQueryDocumentSnapshot(this.documentData);

  @override
  Map<String, dynamic> data() => documentData;
}
