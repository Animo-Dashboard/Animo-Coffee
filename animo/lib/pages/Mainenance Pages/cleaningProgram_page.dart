import 'package:animo/reuseWidgets.dart';
import 'package:flutter/material.dart';

class CleaningProgramPage extends StatefulWidget {
  @override
  _CleaningProgramPageState createState() => _CleaningProgramPageState();
}

class _CleaningProgramPageState extends State<CleaningProgramPage> {
  int currentPageIndex = 0;
  String pageTitle = "Using the cleaning Program";

  List<Widget> maintenanceSteps = [
    const MainenanceStep(
      stepText:
          "On the touchscreen, tap and hold your finger on 'make yourchoice' (A) for several seconds",
      imagePath: 'images/using the rinsing program.PNG',
    ),
    const MainenanceStep(
      stepText: "Tap 'Clean'.",
      imagePath: 'images/using the rinsing program.PNG',
    ),
    const MainenanceStep(
      stepText: "Follow the instructions on the touchscreen",
      imagePath: 'images/using the rinsing program.PNG',
    ),
    const MainenanceStep(
      stepText: "Put the cleaning product (B) in the brewer.",
      imagePath: 'images/using the cleaning program.PNG',
    ),
    const MainenanceStep(
      stepText: "Close the door of the machine.",
      imagePath: 'images/using the cleaning program.PNG',
    ),
    const MainenanceStep(
      stepText: "Place a bowl (min. 1.5 l) under the outlet.",
      imagePath: 'images/using the cleaning program.PNG',
    ),
    const MainenanceStep(
      stepText: "Continue to follow the instructions on the touchscreen.",
      imagePath: 'images/using the cleaning program.PNG',
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
