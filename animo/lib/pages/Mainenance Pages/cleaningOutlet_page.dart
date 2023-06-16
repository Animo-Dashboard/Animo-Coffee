import 'package:animo/reuseWidgets.dart';
import 'package:flutter/material.dart';

class CleaningOutletPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _CleaningOutletPageState createState() => _CleaningOutletPageState();
}

class _CleaningOutletPageState extends State<CleaningOutletPage> {
  int currentPageIndex = 0;
  String pageTitle = "Cleaning the outlet";

  List<Widget> maintenanceSteps = [
    const MainenanceStep(
      stepText: "Open the machine door.",
      imagePath: 'images/cleaning the outlet 1.PNG', // first image
    ),
    const MainenanceStep(
      stepText:
          "Remove the outlet front (A) while holding the tab at the back of the front.",
      imagePath: 'images/cleaning the outlet 1.PNG',
    ),
    const MainenanceStep(
      stepText: "Take out the outlet housing (B).",
      imagePath: 'images/cleaning the outlet 2.PNG', // second image
    ),
    const MainenanceStep(
      stepText: "Clean the outlet housing",
      imagePath: 'images/cleaning the outlet 2.PNG',
    ),
    const MainenanceStep(
      stepText: "Replace the outlet housing.",
      imagePath: 'images/cleaning the outlet 2.PNG',
    ),
    const MainenanceStep(
      stepText: "Replace the outlet front.",
      imagePath: 'images/cleaning the outlet 2.PNG',
    ),
    const MainenanceStep(
      stepText:
          "Take out the splitter (C) and drink outlet (D) from the front piece of the outlet arm (E).",
      imagePath: 'images/cleaning the outlet 3.PNG', // third image
    ),
    const MainenanceStep(
      stepText: "Remove the front piece from the outlet arm (F).",
      imagePath: 'images/cleaning the outlet 4.PNG', // fourth image
    ),
    const MainenanceStep(
      stepText: "Clean the parts.",
      imagePath: 'images/cleaning the outlet 4.PNG',
    ),
    const MainenanceStep(
      stepText: "Replace the outlet hoses.",
      imagePath: 'images/cleaning the outlet 4.PNG',
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
