import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

enum FieldValidationState { empty, valid, invalid }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FieldValidationState _emailFieldState = FieldValidationState.empty;
  FieldValidationState _passwordFieldState = FieldValidationState.empty;

  String _email = "";
  String _password = "";

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        print('Login successful!');
        print('Email: ${userCredential.user!.email}');
        // Add Navigation to a different page
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          print('Invalid email or password.');
        } else {
          print('Login error: ${e.message}');
        }
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
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.5), BlendMode.dstATop),
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
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
