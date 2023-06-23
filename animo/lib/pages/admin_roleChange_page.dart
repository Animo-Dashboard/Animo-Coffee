import 'package:animo/reuseWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AssignRolePage extends StatefulWidget {
  @override
  AssignRolePageState createState() => AssignRolePageState();
}

class AssignRolePageState extends State<AssignRolePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  String _selectedRole = 'admin';
  List<String> _roleList = ['dealer', 'admin', 'user'];

  void _assignRole() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;

      try {
        // Check if the user document exists before updating the role
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('email', isEqualTo: email)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          // Update the user's role in the Firestore entry
          DocumentReference userDocRef = userSnapshot.docs.first.reference;
          await userDocRef.update({'role': _selectedRole});
          print('Role assigned successfully.');
        } else {
          print('User with email $email does not exist.');
        }
      } catch (error) {
        print('Error assigning role: $error');
      }

      await Future.delayed(Duration(seconds: 5));
      Navigator.pop(context); // Return to the previous page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "Assign role"),
      body: Container(
        decoration: getAppBackground(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'User Email',
                    hintText: 'Enter the email of the user',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedRole = newValue!;
                    });
                  },
                  items: _roleList.map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Role',
                    hintText: 'Select the role',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _assignRole,
                  child: Text('Assign Role'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
