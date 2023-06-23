import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animo/reuseWidgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';

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
  ].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();

  TextStyle pieChartTextStyle = const TextStyle(fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, pageTitle),
      body: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
          minWidth: MediaQuery.of(context).size.width,
        ),
        decoration: getAppBackground(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              DropdownButton<String>(
                value: selectedOption == 'Select info to display'
                    ? null
                    : selectedOption, // Set the value to null if it's the sentinel value
                hint: const Text("Select info to display"),
                onChanged: (value) {
                  setState(() {
                    selectedOption = value!;
                  });
                },
                items: dropdownItems,
              ),
              Container(
                height: MediaQuery.of(context).size.height - 200,
                child: FutureBuilder(
                  future: getDevices(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return getGraph(selectedOption, snapshot.data!);
                    } else {
                      return const Text("Nothing to display");
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getGraph(String option,
      List<QueryDocumentSnapshot<Map<String, dynamic>>> devices) {
    if (devices.isEmpty) {
      return Text("No data to display");
    }
    switch (option) {
      case "Current errors":
        Map<String, int> errorCounts = {};
        for (var device in devices) {
          var deviceData = device.data();
          String newError = deviceData["Error"] ?? "";
          List<String> currentErrors = [];
          List<dynamic> currentErrorFromDatabase =
              deviceData["CurrentError"] ?? [];
          for (var error in currentErrorFromDatabase) {
            currentErrors.add(error.toString());
          }

          List<String> errors = [];
          if (currentErrors.isNotEmpty) {
            errors.addAll(currentErrors);
          }
          if (newError != "") {
            errors.add(newError);
          }

          for (var error in errors) {
            if (error.isNotEmpty && error != "null") {
              if (errorCounts.containsKey(error)) {
                errorCounts[error] = errorCounts[error]! + 1;
              } else {
                errorCounts[error] = 1;
              }
            }
          }
        }

        if (errorCounts.isEmpty) {
          return Text("No data to display");
        }

        BarChartGroupData makeGroupData(
          int x,
          int y, {
          Color? barColor,
          double width = 10,
          List<int> showTooltips = const [],
        }) {
          barColor = Colors.black;
          return BarChartGroupData(
            x: x,
            barRods: [
              BarChartRodData(
                toY: y.toDouble(),
                borderRadius: BorderRadius.all(Radius.zero),
                color: barColor,
                width: width,
                borderSide: const BorderSide(color: Colors.white, width: 0),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                ),
              ),
            ],
            showingTooltipIndicators: showTooltips,
          );
        }

        List<BarChartGroupData> chartData =
            List.generate(errorCounts.length, (index) {
          return makeGroupData(index, errorCounts.values.elementAt(index));
        });

        return BarChart(
          BarChartData(
              maxY: errorCounts.values
                      .toList()
                      .reduce(
                          (value, element) => value > element ? value : element)
                      .toDouble() *
                  1.1,
              alignment: BarChartAlignment.spaceEvenly,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const style =
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w500);
                      String text = errorCounts.keys.elementAt(value.toInt());
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(text, style: style),
                      );
                    },
                  ))),
              barGroups: chartData),
        );
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
            title: 'Coffee ${coffee.ceil()}',
            titleStyle: pieChartTextStyle,
            radius: 80,
          ),
          PieChartSectionData(
            color: Colors.green,
            value: tea,
            title: 'Tea ${tea.ceil()}',
            titleStyle: pieChartTextStyle,
            radius: 80,
          ),
          PieChartSectionData(
            color: Colors.orange,
            value: hotChocolate,
            title: 'Hot Chocolate ${hotChocolate.ceil()}',
            titleStyle: pieChartTextStyle,
            radius: 80,
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
        return const Text("");
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
