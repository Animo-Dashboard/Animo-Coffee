import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      String adminEmail = FirebaseAuth.instance.currentUser!.email!;

      try {
        await FirebaseFirestore.instance.collection('Machines').add({
          'BeansPerc': 0,
          'ChocolatePerc': 0,
          'CoffeeBrewed': 0,
          'HotChocolateBrewed': 0,
          'InstallationDate': installationDate,
          'LastTimeAccess': lastTimeAccess,
          'MilkPerc': 0,
          'Model': model,
          'Name': machineName,
          'Status': 'Ready for use',
          'User': email,
          'ZipCode': zipCode,
          'TeaBrewed': 0,
          'AdminEmail': adminEmail,
        });
      } catch (error) {
        print('Error submitting user data: $error');
      }
      Navigator.popUntil(context, ModalRoute.withName('/addNewDevice'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, 'User Data', [], null),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _zipCodeController,
                  decoration: InputDecoration(
                    labelText: 'Zip Code',
                    hintText: 'Enter your zip code',
                    helperText: 'We use this to check water pH levels',
                    helperStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a zip code';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _machineNameController,
                  decoration: InputDecoration(
                    labelText: 'Machine Name',
                    hintText: 'Enter the name of the machine',
                    helperText:
                        'Choose a unique name for your customers machine',
                    helperStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a machine name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your customers email',
                    helperText:
                        'We need your customer email for identification',
                    helperStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
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
                  decoration: InputDecoration(
                    labelText: 'Select Model',
                    hintText: 'Choose the model of the machine',
                    helperText: 'Select the appropriate model from the list',
                    helperStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
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
      ),
    );
  }
}
