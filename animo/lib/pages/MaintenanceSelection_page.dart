import 'package:animo/inAppFunctions.dart';
import 'package:animo/pages/Mainenance%20Pages/cleaningBeanCanister_page.dart';
import 'package:animo/pages/Mainenance%20Pages/cleaningBrewer_page.dart';
import 'package:animo/pages/Mainenance%20Pages/cleaningExteriorAndInterior_page.dart';
import 'package:animo/pages/Mainenance%20Pages/cleaningInstantCanister_page.dart';
import 'package:animo/pages/Mainenance%20Pages/cleaningMixer_page.dart';
import 'package:animo/pages/Mainenance%20Pages/cleaningOutlet_page.dart';
import 'package:animo/pages/Mainenance%20Pages/cleaningProgram_page.dart';
import 'package:animo/pages/Mainenance%20Pages/cleaningTheDripTray_page.dart';
import 'package:animo/pages/Mainenance%20Pages/cleaningTouchScreen_page.dart';
import 'package:animo/pages/Mainenance%20Pages/emptyingWasteBins_page.dart';
import 'package:animo/pages/Mainenance%20Pages/usingTheRinsingProgram_page.dart';
import 'package:animo/reuseWidgets.dart';
import 'package:flutter/material.dart';
import 'package:animo/pages/contact_page.dart';

class MaintenanceSelectionPage extends StatefulWidget {
  const MaintenanceSelectionPage({super.key});

  @override
  _MaintenanceSelectionPageState createState() =>
      _MaintenanceSelectionPageState();
}

class _MaintenanceSelectionPageState extends State<MaintenanceSelectionPage> {
  final List<String> moreMenuOptions = ['Contact', 'Log out'];

  void handleClick(String value) {
    switch (value) {
      case 'Contact':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContactPage(),
          ),
        );
        break;
      case 'Settings':
        // Handle settings option
        break;
      case 'Log out':
        logOut(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "Maintenance", moreMenuOptions, handleClick),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'What maintenance would you like to perform?',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                // rinsing program
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RinsingProgramPage(),
                      ),
                    );
                  },
                  child: const Text('Using the rinsing program'),
                ),

                // cleaning program
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CleaningProgramPage(),
                      ),
                    );
                  },
                  child: const Text('Using the cleaning program'),
                ),

                //emptying waste bins
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmptyingWasteBinsPage(),
                      ),
                    );
                  },
                  child: const Text('Cleaning/emptying waste bins'),
                ),

                // cleaning the touch screen
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CleaningTouchScreenPage(),
                      ),
                    );
                  },
                  child: const Text('Cleaning the touch screen'),
                ),

                //cleaning the drip tray
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CleaningTheDripTrayPage(),
                      ),
                    );
                  },
                  child: const Text('Cleaning the drip tray'),
                ),

                //cleaning the outlet
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CleaningOutletPage(),
                      ),
                    );
                  },
                  child: const Text('Cleaning the outlet'),
                ),

                //cleaning mixer
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CleaningMixerPage(),
                      ),
                    );
                  },
                  child: const Text('Cleaning the mixer'),
                ),

                // cleaning instant canisters
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CleaningInstantCanisterPage(),
                      ),
                    );
                  },
                  child: const Text('Cleaning the instant canisters'),
                ),

                // cleaning brewer
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CleaningBrewerPage(),
                      ),
                    );
                  },
                  child: const Text('Cleaning the brewer'),
                ),

                //Cleaning the exterior and interior page
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CleaningExteriorAndInteriorPage(),
                      ),
                    );
                  },
                  child: const Text('Cleaning the exterior and interior'),
                ),

                //Cleaning the bean canister page
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CleaningBeanCanisterPage(),
                      ),
                    );
                  },
                  child: const Text('Cleaning the bean canister'),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
