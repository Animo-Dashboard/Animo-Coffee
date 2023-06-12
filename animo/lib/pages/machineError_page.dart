import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'deviceStatistics_page.dart';
import 'notificationService.dart';

class MachineErrorPage extends StatefulWidget {
  @override
  _MachineErrorPageState createState() => _MachineErrorPageState();
}

class _MachineErrorPageState extends State<MachineErrorPage> {
  CollectionReference machinesCollection =
      FirebaseFirestore.instance.collection('Machines');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Machine Errors'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'New Errors',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: machinesCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final machines = snapshot.data?.docs ?? [];

                // Filter machines with new errors
                final machinesWithNewErrors = machines
                    .where((machine) =>
                        (machine.data() as Map<String, dynamic>?)
                            ?.containsKey('Error') ??
                        false)
                    .toList();

                if (machinesWithNewErrors.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'No new errors found.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: machinesWithNewErrors.length,
                  itemBuilder: (context, index) {
                    final machine = machinesWithNewErrors[index];

                    return ListTile(
                      title: Text(
                        (machine.data() as Map<String, dynamic>)['Name'] ?? '',
                      ),
                      subtitle: Text(
                        (machine.data() as Map<String, dynamic>)['Error'] ?? '',
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          moveToCurrentErrors(machine.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DeviceStatisticsPage(),
                              settings: RouteSettings(
                                arguments: {
                                  'device': machine.data(),
                                },
                              ),
                            ),
                          );
                        },
                        child: const Text('Go to Machine'),
                      ),
                    );
                  },
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Current Errors',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: machinesCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final machines = snapshot.data?.docs ?? [];

                // Filter machines with current errors
                final machinesWithCurrentErrors = machines
                    .where((machine) =>
                        (machine.data() as Map<String, dynamic>?)
                            ?.containsKey('CurrentError') ??
                        false)
                    .toList();

                if (machinesWithCurrentErrors.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'No current errors found.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: machinesWithCurrentErrors.length,
                  itemBuilder: (context, index) {
                    final machine = machinesWithCurrentErrors[index];
                    final currentErrors =
                        (machine.data() as Map<String, dynamic>)['CurrentError']
                            as List<dynamic>;

                    return ListTile(
                      title: Text(
                        (machine.data() as Map<String, dynamic>)['Name'] ?? '',
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          currentErrors.length,
                          (index) => Text(currentErrors[index].toString()),
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DeviceStatisticsPage(),
                              settings: RouteSettings(
                                arguments: {
                                  'device': machine.data(),
                                },
                              ),
                            ),
                          );
                        },
                        child: const Text('Go to Machine'),
                      ),
                    );
                  },
                );
              },
            ),
          ],
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
