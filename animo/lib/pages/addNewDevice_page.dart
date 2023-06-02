// ignore: file_names
import 'package:flutter/material.dart';
import 'package:animo/inAppFunctions.dart';
import 'package:animo/reuseWidgets.dart';

import 'DeviceInstallationPage .dart';
import 'DeviceRegistrationPage.dart';
import 'calciumLevels_page.dart';

class AddNewDevicePage extends StatefulWidget {
  const AddNewDevicePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddNewDevicePageState createState() => _AddNewDevicePageState();
}

class _AddNewDevicePageState extends State<AddNewDevicePage> {
  bool installationCompleted = false;

  List<DeviceItem> deviceItems = [];
  String pageTitle = "Add new device";

  TextEditingController nameController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  bool isInputValidated = false;

  void addNewDevice() {
    DeviceItem newDevice = DeviceItem(
      name: "Optibean Machine",
      model: 'Optibean Touch 2',
    );

    setState(() {
      deviceItems.add(newDevice);
    });
  }

  void markStep5Completed(DeviceItem deviceItem) {
    setState(() {
      deviceItem.installed = true;
      installationCompleted = true;
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

  void viewRegistrationGuide(DeviceItem deviceItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceRegistrationPage(deviceItem: deviceItem),
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
      appBar: getAppBar(context, pageTitle),
      body: Container(
        decoration: getAppBackground(),
        child: ListView.builder(
          itemCount: deviceItems.length,
          itemBuilder: (context, index) {
            final deviceItem = deviceItems[index];
            return GestureDetector(
                onTap: () {
                  if (installationCompleted == false) {
                    viewInstallationGuide(deviceItem);
                  } else {
                    viewRegistrationGuide(deviceItem);
                  }
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
                          ElevatedButton(
                            onPressed: () {
                              _showInputDialog(context);
                            },
                            child: Text('Add New Device'),
                          ),
                          SizedBox(height: 16.0),
                          if (isInputValidated)
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ZipCodeSearchPage()),
                                );
                              },
                              child: Text('Check Calcium Levels'),
                            ),
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

  void _showInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Device Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: zipCodeController,
                decoration: InputDecoration(
                  labelText: 'Zip Code',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_validateInput()) {
                  setState(() {
                    isInputValidated = true;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  bool _validateInput() {
    String name = nameController.text.trim();
    String zipCode = zipCodeController.text.trim();

    if (name.isEmpty || zipCode.isEmpty) {
      return false;
    }

    // Perform additional validation if required

    return true;
  }
}

class DeviceItem {
  final String name;
  final String model;
  bool installed;

  DeviceItem({required this.name, required this.model, this.installed = false});
}
