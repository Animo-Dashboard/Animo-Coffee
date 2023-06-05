import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MachineSpecsPage extends StatefulWidget {
  @override
  _MachineSpecsPageState createState() => _MachineSpecsPageState();
}

class _MachineSpecsPageState extends State<MachineSpecsPage> {
  final CollectionReference machinesCollection =
      FirebaseFirestore.instance.collection('Machines');

  List<String> machineModels = [];
  String? selectedModel;
  String? customModel;

  @override
  void initState() {
    super.initState();
    getMachineModels();
  }

  Future<void> getMachineModels() async {
    QuerySnapshot snapshot = await machinesCollection.get();
    List<String> models = [];

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String? model = data['Model'] as String?;
      if (model != null && !models.contains(model)) {
        models.add(model);
      }
    }

    setState(() {
      machineModels = models;
    });
  }

  void selectModel(String? value) {
    setState(() {
      selectedModel = value;
    });
  }

  void confirmCustomModel() {
    if (customModel != null && customModel!.isNotEmpty) {
      // Process the custom model here as needed
      print('Custom Model: $customModel');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Machine Dropdown Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField<String>(
              value: selectedModel,
              items: [
                ...machineModels.map((model) {
                  return DropdownMenuItem<String>(
                    value: model,
                    child: Text(model),
                  );
                }),
                DropdownMenuItem<String>(
                  value: 'not-found',
                  child: Text("Can't find the machine you are looking for?"),
                ),
              ],
              onChanged: selectModel,
            ),
            SizedBox(height: 20),
            if (selectedModel == 'not-found')
              Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        customModel = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Custom Model',
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: confirmCustomModel,
                    child: Text('Confirm'),
                  ),
                ],
              ),
            SizedBox(height: 20),
            Text('Selected Model: ${selectedModel ?? ""}'),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MachineSpecsPage(),
  ));
}
