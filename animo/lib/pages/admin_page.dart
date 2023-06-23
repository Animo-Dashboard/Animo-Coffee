import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animo/reuseWidgets.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String pageTitle = "Admin";

  Future<String> getCurrentUserRole() async {
    final String? currentUser = FirebaseAuth.instance.currentUser?.email;
    if (currentUser != null) {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: currentUser)
          .limit(1)
          .get();
      final String userRole = querySnapshot.docs[0].get('role') ?? '';
      return userRole;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getCurrentUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: getAppBar(context, pageTitle),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          final String userRole = snapshot.data!;

          if (userRole != "admin") {
            return Scaffold(
              appBar: getAppBar(context, pageTitle),
              body: const Center(
                child: Text(
                  "Access Denied",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            );
          }
        }

        return Scaffold(
          appBar: getAppBar(context, pageTitle),
          body: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
              minWidth: MediaQuery.of(context).size.width,
            ),
            decoration: getAppBackground(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/dashboard');
                  },
                  child: const Text('DASHBOARD'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/machineSpecs');
                  },
                  child: const Text('MACHINE PAGE'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/api');
                  },
                  child: const Text('ZIP SEARCH'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/roleChange');
                  },
                  child: const Text('ROLE MANAGE'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
