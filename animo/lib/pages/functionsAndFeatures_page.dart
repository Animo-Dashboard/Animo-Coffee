import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MachineSpecsPage extends StatefulWidget {
  @override
  _MachineSpecsPageState createState() => _MachineSpecsPageState();
}

class _MachineSpecsPageState extends State<MachineSpecsPage> {
  DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child("MachineSpecs");
  Map<String, dynamic> _machineSpecs = {};

  @override
  void initState() {
    super.initState();
    _fetchMachineSpecs();
  }

  void _fetchMachineSpecs() {
    _databaseReference.once().then((DataSnapshot snapshot) {
          if (snapshot.value != null) {
            setState(() {
              _machineSpecs = Map<String, dynamic>.from(
                  snapshot.value as Map<dynamic, dynamic>);
            });
          }
        } as FutureOr Function(DatabaseEvent value));
  }

  Widget _buildAccordion(String columnName, dynamic columnValue) {
    return ExpansionTile(
      title: Text(columnName),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(columnValue.toString()),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Machine Specs'),
      ),
      body: ListView(
        children: _machineSpecs.entries.map((entry) {
          return _buildAccordion(entry.key, entry.value);
        }).toList(),
      ),
    );
  }
}
