import 'package:animo/pages/registration_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock FirebaseAuth
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// Mock FirebaseFirestore
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

// Mock CollectionReference
class MockCollectionReference extends Mock implements CollectionReference {}

// Mock DocumentReference
class MockDocumentReference extends Mock implements DocumentReference {}

// Mock UserCredential
class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late RegistrationPage registrationPage;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockCollectionReference mockCollectionReference;
  late MockDocumentReference mockDocumentReference;

  setUp(() {
    registrationPage = RegistrationPage();

    // Initialize mock objects
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();

    // Provide mock dependencies
    registrationPage.firebaseAuth = mockFirebaseAuth;
    registrationPage.firestore = mockFirebaseFirestore;

    // Mock Firestore behavior
    when(mockFirebaseFirestore.collection(any)).thenReturn(
        mockCollectionReference as CollectionReference<Map<String, dynamic>>);
    when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
  });

  testWidgets('RegistrationPage form submission', (WidgetTester tester) async {
    // Mock FirebaseService methods
    when(mockFirebaseAuth.createUserWithEmailAndPassword(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenAnswer((_) async => MockUserCredential());

    when(mockFirebaseAuth.currentUser).thenReturn(MockUser());

    when(mockDocumentReference.set(any)).thenAnswer((_) async => null);

    await tester.pumpWidget(MaterialApp(home: registrationPage));

    // Fill in the form
    await tester.enterText(
        find.byKey(const Key('email_field')), 'test@example.com');
    await tester.enterText(find.byKey(const Key('password_field')), 'password');
    await tester.enterText(
        find.byKey(const Key('repeat_password_field')), 'password');

    // Simulate form submission
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify that the FirebaseAuth createUserWithEmailAndPassword method was called
    verify(mockFirebaseAuth.createUserWithEmailAndPassword(
      email: 'test@example.com',
      password: 'password',
    )).called(1);

    // Verify that the Firestore set method was called with the correct data
    verify(mockDocumentReference.set({
      'email': 'test@example.com',
      'password': 'password',
      'verified': false,
    })).called(1);

    // You can add additional assertions as needed to validate the behavior of the registration process
  });
}
