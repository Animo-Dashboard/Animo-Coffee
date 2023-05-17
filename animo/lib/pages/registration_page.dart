import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum FieldValidationState { empty, valid, invalid }

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  FieldValidationState _emailFieldState = FieldValidationState.empty;
  FieldValidationState _passwordFieldState = FieldValidationState.empty;

  String _email = "";
  String _password = "";

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, do registration logic here
      try {
        // Create a new user with the entered email and password
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // Save the user's email and password to Firestore
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userCredential.user!.uid)
            .set({
          'email': _email,
          'password': _password,
        });

        print('Registration successful!');
      } catch (e) {
        print('Registration failed: $e');
      }
    }
  }

  void _validateEmail(String value) {
    setState(() {
      _emailFieldState = EmailValidator.validate(value)
          ? FieldValidationState.valid
          : FieldValidationState.invalid;
      _email = value;
    });
  }

  void _validatePassword(String value) {
    setState(() {
      _passwordFieldState = value.isNotEmpty
          ? FieldValidationState.valid
          : FieldValidationState.empty;
      _password = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    } else if (_emailFieldState ==
                        FieldValidationState.invalid) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onChanged: _validateEmail,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    } else if (_passwordFieldState ==
                        FieldValidationState.empty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                  onChanged: _validatePassword,
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
