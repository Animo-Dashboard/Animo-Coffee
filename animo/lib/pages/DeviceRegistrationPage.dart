import 'package:flutter/material.dart';

import '../inAppFunctions.dart';
import '../reuseWidgets.dart';
import 'addNewDevice_page.dart';

class DeviceRegistrationPage extends StatefulWidget {
  final DeviceItem deviceItem;

  const DeviceRegistrationPage({
    super.key,
    required this.deviceItem,
  });

  // ignore: library_private_types_in_public_api
  _DeviceRegistrationPageState createState() => _DeviceRegistrationPageState();
}

class _DeviceRegistrationPageState extends State<DeviceRegistrationPage> {
  int currentPageIndex = 0;
  String pageTitle = "Registration Guide";

  List<Widget> installationPages = [
    const InstallationStep(
      stepText:
          'This registration process will take approximately an hour. Are you ready to proceed?',
      stepNumber: 1,
    ),
    const InstallationStep(
      stepText:
          'Congratulations on getting an installed Optibean device! To get started, follow these steps:\n1: Plug the machine into an earthed socket.\n2: Switch on the machine and follow the instructions on the display\n3: Place a bowl (min 1.5 L) under the outlet.\n4: Use the touchscreen to select a recipe and dispense the beverage\n5: Check whether taste and quality is as desirned\n6: Repeat the previous steps for every recipe to assure all recipes are as desired\n7: If the taste or quantity is not as desired, inform the dealer.',
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

  List<String> moreMenuOptions = ['Settings', 'Log out'];
  void handleClick(String value) {
    switch (value) {
      case 'Settings':
        break;
      case 'Log out':
        logOut(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, pageTitle, moreMenuOptions, handleClick),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
    return Container(
      child: Column(
        children: [
          if (imagePath != null) ...[
            SizedBox(height: 10),
            Image.asset(
              imagePath!,
              height: 300,
              width: 300,
              fit: BoxFit.contain,
            ),
          ],
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    stepText,
                    style: TextStyle(fontSize: 16),
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
