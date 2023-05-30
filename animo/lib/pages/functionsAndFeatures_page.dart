import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class functionsAndFeaturesPage extends StatefulWidget {
  @override
  _functionsAndFeaturesPageState createState() =>
      _functionsAndFeaturesPageState();
}

class _functionsAndFeaturesPageState extends State<functionsAndFeaturesPage> {
  DatabaseReference _databaseReferenceMachineSpecs =
      FirebaseDatabase.instance.ref().child("MachineSpecs");
  DatabaseReference _databaseReferenceMachines =
      FirebaseDatabase.instance.ref().child("Machines");
  Map<String, dynamic> _machineSpecs = {};
  List<String> _machineModels = [];
  String _selectedModel = '';
  String _searchedName = '';
  TextEditingController _manualSearchController = TextEditingController();
  bool _showNotFoundMessage = false;

  @override
  void initState() {
    super.initState();
    _fetchMachineSpecs();
    _fetchMachineModels();
  }

  void _fetchMachineSpecs() {
    _databaseReferenceMachineSpecs.once().then((DataSnapshot snapshot) {
          if (snapshot.value != null) {
            setState(() {
              _machineSpecs = Map<String, dynamic>.from(
                  snapshot.value as Map<dynamic, dynamic>);
            });
          }
        } as FutureOr Function(DatabaseEvent value));
  }

  void _fetchMachineModels() {
    _databaseReferenceMachines.once().then((DataSnapshot snapshot) {
          if (snapshot.value != null) {
            setState(() {
              List<dynamic> machineModelsList = snapshot.value as List<dynamic>;
              _machineModels =
                  machineModelsList.map((model) => model.toString()).toList();
              _machineModels.add("Can't find the machine you're looking for?");
            });
          }
        } as FutureOr Function(DatabaseEvent value));
  }

  void _searchMachine() {
    setState(() {
      _selectedModel = '';
      _searchedName = '';
      _showNotFoundMessage = false;
    });

    if (_selectedModel.isNotEmpty) {
      if (_selectedModel == "Can't find the machine you're looking for?") {
        String manualSearchName = _manualSearchController.text;
        _searchByName(manualSearchName);
      } else {
        _searchByName(_selectedModel);
      }
    }
  }

  void _searchByName(String name) {
    bool found = false;
    _machineSpecs.forEach((_, value) {
      if (value['Name'] == name) {
        setState(() {
          _searchedName = name;
        });
        found = true;
        return;
      }
    });

    if (!found) {
      setState(() {
        _showNotFoundMessage = true;
      });
    }
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

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    return _machineModels.map((String model) {
      return DropdownMenuItem<String>(
        value: model,
        child: Text(model),
      );
    }).toList();
  }

  Widget _buildManualSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: _manualSearchController,
        decoration: InputDecoration(
          labelText: 'Enter machine name',
        ),
      ),
    );
  }

  List<Widget> _buildMachineSpecs() {
    if (_searchedName.isEmpty) {
      return [];
    } else {
      List<Widget> accordions = [];
      _machineSpecs.forEach((key, value) {
        if (value['Name'] == _searchedName) {
          value.forEach((columnName, columnValue) {
            accordions.add(_buildAccordion(columnName, columnValue));
          });
        }
      });
      return accordions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Machine Specs'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: _selectedModel,
              items: _buildDropdownItems(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedModel = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Select machine model',
              ),
            ),
          ),
          if (_selectedModel == "Can't find the machine you're looking for?")
            _buildManualSearchField(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: _searchMachine,
              child: Text('Search'),
            ),
          ),
          if (_showNotFoundMessage)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                "Can't find a machine with the name: $_selectedModel",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          Expanded(
            child: ListView(
              children: _buildMachineSpecs(),
            ),
          ),
        ],
      ),
    );
  }
}
