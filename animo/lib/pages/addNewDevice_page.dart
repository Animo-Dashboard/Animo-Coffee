// ignore: file_names
import 'package:flutter/material.dart';
import 'package:animo/inAppFunctions.dart';
import 'package:animo/reuseWidgets.dart';

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

  List<String> moreMenuOptions = [];
  void handleClick(String value) {}

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
  bool installed;

  DeviceItem({required this.name, required this.model, this.installed = false});
}
