import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ZipCodePage extends StatefulWidget {
  @override
  _ZipCodePageState createState() => _ZipCodePageState();
}

class _ZipCodePageState extends State<ZipCodePage> {
  final TextEditingController _zipCodeController = TextEditingController();
  String _latitude = '';
  String _longitude = '';
  String _numeriekWaarde = '';

  Future<void> _checkZipCode() async {
    final String zipCode = _zipCodeController.text;
    final CollectionReference machinesCollection =
        FirebaseFirestore.instance.collection('Machines');
    final CollectionReference fourPpCollection =
        FirebaseFirestore.instance.collection('4pp');

    final QuerySnapshot querySnapshot =
        await fourPpCollection.where('postcode', isEqualTo: zipCode).get();

    if (querySnapshot.docs.isNotEmpty) {
      final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      setState(() {
        _latitude = documentSnapshot['latitude'];
        _longitude = documentSnapshot['longitude'];
      });
    } else {
      setState(() {
        _latitude = '';
        _longitude = 'Please check your zip code again.';
      });
    }

    // Save the zip code to Machines collection
    await machinesCollection.doc().set({'ZipCode': zipCode});
  }

  Future<double> findClosestNumeriekewaarde(
      double latitude, double longitude) async {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('IM-Metingen_2021_6_mnd11tm-12');

    QuerySnapshot querySnapshot = await collection.get();

    double closestX;
    double closestY;
    double smallestDistance = double.infinity;
    double? closestNumeriekewaarde; // Initialize as nullable

    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?;
      Map<String, dynamic> geometriePunt = data!['GeometriePunt'];
      double x = geometriePunt['X'];
      double y = geometriePunt['Y'];

      double distance = calculateDistance(latitude, longitude, x, y);

      if (distance < smallestDistance) {
        smallestDistance = distance;
        closestX = x;
        closestY = y;
        closestNumeriekewaarde = data['Numeriekewaarde'];
      }
    }

    // Add a null check to handle the case where no closestNumeriekewaarde is found
    if (closestNumeriekewaarde != null) {
      _numeriekWaarde = closestNumeriekewaarde as String;
      return closestNumeriekewaarde;
    } else {
      // Handle the case where no closestNumeriekewaarde is found
      throw Exception('No closest Numeriekewaarde found.');
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Can update the calciulation
    double dx = lat1 - lat2;
    double dy = lon1 - lon2;
    return dx * dx + dy * dy;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zip Code Checker'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _zipCodeController,
              decoration: InputDecoration(
                labelText: 'Enter Zip Code',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _checkZipCode,
              child: Text('Check'),
            ),
            SizedBox(height: 16.0),
            Text('Latitude: $_latitude'),
            Text('Longitude: $_longitude'),
            Text('Numeriekwaarde: $_numeriekWaarde'),
          ],
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: ZipCodePage(),
  ));
}
