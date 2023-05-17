import 'package:flutter/material.dart';
import 'package:animo/inAppFunctions.dart';
import 'package:animo/reuseWidgets.dart';

import 'registeredDevices_page.dart';

class DeviceInstallationPage extends StatefulWidget {
  final DeviceItem deviceItem;

  DeviceInstallationPage({required this.deviceItem});

  @override
  _DeviceInstallationPageState createState() => _DeviceInstallationPageState();
}

class _DeviceInstallationPageState extends State<DeviceInstallationPage> {
  int currentPageIndex = 0;

  List<Widget> installationPages = [
    // Add your installation steps as separate pages
    InstallationStep1(),
    InstallationStep2(),
    InstallationStep3(),
    // ...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Installation Guide'),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (currentPageIndex + 1) / installationPages.length,
          ),
          Expanded(child: installationPages[currentPageIndex]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: currentPageIndex > 0
                    ? () {
                        setState(() {
                          currentPageIndex--;
                        });
                      }
                    : null,
                child: const Text('Previous'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: currentPageIndex < installationPages.length - 1
                    ? () {
                        setState(() {
                          currentPageIndex++;
                        });
                      }
                    : null,
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InstallationStep1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Customize the content for step 1
      child: Text('Step 1: ...'),
    );
  }
}

class InstallationStep2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Customize the content for step 2
      child: Text('Step 2: ...'),
    );
  }
}

class InstallationStep3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Customize the content for step 3
      child: Text('Step 3: ...'),
    );
  }
}
