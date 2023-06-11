import 'dart:math';

import 'package:animo/reuseWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animo/inAppFunctions.dart';
import 'DeviceInstallationPage .dart';
import 'addNewDevice_page.dart';
import 'machineError_page.dart';

class RegisteredDevicesPage extends StatefulWidget {
  const RegisteredDevicesPage({super.key});

  @override
  _RegisteredDevicesPage createState() => _RegisteredDevicesPage();
}

class _RegisteredDevicesPage extends State<RegisteredDevicesPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<DocumentSnapshot> devices = [];
  String pageTitle = "Your devices";

  List<String> moreMenuOptions = [
    'Add new device',
    'Settings',
    'Log out',
    'All errors'
  ];
  void handleClick(String value) {
    switch (value) {
      case 'Add new device':
        Navigator.pushNamed(context, '/addNewDevice');
        break;
      case 'Settings':
        break;
      case 'Log out':
        logOut(context);
        break;
      case 'Admin':
        Navigator.pushNamed(context, '/admin');
        break;
      case 'All errors':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MachineErrorPage(),
          ),
        );
        break;
    }
  }

  Future<void> getMachines(String email) async {
    devices.clear();
    await _db
        .collection("Machines")
        .where("User", isEqualTo: email)
        .get()
        .then((event) {
      setState(() {
        devices = event.docs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    if (arguments["role"].toString().toLowerCase() == "admin") {
      moreMenuOptions = [
        'Add new device',
        'Admin',
        'Settings',
        'Log out',
        'All errors'
      ];
    }
    if (devices.isEmpty) {
      getMachines(arguments["email"]);
    }

    _db
        .collection("Machines")
        .where("User", isEqualTo: arguments["email"])
        .snapshots()
        .listen((event) {
      devices.addAll(event.docs);
    });

    return Scaffold(
        body: Container(
            decoration: getAppBackground(),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: sqrt1_2),
              itemBuilder: (context, index) {
                final device = devices[index].data() as Map<String, dynamic>;
                final model = device["Model"];
                var name = device["Name"] as String;
                if (name.length >= 15) {
                  name = "${name.substring(0, 12)}...";
                }
                final error = device["Error"] ?? "";
                return GridTile(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/deviceStatistics',
                              arguments: {"device": device});
                        },
                        child: Container(
                          decoration: getBackgroundIfError(error),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                constraints: BoxConstraints(maxHeight: 160),
                                child: getModelImage(model),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(model,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300))
                            ],
                          ),
                        )));
              },
              itemCount: devices.length,
            )),
        appBar: getAppBar(context, pageTitle, moreMenuOptions, handleClick));
  }
}
