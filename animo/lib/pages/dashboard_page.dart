import 'package:flutter/material.dart';
import 'package:animo/inAppFunctions.dart';
import 'package:animo/reuseWidgets.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String pageTitle = "Dashboard";
  String selectedOption = "Select info to display";
  List<DropdownMenuItem<String>> dropdownItems = <String>[
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
  ].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();

  List<String> moreMenuOptions = ['Add new error', 'Settings', 'Log out'];
  void handleClick(String value) {
    switch (value) {
      case 'Add new error':
        break;
      case 'Settings':
        // Handle 'Settings' action
        break;
      case 'Log out':
        logOut(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, moreMenuOptions, pageTitle, handleClick),
      body: Container(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
              minWidth: MediaQuery.of(context).size.width),
          decoration: getAppBackground(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DropdownButton<String>(
                value: selectedOption == 'Select info to display'
                    ? null
                    : selectedOption, // Set the value to null if it's the sentinel value
                hint: Text("Select info to display"),
                onChanged: (value) {
                  setState(() {
                    selectedOption =
                        value!; // Update the selected option when a new option is chosen
                  });
                },
                items: dropdownItems,
              ),
              Container(
                child: Text(selectedOption),
              )
            ],
          )),
    );
  }
}

class ErrorItem {
  final int id;
  final String name;

  ErrorItem({required this.id, required this.name});
}
