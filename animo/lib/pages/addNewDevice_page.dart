// ignore: file_names
import 'package:flutter/material.dart';
import 'package:animo/inAppFunctions.dart';
import 'package:animo/reuseWidgets.dart';
import 'DeviceInstallationPage .dart';
import 'deviceRegistrationPage.dart';

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

  void addNewDevice() {
    DeviceItem newDevice = DeviceItem(
      name: "Optibean Machine",
      model: 'Optibean Model',
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
                  if (deviceItem.installed == false) {
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
                      leading: getModelImage("touch2"),
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
}

class DeviceItem {
  final String name;
  final String model;
  bool installed;

  DeviceItem({required this.name, required this.model, this.installed = false});

  set lastTimeAccess(String lastTimeAccess) {}

  set installationDate(String installationDate) {}
}
