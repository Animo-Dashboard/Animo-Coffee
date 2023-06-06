import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MachineSpecsPage extends StatefulWidget {
  @override
  _MachineSpecsPageState createState() => _MachineSpecsPageState();
}

class _MachineSpecsPageState extends State<MachineSpecsPage> {
  final CollectionReference machinesCollection =
      FirebaseFirestore.instance.collection('Machines');
  final CollectionReference specsCollection =
      FirebaseFirestore.instance.collection('MachineSpecs');

  List<String> machineModels = [];
  String? selectedModel;
  String? customModel;
  List<String> columnNames = [];
  Map<String, dynamic> columnValues = {};
  bool showAccordions = false;
  bool noSpecsFound = false;

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
      noSpecsFound = false;
    });
  }

  void fetchMachineSpecs() async {
    if (selectedModel != null) {
      columnNames.clear();
      columnValues.clear();

      QuerySnapshot snapshot = await specsCollection
          .where('Name', isEqualTo: selectedModel)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> data =
            snapshot.docs[0].data() as Map<String, dynamic>;

        setState(() {
          columnNames = data.keys.toList();
          columnValues = data;
          showAccordions = true;
          noSpecsFound = false;
        });
      } else {
        setState(() {
          noSpecsFound = true;
        });
      }
    }
  }

  void confirmCustomModel() {
    if (customModel != null && customModel!.isNotEmpty) {
      selectedModel = customModel;
      fetchMachineSpecs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Machine Specifications Page'),
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
            ElevatedButton(
              onPressed: fetchMachineSpecs,
              child: Text('Retrieve Machine Specs'),
            ),
            SizedBox(height: 20),
            if (showAccordions)
              Column(
                children: columnNames.map((columnName) {
                  return ExpansionTile(
                    title: Text(columnName),
                    children: [
                      Text('${columnValues[columnName]}'),
                    ],
                  );
                }).toList(),
              ),
            SizedBox(height: 20),
            if (noSpecsFound)
              Text('No specifications found for the ${selectedModel ?? ""}'),
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
