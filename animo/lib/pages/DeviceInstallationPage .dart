// ignore: file_names
import 'package:animo/pages/userData_page.dart';
import 'package:flutter/material.dart';
import 'package:animo/reuseWidgets.dart';
import 'addNewDevice_page.dart';

class DeviceInstallationPage extends StatefulWidget {
  final DeviceItem deviceItem;
  final Function markStep5Completed;

  const DeviceInstallationPage({
    required this.deviceItem,
    required this.markStep5Completed,
  });

  @override
  _DeviceInstallationPageState createState() => _DeviceInstallationPageState();
}

class _DeviceInstallationPageState extends State<DeviceInstallationPage> {
  int currentPageIndex = 0;
  String pageTitle = "Installation Guide";

  List<Widget> installationPages = [
    const InstallationStep(
      stepText:
          'This installation process will take approximately 30 minutes. Are you ready to proceed?',
      stepNumber: 1,
    ),
    const InstallationStep(
      imagePath: 'images/step2_image.png',
      stepText:
          'Congratulations on having purchased an Optibean! To start, place the machine on a flat surface, preferably a cabinet.',
      stepNumber: 2,
    ),
    const InstallationStep(
      imagePath: 'images/step3_image.png',
      stepText:
          'To Level the Machine, make sure to turn the feet. An example is provided.',
      stepNumber: 3,
    ),
    const InstallationStep(
      imagePath: 'images/step4_image.png',
      stepText:
          'Next, connect the device (A) to a tap (B) with the air valve. After this, open the tap and check for any leakage.',
      stepNumber: 4,
    ),
    const InstallationStep(
      imagePath: 'images/step5_image.png',
      stepText:
          'OPTIONAL: If necessary, connect the machine (A) with the hose (B) to the filter machine (C), then connect the filter system with the hose (D) to a tap.',
      stepNumber: 5,
    ),
    const InstallationStep(
      imagePath: 'images/step6_image.png',
      stepText:
          'Please locate the power cord, and when found, connect it with the machine.',
      stepNumber: 6,
    ),
    const InstallationStep(
      imagePath: 'images/step7_image.png',
      stepText:
          'Open the drip tray discharge (A) with a drill (Ø 6 mm). Then, connect a waste hose to the drip tray.',
      stepNumber: 7,
    ),
    const InstallationStep(
      imagePath: 'images/step8_image.png',
      stepText:
          'Open the machine door by placing the key inside the lock and turning it. After which place the stickers as shown (A & B)',
      stepNumber: 8,
    ),
  ];

  void handleStepCompletion() {
    if (currentPageIndex == 4) {
      widget.markStep5Completed(widget.deviceItem);
    }
  }

  void navigateToUserDataPage() {
    final DateTime now = DateTime.now();
    final String currentDate = "${now.day}/${now.month}/${now.year}";
    widget.deviceItem.installationDate = currentDate;
    widget.deviceItem.lastTimeAccess = currentDate;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDataPage(deviceItem: widget.deviceItem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, pageTitle),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  fixedSize: const Size.fromWidth(150),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: const Text('Previous'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: currentPageIndex < installationPages.length - 1
                    ? () {
                        setState(() {
                          currentPageIndex++;
                          handleStepCompletion();
                        });
                        if (currentPageIndex == installationPages.length - 1) {
                          navigateToUserDataPage();
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  fixedSize: Size.fromWidth(150),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InstallationStep extends StatelessWidget {
  final String? imagePath;
  final String stepText;
  final int stepNumber;

  const InstallationStep({
    Key? key,
    this.imagePath,
    required this.stepText,
    required this.stepNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (imagePath != null) ...[
            const SizedBox(height: 10),
            Image.asset(
              imagePath!,
              height: 300,
              width: 300,
              fit: BoxFit.contain,
            ),
          ],
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Step $stepNumber:',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    stepText,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
