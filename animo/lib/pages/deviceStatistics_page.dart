import 'package:animo/reuseWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animo/inAppFunctions.dart';

class DeviceStatisticsPage extends StatefulWidget {
  const DeviceStatisticsPage({super.key});

  @override
  _DeviceStatisticsPage createState() => _DeviceStatisticsPage();
}

class _DeviceStatisticsPage extends State<DeviceStatisticsPage> {
  final _formKey = GlobalKey<FormState>();
  String pageTitle = "Page";
  Device device = Device('name', 'model', "serialNumber", "", Timestamp.now(),
      Timestamp.now(), 0, 0, 0, 0, 0, 0);
  EdgeInsets headerPadding =
      const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16);
  EdgeInsets nonHeaderPadding =
      const EdgeInsets.only(left: 28, right: 16, top: 5, bottom: 8);

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    try {
      var data = arguments["device"];
      pageTitle = data["Name"];
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
          height: MediaQuery.of(context).size.height,
          decoration: getAppBackground(),
          child: SingleChildScrollView(
              child: Column(
            children: [
              Container(
                  decoration: getBackgroundIfError(device.error),
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
                                    Text(DateTime.fromMillisecondsSinceEpoch(
                                            device.installationDate
                                                .millisecondsSinceEpoch)
                                        .toString()),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    const Text("Last accessed"),
                                    Text(DateTime.fromMillisecondsSinceEpoch(
                                            device.lastAccessDate
                                                .millisecondsSinceEpoch)
                                        .toString()),
                                    TextButton(
                                        onPressed: () {
                                          //TODO: delete device
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
                            device.error,
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
        appBar: getAppBar(
          context,
          pageTitle,
        ));
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
