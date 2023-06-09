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
    return Scaffold(
      appBar: AppBar(
        title: Text('Machine Errors'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'New Errors',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: machinesCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final machines = snapshot.data?.docs ?? [];

                // Filter machines with error
                final machinesWithError = machines
                    .where((machine) =>
                        (machine.data() as Map<String, dynamic>?)
                            ?.containsKey('Error') ??
                        false)
                    .toList();

                return ListView.builder(
                  itemCount: machinesWithError.length,
                  itemBuilder: (context, index) {
                    final machine = machinesWithError[index];

                    return ListTile(
                      title: Text(
                          (machine.data() as Map<String, dynamic>)['Name'] ??
                              ''),
                      subtitle: Text(
                          (machine.data() as Map<String, dynamic>)['Error'] ??
                              ''),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
