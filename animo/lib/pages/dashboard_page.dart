import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animo/inAppFunctions.dart';
import 'package:animo/reuseWidgets.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String pageTitle = "Dashboard";
  String selectedOption = "Select info to display";
  List<DropdownMenuItem<String>> dropdownItems = <String>[
    'Current errors',
    'Distribution of drinks',
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
      appBar: getAppBar(context, pageTitle, moreMenuOptions, handleClick),
      body: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
          minWidth: MediaQuery.of(context).size.width,
        ),
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
                  selectedOption = value!;
                });
              },
              items: dropdownItems,
            ),
            const SizedBox(height: 20.0),
            FutureBuilder(
              future: getDevices(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return getGraph(selectedOption, snapshot.data);
                } else {
                  return Text("Nothing to display");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget getGraph(String option, devices) {
    switch (option) {
      case "Distribution of drinks":
        double coffee = 0;
        double tea = 0;
        double hotChocolate = 0;
        for (var device in devices) {
          var deviceData = device.data();
          coffee += deviceData['CoffeeBrewed'];
          tea += deviceData['TeaBrewed'];
          hotChocolate += deviceData['HotChocolateBrewed'];
        }
        List<PieChartSectionData> chartData = [
          PieChartSectionData(
            color: Colors.blue,
            value: coffee,
            title: 'Coffee',
            radius: 40,
          ),
          PieChartSectionData(
            color: Colors.green,
            value: tea,
            title: 'Tea',
            radius: 40,
          ),
          PieChartSectionData(
            color: Colors.orange,
            value: hotChocolate,
            title: 'Hot Chocolate',
            radius: 40,
          ),
        ];
        return PieChart(
          PieChartData(
            sections: chartData,
            sectionsSpace: 0,
            centerSpaceRadius: 40,
            startDegreeOffset: -90,
            borderData: FlBorderData(show: false),
          ),
        );

      default:
        return Text("something went wrong");
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>?>
      getDevices() async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> devices = [];
    await FirebaseFirestore.instance.collection("Machines").get().then((value) {
      devices = value.docs;
    });
    return devices;
  }
}
