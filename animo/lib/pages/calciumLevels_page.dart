import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class ZipCodeSearchPage extends StatefulWidget {
  @override
  _ZipCodeSearchPageState createState() => _ZipCodeSearchPageState();
}

class _ZipCodeSearchPageState extends State<ZipCodeSearchPage> {
  final TextEditingController zipCodeController = TextEditingController();
  String longitude = "";
  String latitude = "";
  String xCoordinate = "";
  String yCoordinate = "";
  String closestNumeriekewaarde = "";

  Future<void> searchZipCode() async {
    String zipCode = zipCodeController.text;
    if (zipCode.length == 4) {
      try {
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection('4pp').get();

        for (DocumentSnapshot docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> data =
              docSnapshot.data() as Map<String, dynamic>;
          if (data['postcode'] == int.parse(zipCode)) {
            longitude = data['longitude'].toString();
            latitude = data['latitude'].toString();

            final position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);
            final double centerLatitude = 0;
            final double centerLongitude = 0;

            final double x = await Geolocator.distanceBetween(position.latitude,
                position.longitude, centerLatitude, position.longitude);
            final double y = await Geolocator.distanceBetween(centerLatitude,
                position.longitude, centerLatitude, centerLongitude);

            xCoordinate = x.toStringAsFixed(2);
            yCoordinate = y.toStringAsFixed(2);

            final double? closestValue = await findClosestNumeriekewaarde(x, y);
            closestNumeriekewaarde = closestValue.toString();

            break;
          }
        }

        if (longitude.isEmpty && latitude.isEmpty) {
          longitude = "Not Found";
          latitude = "Not Found";
          xCoordinate = "";
          yCoordinate = "";
          closestNumeriekewaarde = "";
        }
      } catch (e) {
        print(e);
        longitude = "Error";
        latitude = "Error";
        xCoordinate = "";
        yCoordinate = "";
        closestNumeriekewaarde = "";
      }
    } else {
      longitude = "";
      latitude = "";
      xCoordinate = "";
      yCoordinate = "";
      closestNumeriekewaarde = "";
    }

    setState(() {});
  }

  Future<double?> findClosestNumeriekewaarde(double x, double y) async {
    final databaseReference = FirebaseFirestore.instance;
    final collectionReference =
        databaseReference.collection('IM-Metingen_2021_6_mnd11tm-12');

    final snapshot = await collectionReference.get();

    double? closestNumeriekewaarde;
    double minDifference = double.infinity;

    for (final document in snapshot.docs) {
      final geometriePunt =
          document.data()['GeometriePunt'] as Map<String, dynamic>;
      final documentX = geometriePunt['X'] as double;
      final documentY = geometriePunt['Y'] as double;

      final difference = (x - documentX).abs() + (y - documentY).abs();

      if (difference < minDifference) {
        minDifference = difference;
        closestNumeriekewaarde = document.data()['Numeriekewaarde'] as double;
      }
    }

    return closestNumeriekewaarde;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zip Code Search'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: zipCodeController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(
                labelText: 'Enter Zip Code',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                searchZipCode();
              },
              child: Text('Search'),
            ),
            SizedBox(height: 16.0),
            Text('Longitude: $longitude'),
            Text('Latitude: $latitude'),
            Text('X Coordinate: $xCoordinate'),
            Text('Y Coordinate: $yCoordinate'),
            Text('Numeriekwaarde: $closestNumeriekewaarde'),
          ],
        ),
      ),
    );
  }
}
