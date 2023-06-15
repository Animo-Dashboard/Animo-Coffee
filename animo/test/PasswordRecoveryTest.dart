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

// Mock FirebaseService
class MockFirebaseService extends Mock implements FirebaseService {}

class FirebaseService {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  FirebaseService({required this.firebaseAuth, required this.firestore});

  Future<UserCredential> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendVerificationEmail(String userEmail) async {
    // Implement the sendVerificationEmail logic here
  }

  Future<void> saveUserToFirestore(
      String uid, String email, String password) async {
    final userRef = firestore.collection('Users').doc(uid);
    await userRef.set({
      'email': email,
      'password': password,
      'verified': false,
    });
  }
}

void main() {
  late RegistrationPage registrationPage;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockCollectionReference mockCollectionReference;
  late MockDocumentReference mockDocumentReference;
  late MockFirebaseService mockFirebaseService;

  setUp(() {
    registrationPage = RegistrationPage();

    // Initialize mock objects
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    mockFirebaseService = MockFirebaseService();

    // Provide mock dependencies
    when(mockFirebaseService.createUserWithEmailAndPassword(
            email: anyNamed('email'), password: anyNamed('password')))
        .thenAnswer((_) async => UserCredentialMock());

    when(mockFirebaseService.sendVerificationEmail(any))
        .thenAnswer((_) async {});

    when(mockFirebaseService.firestore).thenReturn(mockFirebaseFirestore);

    registrationPage.firebaseService = mockFirebaseService;

    // Mock Firestore behavior
    when(mockFirebaseFirestore.collection(any))
        .thenReturn(mockCollectionReference);
    when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
  });

  testWidgets('RegistrationPage form submission', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: registrationPage));

    // Fill in the form
    await tester.enterText(
        find.byKey(const Key('email_field')), 'test@example.com');
    await tester.enterText(find.byKey(const Key('password_field')), 'password');
    await tester.enterText(
        find.byKey(const Key('repeat_password_field')), 'password');

    // Simulate form submission
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify that the FirebaseService createUserWithEmailAndPassword method was called
    verify(mockFirebaseService.createUserWithEmailAndPassword(
      email: 'test@example.com',
      password: 'password',
    )).called(1);

    // Verify that the Firestore set method was called with the correct data
    verify(mockDocumentReference.set({
      'email': 'test@example.com',
      'password': 'password',
      'verified': false,
    })).called(1);

    // Verify that the FirebaseService sendVerificationEmail method was called
    verify(mockFirebaseService.sendVerificationEmail('test@example.com'))
        .called(1);

    // You can add additional assertions as needed to validate the behavior of the registration process
  });
}
