import 'package:animo/pages/MaintenanceSelection_page.dart';
import 'package:animo/pages/machineSpecs_page.dart';
import 'package:flutter/material.dart';
import 'package:animo/inAppFunctions.dart';
import 'package:animo/reuseWidgets.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String pageTitle = "Admin";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, pageTitle),
      body: Container(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
              minWidth: MediaQuery.of(context).size.width),
          decoration: getAppBackground(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/dashboard');
                  },
                  child: Text(
                    'DASHBOARD',
                  )),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/machineSpecs',
                  );
                },
                child: Text('Go to Machine Page'),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MaintenanceSelectionPage(),
                    ),
                  );
                },
                child: Text('Go to Maintenance Selection'),
              ),
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
