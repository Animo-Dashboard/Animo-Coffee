import 'package:animo/reuseWidgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MachineSpecsPage extends StatefulWidget {
  @override
  _MachineSpecsPageState createState() => _MachineSpecsPageState();
}

class _MachineSpecsPageState extends State<MachineSpecsPage> {
  String pageTitle = 'Machine Specifications Page';

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
      model = model?.toLowerCase();
      if (model != null && !models.contains(model)) {
        switch (model) {
          case "touch2":
            if (!models.contains("optibean 2 touch")) {
              models.add("optibean 2 touch");
            }
            break;
          case "touch3":
            if (!models.contains("optibean 3 touch")) {
              models.add("optibean 3 touch");
            }
            break;
          case "touch4":
            if (!models.contains("optibean 4 touch")) {
              models.add("optibean 4 touch");
            }
            break;
          default:
            models.add(model);
            break;
        }
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
      showAccordions = false;
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
      machineModels.add(customModel!);
      selectedModel = customModel;
      fetchMachineSpecs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, pageTitle),
      body: Container(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        decoration: getAppBackground(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(contentPadding: EdgeInsets.zero),
                  menuMaxHeight: 400,
                  isExpanded: true,
                  value: selectedModel,
                  items: [
                    ...machineModels.map((model) {
                      return DropdownMenuItem<String>(
                        value: model,
                        child: Text(model),
                      );
                    }),
                    const DropdownMenuItem<String>(
                      value: 'not-found',
                      child:
                          Text("Can't find the machine you are looking for?"),
                    ),
                  ],
                  onChanged: selectModel,
                ),
              ),
              if (selectedModel == 'not-found')
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            customModel = value;
                          });
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(top: 0),
                          labelText: 'Custom Model',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: confirmCustomModel,
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: fetchMachineSpecs,
                child: const Text('Retrieve Specs'),
              ),
              const SizedBox(
                height: 20,
              ),
              if (showAccordions)
                Column(
                  children: columnNames.map((columnName) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ExpansionTile(
                        collapsedBackgroundColor: Colors.black26,
                        backgroundColor: Colors.black26,
                        textColor: Colors.black,
                        iconColor: Colors.black,
                        title: Text(columnName),
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration:
                                const BoxDecoration(color: Colors.white54),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                '${columnValues[columnName]}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              if (noSpecsFound)
                Text('No specifications found for the ${selectedModel ?? ""}'),
            ],
          ),
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
