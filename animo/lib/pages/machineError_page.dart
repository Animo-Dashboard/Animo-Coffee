import 'package:animo/reuseWidgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class MachineErrorPage extends StatefulWidget {
  @override
  _MachineErrorPageState createState() => _MachineErrorPageState();
}

class _MachineErrorPageState extends State<MachineErrorPage> {
  CollectionReference machinesCollection =
      FirebaseFirestore.instance.collection('Machines');

  @override
  Widget build(BuildContext context) {
    final arguments =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ??
            {};

    final user = arguments["User"].toString().toLowerCase();
    final role = arguments["Role"].toString().toLowerCase();

    return Scaffold(
      appBar: getAppBar(context, "Machine Errors"),
      body: Container(
        decoration: getAppBackground(),
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'New Errors',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              getErrorStreamBuilder(machinesCollection, "Error", user, role),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Current Errors',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              getErrorStreamBuilder(
                  machinesCollection, "CurrentError", user, role),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> moveToCurrentErrors(String machineId) async {
    try {
      // Get the document reference for the machine
      final machineDoc = machinesCollection.doc(machineId);

      // Fetch the current error value
      final machineSnapshot = await machineDoc.get();
      final machineData = machineSnapshot.data() as Map<String, dynamic>?;

      if (machineData != null) {
        final currentErrors = machineData['CurrentError'] ?? [];
        final error = machineData['Error'];

        // Update the document to move the machine to current errors list
        await machineDoc.update({
          'CurrentError': FieldValue.arrayUnion([error]),
          'Error': FieldValue.delete(),
        });
      }
    } catch (error) {
      print('Error moving machine to current errors: $error');
    }
  }
}
