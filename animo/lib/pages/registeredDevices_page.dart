import 'dart:math';
import 'package:animo/reuseWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animo/inAppFunctions.dart';

class RegisteredDevicesPage extends StatefulWidget {
  const RegisteredDevicesPage({Key? key}) : super(key: key);

  @override
  _RegisteredDevicesPageState createState() => _RegisteredDevicesPageState();
}

class _RegisteredDevicesPageState extends State<RegisteredDevicesPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<DocumentSnapshot> devices = [];
  String pageTitle = "Your devices";
  String user = "";
  String role = "";
  List<String> moreMenuOptions = ['Settings', 'Log out', 'All errors'];

  void handleClick(String value) {
    switch (value) {
      case 'Log out':
        logOut(context);
        break;
      case 'Add new device':
        Navigator.pushNamed(context, '/addNewDevice');
        break;
      case 'Admin':
        Navigator.pushNamed(context, '/admin');
        break;
      case 'All errors':
        Navigator.pushNamed(context, '/machineErrors', arguments: {
          "User": user,
          "Role": role,
        });
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
    final arguments =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ??
            {};

    role = arguments["role"].toString().toLowerCase();
    user = arguments["email"].toString().toLowerCase();

    if (role == "admin") {
      moreMenuOptions = ['Add new device', 'Admin', 'All errors', 'Log out'];
    } else if (role == "dealer") {
      moreMenuOptions = ['Add new device', 'Log out', 'All errors'];
    } else {
      moreMenuOptions = ['Log out', 'All errors'];
    }

    if (devices.isEmpty) {
      getMachines(user);

      _db
          .collection("Machines")
          .where("User", isEqualTo: user)
          .snapshots()
          .listen((event) {
        devices = event.docs;
      });
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: CustomColors.blue,
          child: const Icon(Icons.refresh),
          onPressed: () {
            setState(() {});
          }),
      body: Container(
        decoration: getAppBackground(),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: sqrt1_2,
          ),
          itemBuilder: (context, index) {
            var device = devices[index].data() as Map<String, dynamic>;
            var documentId = devices[index].id;
            var model = device["Model"];
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
            var name = device["Name"] as String;
            if (name.length >= 15) {
              name = "${name.substring(0, 12)}...";
            }
            String newError = device["Error"] ?? "";
            List<String> currentErrors = [];
            List<dynamic> currentErrorFromDatabase =
                device["CurrentError"] ?? [];
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

            return GridTile(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/deviceStatistics',
                      arguments: {"device": device, "id": documentId});
                },
                child: Container(
                  decoration: getBackgroundIfError(errors),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 160),
                        child: getModelImage(model),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        model,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: devices.length,
        ),
      ),
      appBar: getAppBar(context, pageTitle, moreMenuOptions, handleClick),
    );
  }
}
