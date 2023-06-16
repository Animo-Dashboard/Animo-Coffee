import 'package:animo/reuseWidgets.dart';
import 'package:flutter/material.dart';

class CleaningMixerPage extends StatefulWidget {
  @override
  _CleaningMixerPageState createState() => _CleaningMixerPageState();
}

class _CleaningMixerPageState extends State<CleaningMixerPage> {
  int currentPageIndex = 0;
  String pageTitle = "Cleaning the mixer";

  List<Widget> maintenanceSteps = [
    const MainenanceStep(
      stepText: "Turn the canister's outlet upwards.",
      imagePath: 'images/cleaning the mixer.PNG', // first image
    ),
    const MainenanceStep(
      stepText: "Remove the outlet hose from the mixer.",
      imagePath: 'images/cleaning the mixer.PNG',
    ),
    const MainenanceStep(
      stepText: "Turn the mounting ring (A) counterclockwise.",
      imagePath: 'images/cleaning the mixer.PNG',
    ),
    const MainenanceStep(
      stepText: "Take off the mixer housing (C).",
      imagePath: 'images/cleaning the mixer.PNG',
    ),
    const MainenanceStep(
      stepText: "Pull off the mixer fan (B).",
      imagePath: 'images/cleaning the mixer.PNG',
    ),
    const MainenanceStep(
      stepText: "Turn the mounting ring (A) further counterclockwise.",
      imagePath: 'images/cleaning the mixer.PNG',
    ),
    const MainenanceStep(
      stepText: "Remove the mounting ring.",
      imagePath: 'images/cleaning the mixer.PNG',
    ),
    const MainenanceStep(
      stepText: "Clean the parts.",
      imagePath: 'images/cleaning the mixer.PNG',
    ),
    const MainenanceStep(
      stepText: "Remove the dust tray (A).",
      imagePath: 'images/cleaning the mixer 2.PNG', // second image
    ),
    const MainenanceStep(
      stepText: "Clean and dry the dust tray.",
      imagePath: 'images/cleaning the mixer 2.PNG',
    ),
    const MainenanceStep(
      stepText: "Replace the dust tray.",
      imagePath: 'images/cleaning the mixer 2.PNG',
    ),
    const MainenanceStep(
      stepText:
          "Replace the mounting ring and turn it clockwise to lock the ring into place.",
      imagePath: 'images/cleaning the mixer 3.PNG', // third image
    ),
    const MainenanceStep(
      stepText:
          "Replace the mixer fan. Make sure that the mixer fan locks into place.",
      imagePath: 'images/cleaning the mixer 3.PNG',
    ),
    const MainenanceStep(
      stepText: "Replace the mixer housing.",
      imagePath: 'images/cleaning the mixer 3.PNG',
    ),
    const MainenanceStep(
      stepText:
          "Turn the mounting ring clockwise to lock the mixer into place.",
      imagePath: 'images/cleaning the mixer 3.PNG',
    ),
    const MainenanceStep(
      stepText: "Replace the outlet hose.",
      imagePath: 'images/cleaning the mixer 3.PNG',
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
