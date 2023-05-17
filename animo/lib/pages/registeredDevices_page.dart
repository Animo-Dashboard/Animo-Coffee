import 'dart:math';

import 'package:animo/reuseWidgets.dart';
import 'package:flutter/material.dart';
import 'package:animo/inAppFunctions.dart';
import 'DeviceInstallationPage .dart';
import 'addNewDevice_page.dart';

class RegisteredDevicesPage extends StatefulWidget {
  const RegisteredDevicesPage({super.key});

  @override
  _RegisteredDevicesPage createState() => _RegisteredDevicesPage();
}

class _RegisteredDevicesPage extends State<RegisteredDevicesPage> {
  final _formKey = GlobalKey<FormState>();
  List<DeviceItem> deviceItems = [];
  String pageTitle = "Your devices";

  List<String> moreMenuOptions = ['Add new device', 'Settings', 'Log out'];
  void handleClick(String value) {
    switch (value) {
      case 'Add new device':
        Navigator.pushNamed(context, '/addNewDevice');
        break;
      case 'Settings':
        break;
      case 'Log out':
        logOut(context);
        break;
    }
  }

  void viewInstallationGuide(DeviceItem deviceItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceInstallationPage(deviceItem: deviceItem),
      ),
    );
  }

  void addNewDevice() {
    DeviceItem newDevice = DeviceItem(
      name: "Optibean Machine",
      model: 'Optibean Touch 2',
    );

    setState(() {
      deviceItems.add(newDevice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: addNewDevice,
          backgroundColor: CustomColors.blue,
          child: Icon(Icons.plus_one),
        ),
        body: Container(
            decoration: getAppBackground(),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: sqrt1_2),
              itemBuilder: (context, index) {
                final deviceItem = deviceItems[index];
                return GridTile(
                    child: GestureDetector(
                        onTap: () => viewInstallationGuide(deviceItem),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Image(
                              image: getDeviceImage(deviceItem.model),
                              height: 170,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              deviceItem.name,
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(deviceItem.model,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w300))
                          ],
                        )));
              },
              itemCount: deviceItems.length,
            )),
        appBar: getAppBar(context, moreMenuOptions, pageTitle, handleClick));
  }

  getDeviceImage(String s) {
    switch (s) {
      case "Optibean Touch 2":
        return AssetImage("images/touch2.png");
        break;
      default:
    }
  }
}

class DeviceItem {
  final String name;
  final String model;

  DeviceItem({required this.name, required this.model});
}
