import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
  String? _selectedModel;
  String? currentUserEmail;
  List<String> modelList = [
    'Optibean 2 Touch',
    'Optibean 3 Touch',
    'Optibean 4 Touch'
  ];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserEmail = user.email;
      });
    }
  }

  void _submitUserData() async {
    if (_formKey.currentState!.validate()) {
      String zipCode = _zipCodeController.text;
      String machineName = _machineNameController.text;
      String? model =
          _selectedModel; // Replace _selectedModel with the selected value from the dropdown list
      String currentUser = currentUserEmail ?? '';

      String installationDate = DateTime.now().toString().split(' ')[0];
      String lastTimeAccess = DateTime.now().toString().split(' ')[0];

      try {
        await FirebaseDatabase.instance
            .reference()
            .child('Machines')
            .push()
            .set({
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
          'TeaBrewed': '',
          'User': currentUser,
          'ZipCode': zipCode,
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddNewDevicePage(),
          ),
        );
      } catch (error) {
        print('Error submitting user data: $error');
      }
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
