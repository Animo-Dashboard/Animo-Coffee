import 'package:animo/reuseWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animo/inAppFunctions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceStatisticsPage extends StatefulWidget {
  const DeviceStatisticsPage({super.key});

  @override
  _DeviceStatisticsPage createState() => _DeviceStatisticsPage();
}

class _DeviceStatisticsPage extends State<DeviceStatisticsPage> {
  final _formKey = GlobalKey<FormState>();
  FirebaseFirestore _db = FirebaseFirestore.instance;
  String pageTitle = "Page";
  Device device = Device('name', 'model', "serialNumber", "", Timestamp.now(),
      Timestamp.now(), 0, 0, 0, 0, 0, 0);

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    try {
      var data = arguments["device"];
      device = Device(
        data["Name"] as String? ?? "Default Name",
        data["Model"] as String? ?? "Default Model",
        data["SerialNumber"] as String? ?? "Default Serial Number",
        data["Error"] as String? ?? "",
        data["InstallationDate"] as Timestamp? ?? Timestamp.now(),
        data["LastTimeAccess"] as Timestamp? ?? Timestamp.now(),
        data["CoffeeBrewed"] as int? ?? 0,
        data["TeaBrewed"] as int? ?? 0,
        data["HotChocolateBrewed"] as int? ?? 0,
        data["Beans"] as int? ?? 0,
        data["Milk"] as int? ?? 0,
        data["Chocolate"] as int? ?? 0,
      );
    } catch (e) {
      print("whoopsie device couldn't be gotten :'3");
      print(e);
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            decoration: getAppBackground(),
            child: Column(
              children: [
                Container(
                    decoration: getBackgroundIfError(),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 12, bottom: 12, left: 25, right: 25),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 12,
                            ),
                            child: SizedBox(
                                height: 170,
                                child: Image.asset(
                                  "images/${device.model}.png",
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Image.asset(
                                        "images/touch2.png"); // Fallback image
                                  },
                                )),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                        suffixIconConstraints: BoxConstraints(
                                            maxWidth: 24, maxHeight: 24)),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 22),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                Expanded(
                    child: Column(
                  children: [
                    const Text("Statistics"),
                    Container(
                      child: Column(
                        children: [],
                      ),
                    )
                  ],
                )),
              ],
            )),
        appBar: getAppBar(
          context,
          pageTitle,
        ));
  }

  getBackgroundIfError() {
    if (device.error.isNotEmpty) {
      return BoxDecoration(
        color: CustomColors.red.withAlpha(50),
        border: Border.all(
          color: CustomColors.red,
          width: 2.0,
        ),
      );
    } else {
      return const BoxDecoration();
    }
  }
}

class Device {
  final String name;
  final String model;
  final String serialNumber;
  final String error;
  final Timestamp installationDate;
  final Timestamp lastAccessDate;
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
      this.error,
      this.installationDate,
      this.lastAccessDate,
      this.coffeeBrewed,
      this.teaBrewed,
      this.hotChocolateBrewed,
      this.beansPerc,
      this.milkPerc,
      this.chocolatePerc);
}
