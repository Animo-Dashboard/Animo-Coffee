import 'package:animo/reuseWidgets.dart';
import 'package:flutter/material.dart';
import 'package:animo/inAppFunctions.dart';
import 'package:flutter_blue/flutter_blue.dart';

class RegisterDevicePage extends StatefulWidget {
  const RegisterDevicePage({super.key});

  @override
  _RegisterDevicePage createState() => _RegisterDevicePage();
}

class _RegisterDevicePage extends State<RegisterDevicePage> {
  String bluetoothAddress = 'Unknown';
  String name = 'Unknown';
  List<String> moreMenuOptions = ['Settings', 'Log out'];
  void handleClick(String value) {
    switch (value) {
      case 'Settings':
        // Handle 'Settings' action
        break;
      case 'Log out':
        logOut(context);
        break;
    }
  }

  String getDeviceImageFilename(String deviceName) {
    // Remove any invalid characters from the device name
    String sanitizedDeviceName = deviceName.replaceAll(RegExp(r'[^\w\s]+'), '');
    // Replace spaces with underscores
    sanitizedDeviceName = sanitizedDeviceName.replaceAll(' ', '_');
    // Convert to lowercase
    sanitizedDeviceName = sanitizedDeviceName.toLowerCase();
    return 'assets/images/$sanitizedDeviceName.png';
  }

  @override
  void initState() {
    super.initState();
    // retrieveBluetoothAddressAndName();
  }

  Future<void> retrieveBluetoothAddressAndName() async {
    FlutterBlue flutterBlue = FlutterBlue.instance;
    await flutterBlue.startScan(timeout: Duration(seconds: 4));
    flutterBlue.scanResults.listen((results) {
      for (ScanResult result in results) {
        BluetoothDevice device = result.device;
        String address = device.id.id;
        String deviceName = device.name;
        setState(() {
          bluetoothAddress = address;
        });
        if (deviceName.isNotEmpty) {
          setState(() {
            name = deviceName;
          });
          break;
        }
        break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String imageFilename = getDeviceImageFilename(name);
    return Scaffold(
      body: Container(
        decoration: getAppBackground(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imageFilename,
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              bluetoothAddress,
              style: TextStyle(fontSize: 24),
            ),
            Text(
              name,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            //should be made dynamic and start loading after button is clicked
            LinearProgressIndicator(minHeight: 20),
            ElevatedButton(
              onPressed: () {
                // Do something when button is pressed
              },
              child: const Text('Install'),
            ),
          ],
        ),
      ),
    );
  }
}
