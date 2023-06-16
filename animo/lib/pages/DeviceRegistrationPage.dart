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

//Creates a list of pages that will be displayed based on a template. A picture is possible but not required
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
      imagePath: 'images/regStep1_image.png',
      stepText:
          'At the main screen of the touchscreen, tap and hold on the main message (A).\nThen tap to select the Operator menu.\nInsert the login code: A.E: 11111\nIf you do not have a login code, please contact your dealer',
      stepNumber: 3,
    ),
    const InstallationStep(
      stepText:
          'These are all the steps neccesary to register into the machine itself. The following steps are optional.',
      stepNumber: 4,
    ),
    const InstallationStep(
      stepText:
          'To upload media files, please follow these steps. Note that to do so a SD card or USB stick will be required.\n1: Access the sound and vision menu. Refer to the previous step.\n2: Natvigate to the <Advertising Screen> or the <Logo on Cup screen>.\n3: Select the desired media format\n4: Connect the SD card or the USB stick to the port.\n5: Tap the button of the type of storage device.\n6: Select the type and confirm the choice\n7: Finally, tap the confirmation button.',
      stepNumber: 5,
    ),
    const InstallationStep(
      imagePath: 'images/regStep2_image.png',
      stepText:
          'To configure an image as the screensaver, please follow these steps.\n1: Upload the media file. Refer to the previous step.\n2: Tap on the <image> button.\n3: Tap on the <Choose Image> button\n4: Select the image file.\n5: When the file is loaded, tap the confirmation button.',
      stepNumber: 6,
    ),
    const InstallationStep(
      imagePath: 'images/regStep3_image.png',
      stepText:
          'To configure your own logo onto the cup buttons, please follow these steps.\n1: Upload the media file. Refer to step 5.\n2: Tap on the <Show logo on the cup> button\n3: Tap on the <Choose the logo> button.\n4: Select the logo file, and confirm your choice.\n5: Tap <X> to close the menu.',
      stepNumber: 7,
    ),
    const InstallationStep(
      stepText:
          'Thank you for following the registration guide.\nYou can now safely leave the guide and enjoy your coffee!.',
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
                  fixedSize: Size.fromWidth(150),
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
                        });
                      }
                    : () {
                        Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  fixedSize: Size.fromWidth(150),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: getNextButtonText(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  getNextButtonText() {
    if (currentPageIndex == installationPages.length - 1) {
      return const Text("Finish");
    } else {
      return Text("Next");
    }
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
            SizedBox(height: 10),
            Image.asset(
              imagePath!,
              height: 300,
              width: 300,
              fit: BoxFit.contain,
            ),
          ],
          SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.black26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step $stepNumber:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  stepText,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
