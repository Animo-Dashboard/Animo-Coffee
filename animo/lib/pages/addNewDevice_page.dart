import 'package:flutter/material.dart';
import 'package:animo/inAppFunctions.dart';
import 'package:animo/reuseWidgets.dart';

class AddNewDevicePage extends StatefulWidget {
  const AddNewDevicePage({super.key});

  @override
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
            return Padding(
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
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                  subtitle: Text(
                    '${deviceItem.model}',
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
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
