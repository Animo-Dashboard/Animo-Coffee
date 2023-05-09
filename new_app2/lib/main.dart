import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BluetoothScreen(),
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  @override
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
    flutterBlue.startScan(timeout: Duration(seconds: 4));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Devices'),
      ),
      body: Column(
        children: [
          Text(
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
                      ? Text('Connected')
                      : ElevatedButton(
                          onPressed: () => connectToDevice(device),
                          child: Text('Connect'),
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
