import 'package:animo/reuseWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animo/inAppFunctions.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DeviceStatisticsPage extends StatefulWidget {
  const DeviceStatisticsPage({super.key});

  @override
  _DeviceStatisticsPage createState() => _DeviceStatisticsPage();
}

class _DeviceStatisticsPage extends State<DeviceStatisticsPage> {
  final _formKey = GlobalKey<FormState>();

  String pageTitle = "Page";
  String documentID = "";

  List<String> moreMenuOptions = ['Maintenance'];
  void handleClick(String value) {
    switch (value) {
      case 'Maintenance':
        Navigator.pushNamed(context, '/maintenance');
        break;
    }
  }

  Device device =
      Device('name', 'model', "serialNumber", [], "", "", 0, 0, 0, 0, 0, 0);
  EdgeInsets headerPadding =
      const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16);
  EdgeInsets nonHeaderPadding =
      const EdgeInsets.only(left: 28, right: 16, top: 5, bottom: 8);

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map<String, dynamic>;
    var data = arguments['device'];
    documentID = arguments['id'];
    try {
      DateFormat format = DateFormat("dd/MM/yyyy");
      var data = arguments["device"];
      var model = data["Model"];
      switch (model) {
        case "touch2":
          model = "OptiBean 2 Touch";
          break;
        case "touch3":
          model = "OptiBean 3 Touch";
          break;
        case "touch4":
          model = "OptiBean 4 Touch";
          break;
        default:
          break;
      }
      pageTitle = data["Name"];
      String newError = data["Error"] ?? "";
      List<String> currentErrors = [];
      List<dynamic> currentErrorFromDatabase = data["CurrentError"] ?? [];
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

      device = Device(
        data["Name"] as String? ?? "Default Name",
        model as String? ?? "Default Model",
        data["SerialNumber"] as String? ?? "Default Serial Number",
        errors,
        data["InstallationDate"] as String? ?? format.format(DateTime.now()),
        data["LastTimeAccess"] as String? ?? format.format(DateTime.now()),
        data["CoffeeBrewed"] as int? ?? 0,
        data["TeaBrewed"] as int? ?? 0,
        data["HotChocolateBrewed"] as int? ?? 0,
        data["BeansPerc"] as int? ?? 0,
        data["MilkPerc"] as int? ?? 0,
        data["ChocolatePerc"] as int? ?? 0,
      );
    } catch (e) {
      print(e);
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: getAppBackground(),
          child: SingleChildScrollView(
              child: Column(
            children: [
              Container(
                  decoration: getBackgroundIfError(device.errors),
                  child: Padding(
                      padding: const EdgeInsets.only(
                          top: 12, bottom: 12, left: 25, right: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 12,
                                ),
                                child: SizedBox(
                                    height: 170,
                                    child: getModelImage(device.model)),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      child: TextFormField(
                                        initialValue: device.name,
                                        decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            suffixIcon: Icon(
                                              Icons.edit,
                                            ),
                                            suffixIconConstraints:
                                                BoxConstraints(
                                                    maxWidth: 24,
                                                    maxHeight: 24)),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 22),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Text(device.model),
                                    Text(
                                      device.serialNumber,
                                      style:
                                          TextStyle(color: CustomColors.grey),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    const Text("Installation date"),
                                    Text(device.installationDate),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    const Text("Last accessed"),
                                    Text(device.lastAccessDate),
                                    TextButton(
                                        onPressed: () {
                                          deleteDevice(documentID);
                                          Navigator.pop(context);
                                        },
                                        style: const ButtonStyle(
                                            padding: MaterialStatePropertyAll(
                                                EdgeInsets.zero)),
                                        child: Text(
                                          "Delete device",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: CustomColors.red,
                                              fontWeight: FontWeight.w700),
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Text(
                            getErrorText(device.errors),
                            style: TextStyle(
                                fontSize: 18,
                                color: CustomColors.red,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ))),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 16),
                    child: Text(
                      "Device statistics",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                          color: Colors.black38,
                          child: Padding(
                            padding: headerPadding,
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width - 32) /
                                          3 *
                                          2,
                                  child: const Text(
                                    "Total drinks made",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Text(
                                    '${device.coffeeBrewed + device.hotChocolateBrewed + device.teaBrewed}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          )),
                      Container(
                          color: Colors.black12,
                          child: Padding(
                            padding: nonHeaderPadding,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  44) /
                                              3 *
                                              2,
                                      child: const Text(
                                        "Coffee",
                                      ),
                                    ),
                                    Text(
                                      '${device.coffeeBrewed}',
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  44) /
                                              3 *
                                              2,
                                      child: const Text(
                                        "Tea",
                                      ),
                                    ),
                                    Text(
                                      '${device.teaBrewed}',
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  44) /
                                              3 *
                                              2,
                                      child: const Text(
                                        "Hot chocolate",
                                      ),
                                    ),
                                    Text(
                                      '${device.hotChocolateBrewed}',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Column(
                    children: [
                      Container(
                          color: Colors.black38,
                          child: Padding(
                            padding: headerPadding,
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width - 32) /
                                          3 *
                                          2,
                                  child: const Text(
                                    "Ingredients",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Container(
                          color: Colors.black12,
                          child: Padding(
                            padding: nonHeaderPadding,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  44) /
                                              3 *
                                              2,
                                      child: const Text(
                                        "Beans",
                                      ),
                                    ),
                                    Text(
                                      '${device.beansPerc}%',
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  44) /
                                              3 *
                                              2,
                                      child: const Text(
                                        "Milk",
                                      ),
                                    ),
                                    Text(
                                      '${device.milkPerc}%',
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  44) /
                                              3 *
                                              2,
                                      child: const Text(
                                        "Chocolate",
                                      ),
                                    ),
                                    Text(
                                      '${device.chocolatePerc}%',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ],
          )),
        ),
        appBar: getAppBar(context, pageTitle, moreMenuOptions, handleClick));
  }
}

Map<String, String> errorDescriptions = {
  "E3":
      "E3 Fill error: Boiler is filling up too slowly. Check the water pressure. Turn the water supply tap completely open. Check the connection tube for any kinks. Switch the machine off and on again.",
  "E5":
      "E5 Brewer error: Brewer error during start-up. Switch the machine off and on again. Contact the daeler of service engineer.",
  "E6":
      "E6 High temperature: Temperature sensor problem. Contact the dealer of service engineer",
  "E7":
      "E7 Brewer motor error: Brewer motor overload/stuck. Remove he brewer from the machine, clean and install the brewer correctly. Switch the machine off and on again. Use the brush to clean the brewer. Contact the dealer of service engineer.",
  "E8":
      "E8 Mixer 2 error: Mixer 2 overload/stuck. Remove the mixer from the machine, clean and install the mixer correctly. Switch the machine off and on again.",
  "E10":
      "E10 Valve error: Valve overload/stuck. Contact the dealer or service engineer.",
  "E11":
      "E11 Ingredient motor error: Ingredient motor overload/stuck. Clean the canisters. Switch the machine off and on again.",
  "E13":
      "E13 Mixer group error: Brewer and mixed group overload. Clean the mixer rotor. Switch the machine off and on again.",
  "E14":
      "E14 Output error: Outlet group of the ingredient motor overload. Clean the canisters. Switch the machine off and on again.",
  "E17":
      "E17 MDB error: There is no communication betewen the machine and MDB payment system. Switch the machine off and on again. Contact the dealer or service engineer.",
  "E18":
      "E18 Mixer group FET error: Brewer or mixer motor still active. Contact the dealer or service engineer.",
  "E19":
      "E19 Output FET error: Ingredient motor, valve or ventilation motor still active. Contact the dealer or service engineer.",
  "E20":
      "E20 Software error: Software error. Switch the machine off and on again. Contact the dealer or service engineer.",
  "E21":
      "E21 Boiler timeout: Boiler is not heating. Contact the dealer or service engineer.",
  "E22":
      "E22 Brew timeout: Brewer process too long. Switch the machine off and on again. Clean or rinse the machine. Contact the dealer or service engineer.",
  "E23":
      "E23 Inletvalve error: Inlet valve is leaking. Close the water tap. Contact the dealer or service engineer.",
  "E24":
      "E24 Brewer error: Brewer error during coffee making. Switch the machine off and on again. Contact the dealer or service engineer.",
  "E25":
      "E25 Flowmeter error: No water pressure, water tank is empty (if applicable). Check water pressure. Open the water supply. Check the water hose. Switch the machine off and on again.",
  "E26":
      "E26 Low temperature: Temperature sensor problem. Contact the dealer or service engineer.",
  "E27":
      "E27 NTC short circuit: Temperature sensor problem. Contact the dealer or service engineer.",
  "E28":
      "E28 NTC not detected: Temperature sensor problem. Contact the dealer or service engineer.",
};

String getErrorText(List<String> errors) {
  String errorText = "";
  StringBuffer sb = StringBuffer(errorText);
  for (var error in errors) {
    sb.write(errorDescriptions[error]);
  }
  return sb.toString();
}

Future<void> deleteDevice(String documentID) async {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  await _db.collection("Machines").doc(documentID).delete();
}

class Device {
  final String name;
  final String model;
  final String serialNumber;
  final List<String> errors;
  final String installationDate;
  final String lastAccessDate;
  final int coffeeBrewed;
  final int teaBrewed;
  final int hotChocolateBrewed;
  final int beansPerc;
  final int milkPerc;
  final int chocolatePerc;

  Device(
      this.name,
      this.model,
      this.serialNumber,
      this.errors,
      this.installationDate,
      this.lastAccessDate,
      this.coffeeBrewed,
      this.teaBrewed,
      this.hotChocolateBrewed,
      this.beansPerc,
      this.milkPerc,
      this.chocolatePerc);
}
