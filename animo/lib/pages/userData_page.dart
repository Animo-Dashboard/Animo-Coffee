import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../inAppFunctions.dart';
import '../reuseWidgets.dart';
import 'addNewDevice_page.dart';

class UserDataPage extends StatefulWidget {
  final DeviceItem deviceItem;

  const UserDataPage({
    Key? key,
    required this.deviceItem,
  }) : super(key: key);

  @override
  _UserDataPageState createState() => _UserDataPageState();
}

class _UserDataPageState extends State<UserDataPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _machineNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedModel;
  List<String> modelList = [
    'Optibean 2 Touch',
    'Optibean 3 Touch',
    'Optibean 4 Touch'
  ];

  void _submitUserData() async {
    if (_formKey.currentState!.validate()) {
      String zipCode = _zipCodeController.text;
      String machineName = _machineNameController.text;
      String? model = _selectedModel;
      String email = _emailController.text;

      String installationDate = DateTime.now().toString().split(' ')[0];
      String lastTimeAccess = DateTime.now().toString().split(' ')[0];

      try {
        // Save the machine data to Firestore
        await FirebaseFirestore.instance.collection('Machines').add({
          'BeansPerc': '',
          'ChocolatePerc': '',
          'CoffeeBrewed': '',
          'HotChocolateBrewed': '',
          'InstallationDate': installationDate,
          'LastTimeAccess': lastTimeAccess,
          'MilkPerc': '',
          'Model': model,
          'Name': machineName,
          'Status': 'Ready for use',
          'User': email,
          'ZipCode': zipCode,
        });
      } catch (error) {
        print('Error submitting user data: $error');
      }

      // Redirect to the next page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddNewDevicePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, 'User Data', [], null),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _zipCodeController,
                decoration: const InputDecoration(labelText: 'Zip Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a zip code';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _machineNameController,
                decoration: const InputDecoration(labelText: 'Machine Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a machine name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedModel,
                onChanged: (newValue) {
                  setState(() {
                    _selectedModel = newValue;
                  });
                },
                items: modelList.map((model) {
                  return DropdownMenuItem<String>(
                    value: model,
                    child: Text(model),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Select Model'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a model';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _submitUserData,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
