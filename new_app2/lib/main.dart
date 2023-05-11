import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:io' show Platform;

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
  final flutterReactiveBle = FlutterReactiveBle();
  List<DiscoveredDevice> _foundBleUARTDevices = [];
  late TextEditingController _dataToSendText;
  bool _scanning = false;
  bool _connected = false;
  String _logTexts = "";
  late StreamSubscription<DiscoveredDevice> _scanStream;
  late StreamSubscription<ConnectionStateUpdate> _connection;
  late Stream<List<int>> _receivedDataStream;
  List<String> _receivedData = [];
  late QualifiedCharacteristic _rxCharacteristic;

  @override
  void initState() {
    super.initState();
    _dataToSendText = TextEditingController();
  }

  void refreshScreen() {
    setState(() {});
  }

  void _disconnect() async {
    await _connection.cancel();
    _connected = false;
    refreshScreen();
  }

  void _stopScan() async {
    await _scanStream.cancel();
    _scanning = false;
    refreshScreen();
  }

  void _sendData() async {
    await flutterReactiveBle.writeCharacteristicWithResponse(_rxCharacteristic,
        value: _dataToSendText.text.codeUnits);
  }

  void _startScan() async {
    bool goForIt = false;
    if (Platform.isAndroid) {
      if (await Permission.location.serviceStatus.isEnabled) goForIt = true;
    } else if (Platform.isIOS) {
      goForIt = true;
    }
    if (goForIt) {
      _foundBleUARTDevices = [];
      _scanning = true;
      refreshScreen();
      _scanStream =
          flutterReactiveBle.scanForDevices(withServices: []).listen((device) {
        if (_foundBleUARTDevices.every((element) => element.id != device.id)) {
          setState(() {
            _foundBleUARTDevices.add(device);
          });
          refreshScreen();
        }
      }, onError: (Object error) {
        setState(() {
          _logTexts = "${_logTexts}ERROR while scanning:$error \n";
        });
      });
    } else {
      // await showNoPermissionDialog();
    }
  }

  onConnectDevice(int index) {}

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Bluetooth Devices'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Text("BLE UART Devices found:"),
              Container(
                  margin: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue, width: 2)),
                  height: 100,
                  child: ListView.builder(
                      itemCount: _foundBleUARTDevices.length,
                      itemBuilder: (context, index) => Card(
                              child: ListTile(
                            dense: true,
                            enabled: !((!_connected && _scanning) ||
                                (!_scanning && _connected)),
                            trailing: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                (!_connected && _scanning) ||
                                        (!_scanning && _connected)
                                    ? () {}
                                    : onConnectDevice(index);
                              },
                              child: Container(
                                width: 48,
                                height: 48,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                alignment: Alignment.center,
                                child: const Icon(Icons.add_link),
                              ),
                            ),
                            subtitle: Text(_foundBleUARTDevices[index].id),
                            title: Text(
                                "$index: ${_foundBleUARTDevices[index].name}"),
                          )))),
              const Text("Status messages:"),
              Container(
                  margin: const EdgeInsets.all(3.0),
                  width: 1400,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue, width: 2)),
                  height: 90,
                  child: Scrollbar(
                      child: SingleChildScrollView(child: Text(_logTexts)))),
              const Text("Received data:"),
              Container(
                  margin: const EdgeInsets.all(3.0),
                  width: 1400,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue, width: 2)),
                  height: 90,
                  child: Text(_receivedData.join("\n"))),
              const Text("Send message:"),
              Container(
                  margin: const EdgeInsets.all(3.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue, width: 2)),
                  child: Row(children: <Widget>[
                    Expanded(
                        child: TextField(
                      enabled: _connected,
                      controller: _dataToSendText,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Enter a string'),
                    )),
                    ElevatedButton(
                        onPressed: _connected ? _sendData : () {},
                        child: Icon(
                          Icons.send,
                          color: _connected ? Colors.blue : Colors.grey,
                        )),
                  ]))
            ],
          ),
        ),
        persistentFooterButtons: [
          Container(
            height: 35,
            child: Column(
              children: [
                if (_scanning)
                  const Text("Scanning: Scanning")
                else
                  const Text("Scanning: Idle"),
                if (_connected)
                  const Text("Connected")
                else
                  const Text("disconnected."),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: !_scanning && !_connected ? _startScan : () {},
            child: Icon(
              Icons.play_arrow,
              color: !_scanning && !_connected ? Colors.blue : Colors.grey,
            ),
          ),
          ElevatedButton(
              onPressed: _scanning ? _stopScan : () {},
              child: Icon(
                Icons.stop,
                color: _scanning ? Colors.blue : Colors.grey,
              )),
          ElevatedButton(
              onPressed: _connected ? _disconnect : () {},
              child: Icon(
                Icons.cancel,
                color: _connected ? Colors.blue : Colors.grey,
              ))
        ],
      );
}
