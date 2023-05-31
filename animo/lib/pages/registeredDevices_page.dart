import 'dart:math';

import 'package:animo/reuseWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animo/inAppFunctions.dart';
import 'DeviceInstallationPage .dart';
import 'addNewDevice_page.dart';

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

  List<String> moreMenuOptions = ['Add new device', 'Settings', 'Log out'];
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
    }
  }

  Future<void> getMachines() async {
    devices.clear();
    await _db.collection("Machines").get().then((event) {
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
      moreMenuOptions = ['Add new device', 'Admin', 'Settings', 'Log out'];
    }
    if (devices.isEmpty) {
      getMachines();
    }

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await getMachines();
          },
          backgroundColor: CustomColors.blue,
          child: const Icon(Icons.plus_one),
        ),
        body: Container(
            decoration: getAppBackground(),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: sqrt1_2),
              itemBuilder: (context, index) {
                final device = devices[index].data() as Map<String, dynamic>;
                final model = device["Model"];
                final name = device["Name"];
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
                              Image(
                                image: AssetImage("images/$model.png"),
                                height: 170,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                name,
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(model,
                                  style: const TextStyle(
                                      fontSize: 16,
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
