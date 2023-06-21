import 'package:animo/reuseWidgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class ZipCodeSearchPage extends StatefulWidget {
  @override
  _ZipCodeSearchPageState createState() => _ZipCodeSearchPageState();
}

class _ZipCodeSearchPageState extends State<ZipCodeSearchPage> {
  final TextEditingController zipCodeController = TextEditingController();
  String pageTitle = "Zip Code Search";
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

  EdgeInsets headerPadding =
      const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16);
  EdgeInsets nonHeaderPadding =
      const EdgeInsets.only(left: 28, right: 16, top: 5, bottom: 8);

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    return Scaffold(
      appBar: getAppBar(context, pageTitle),
      body: Container(
        decoration: getAppBackground(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: TextFormField(
                  controller: zipCodeController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  initialValue: arguments["zipCode"],
                  decoration: InputDecoration(
                    labelText: 'Enter Zip Code',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  searchZipCode();
                },
                child: Text('SEARCH'),
              ),
              SizedBox(height: 32.0),
              Column(
                children: [
                  Container(
                      color: Colors.black38,
                      child: Padding(
                        padding: headerPadding,
                        child: Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 32) /
                                  3 *
                                  2,
                              child: const Text(
                                "Zip code information",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Container(
                      color: Colors.black12,
                      child: Padding(
                        padding: nonHeaderPadding,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: (MediaQuery.of(context).size.width -
                                          100) /
                                      3 *
                                      2,
                                  child: const Text(
                                    "Longitude",
                                  ),
                                ),
                                Text(
                                  longitude,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: (MediaQuery.of(context).size.width -
                                          100) /
                                      3 *
                                      2,
                                  child: const Text(
                                    "Latitude",
                                  ),
                                ),
                                Text(
                                  latitude,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: (MediaQuery.of(context).size.width -
                                          100) /
                                      3 *
                                      2,
                                  child: const Text(
                                    "X Coordinate",
                                  ),
                                ),
                                Text(
                                  xCoordinate,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: (MediaQuery.of(context).size.width -
                                          100) /
                                      3 *
                                      2,
                                  child: const Text(
                                    "Y Coordinate",
                                  ),
                                ),
                                Text(
                                  yCoordinate,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: (MediaQuery.of(context).size.width -
                                          100) /
                                      3 *
                                      2,
                                  child: const Text(
                                    "Numeriekwaarde",
                                  ),
                                ),
                                Text(
                                  closestNumeriekewaarde,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
