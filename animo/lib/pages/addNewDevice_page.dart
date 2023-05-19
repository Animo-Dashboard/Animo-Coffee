// ignore: file_names
import 'package:flutter/material.dart';
import 'package:animo/inAppFunctions.dart';
import 'package:animo/reuseWidgets.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'DeviceInstallationPage .dart';

class AddNewDevicePage extends StatefulWidget {
  const AddNewDevicePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddNewDevicePageState createState() => _AddNewDevicePageState();
}

class _AddNewDevicePageState extends State<AddNewDevicePage> {
  List<DeviceItem> deviceItems = [];
  String pageTitle = "Add new device";
  final zipCodeController = TextEditingController();

  List<Map<dynamic, dynamic>> coordinates = [];

  List<String> moreMenuOptions = [];
  void handleClick(String value) {}

  //retrieves coordinates that match zip code
  Future<void> retrieveCoordinates(String zipCode) async {
    final databaseReference = FirebaseDatabase.instance.ref();
    final coordinatesReference = databaseReference.child('coordinates');

    DataSnapshot snapshot = (await coordinatesReference.once()) as DataSnapshot;
    Map<dynamic, dynamic>? values = snapshot.value as Map?;

    setState(() {
      coordinates = [];
      values?.forEach((key, value) {
        if (value['zipCode'] == zipCode) {
          coordinates.add(value);
        }
      });
    });
  }

  void addNewDevice() {
    DeviceItem newDevice = DeviceItem(
        name: "Optibean Machine",
        model: 'Optibean Touch 2',
        zipcode: '7827 SP');

    setState(() {
      deviceItems.add(newDevice);
    });
  }

  void _saveZipCode(String zipCode) {
    final database = FirebaseDatabase.instance.ref();
    database.child('Machines').child('zipCode').set(zipCode);
  }

  @override
  void dispose() {
    zipCodeController.dispose();
    super.dispose();
  void markStep5Completed(DeviceItem deviceItem) {
    setState(() {
      deviceItem.installed = true;
    });
  }

  void viewInstallationGuide(DeviceItem deviceItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceInstallationPage(
          deviceItem: deviceItem,
          markStep5Completed: markStep5Completed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: addNewDevice,
        backgroundColor: CustomColors.blue,
        child: Icon(Icons.plus_one),
      ),
      appBar: getAppBar(context, moreMenuOptions, pageTitle, handleClick),
      body: Container(
        decoration: getAppBackground(),
        child: ListView.builder(
          itemCount: deviceItems.length,
          itemBuilder: (context, index) {
            final deviceItem = deviceItems[index];
            //zip code
            TextField(
              controller: zipCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Zip Code',
              ),
            );
            ElevatedButton(
              onPressed: () {
                _saveZipCode(zipCodeController.text);
                retrieveCoordinates(zipCodeController.text);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Success'),
                        content: Text('Zip code saved to Firebase!'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
              child: Text('Save'),
            );
            Text(
              'Coordinates:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
            ListView.builder(
              shrinkWrap: true,
              itemCount: coordinates.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('X: ${coordinates[index]['x']}'),
                  subtitle: Text('Y: ${coordinates[index]['y']}'),
                  trailing: Text(
                      'Numeriekewaarde: ${coordinates[index]['Numeriekewaarde']}'),
                );
              },
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black12,
                ),
                child: ListTile(
                  leading: Image(
                    image: getDeviceImage('${deviceItem.model}'),
            return GestureDetector(
                onTap: () {
                  viewInstallationGuide(deviceItem);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                    ),
                    child: ListTile(
                      leading: Image(
                        image: getDeviceImage('${deviceItem.model}'),
                      ),
                      title: Text(
                        '${deviceItem.name}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${deviceItem.model}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Installed: ${deviceItem.installed}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_sharp,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ));
          },
        ),
      ),
    );
  }

  getDeviceImage(String s) {
    switch (s) {
      case "Optibean Touch 2":
        return const AssetImage("images/touch2.png");
      default:
    }
  }
}

class DeviceItem {
  final String name;
  final String model;
  final String zipcode;
  bool installed;

  DeviceItem({required this.name, required this.model, required this.zipcode, this.installed = false});

}
