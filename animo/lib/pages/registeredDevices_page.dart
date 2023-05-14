import 'package:animo/reuseWidgets.dart';
import 'package:flutter/material.dart';
import 'package:animo/inAppFunctions.dart';

class RegisteredDevicesPage extends StatefulWidget {
  const RegisteredDevicesPage({super.key});

  @override
  _RegisteredDevicesPage createState() => _RegisteredDevicesPage();
}

class _RegisteredDevicesPage extends State<RegisteredDevicesPage> {
  final _formKey = GlobalKey<FormState>();
  String pageTitle = "Your devices";

  List<String> moreMenuOptions = ['Add new device', 'Settings', 'Log out'];
  void handleClick(String value) {
    switch (value) {
      case 'Add new device':
        break;
      case 'Settings':
        break;
      case 'Log out':
        logOut(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: getAppBackground(),
        ),
        appBar: getAppBar(context, moreMenuOptions, pageTitle, handleClick));
  }
}
