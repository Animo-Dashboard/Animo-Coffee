import 'package:animo/reuseWidgets.dart';
import 'package:flutter/material.dart';

class CleaningInstantCanisterPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _CleaningInstantCanisterPageState createState() =>
      _CleaningInstantCanisterPageState();
}

class _CleaningInstantCanisterPageState
    extends State<CleaningInstantCanisterPage> {
  int currentPageIndex = 0;
  String pageTitle = "Cleaning the instant canister";

  List<Widget> maintenanceSteps = [
    const MainenanceStep(
      stepText: "Open the machine door.",
      imagePath: 'images/cleaning the instant canisters.PNG', // first image
    ),
    const MainenanceStep(
      stepText: "Turn the canister's outlet upwards (A)",
      imagePath: 'images/cleaning the instant canisters.PNG',
    ),
    const MainenanceStep(
      stepText: "Lift the canister from the socket and pull it out (B).",
      imagePath: 'images/cleaning the instant canisters.PNG',
    ),
    const MainenanceStep(
      stepText: "Remove the cover (C).",
      imagePath: 'images/cleaning the instant canisters 2.PNG', // second image
    ),
    const MainenanceStep(
      stepText: "Clean the instant canister and its parts.",
      imagePath: 'images/cleaning the instant canisters 3.PNG', // third image
    ),
    const MainenanceStep(
      stepText: "Dry the parts thoroughly.",
      imagePath: 'images/cleaning the instant canisters 3.PNG',
    ),
    const MainenanceStep(
      stepText: "Replace the cover.",
      imagePath: 'images/cleaning the instant canisters 3.PNG',
    ),
    const MainenanceStep(
      stepText: "Replace the canister into the socket.",
      imagePath: 'images/cleaning the instant canisters 3.PNG',
    ),
    const MainenanceStep(
      stepText: "Turn the canister’s outlet (A) downwards.",
      imagePath: 'images/cleaning the instant canisters 3.PNG',
    ),
    const MainenanceStep(
      stepText:
          "Make sure the canister locks into place with the pin in the hole.",
      imagePath: 'images/cleaning the instant canisters 3.PNG',
    ),
    const MainenanceStep(
      stepText: "Close the machine door.",
      imagePath: 'images/cleaning the instant canisters 3.PNG',
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
