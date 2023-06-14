import 'package:animo/reuseWidgets.dart';
import 'package:flutter/material.dart';

class CleaningTheDripTrayPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _CleaningTheDripTrayPageState createState() =>
      _CleaningTheDripTrayPageState();
}

class _CleaningTheDripTrayPageState extends State<CleaningTheDripTrayPage> {
  int currentPageIndex = 0;
  String pageTitle = "Cleaning/emptying the drip tray";

  List<Widget> maintenanceSteps = [
    const MainenanceStep(
      stepText: "Remove the drip tray (A) under the machine.",
      imagePath: 'images/cleaning the drip tray.PNG',
    ),
    const MainenanceStep(
      stepText: "If required, remove the trip tray hose",
      imagePath: 'images/cleaning the drip tray.PNG',
    ),
    const MainenanceStep(
      stepText: "Clean the drip tray.",
      imagePath: 'images/cleaning the drip tray.PNG',
    ),
    const MainenanceStep(
      stepText: "Replace the trip tray hose",
      imagePath: 'images/cleaning the drip tray.PNG',
    ),
    const MainenanceStep(
      stepText: "Replace the trip tray under the machine.",
      imagePath: 'images/cleaning the drip tray.PNG',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, pageTitle),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (currentPageIndex + 1) / maintenanceSteps.length,
          ),
          Expanded(child: maintenanceSteps[currentPageIndex]),
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
                onPressed: currentPageIndex < maintenanceSteps.length - 1
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

class MainenanceStep extends StatelessWidget {
  final String stepText;
  final String imagePath;

  const MainenanceStep({
    Key? key,
    required this.stepText,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            stepText,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Image.asset(imagePath), // Display the image using Image.asset
          // Add more content for each step if needed
        ],
      ),
    );
  }
}
