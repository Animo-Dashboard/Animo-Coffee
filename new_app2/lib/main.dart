import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BluetoothScreen(),
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devices = [];
  BluetoothDevice? connectedDevice; // Add a nullability marker

  @override
  void initState() {
    super.initState();
    flutterBlue.state.listen((state) {
      if (state == BluetoothState.on) {
        scanDevices();
      }
    });
  }

  void scanDevices() {
    flutterBlue.startScan(timeout: const Duration(seconds: 4));
    flutterBlue.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devices.contains(result.device)) {
          setState(() {
            devices.add(result.device);
          });
        }
      }
    });
  }

  void connectToDevice(BluetoothDevice device) async {
    flutterBlue.stopScan();
    try {
      await device.connect();
      setState(() {
        connectedDevice = device;
      });
      print('Connected to device: ${device.name}');
    } catch (e) {
      print('Failed to connect to device: ${device.name}, $e');
    }
  }

  Future<void> requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status != PermissionStatus.granted) {
      print("Why tho");
    }
  }

  void sendToDevice(String message) async {
    if (connectedDevice == null) {
      return;
    }

    List<int> bytes = utf8.encode(message); // Convert message to bytes
    List<BluetoothService> services = await connectedDevice!.discoverServices();

    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        // ignore: unrelated_type_equality_checks
        if (characteristic.uuid == "someCharacteristicUuid") {
          try {
            await characteristic.write(bytes);
            print('Sent message: $message');
          } catch (e) {
            print('Failed to send message: $message, $e');
          }
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    requestLocationPermission();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Devices'),
      ),
      body: Column(
        children: [
          const Text(
            'Devices:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return ListTile(
                  title: Text(device.name),
                  subtitle: Text(device.id.toString()),
                  trailing: connectedDevice == device
                      ? const Text('Connected')
                      : ElevatedButton(
                          onPressed: () => connectToDevice(device),
                          child: const Text('Connect'),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
