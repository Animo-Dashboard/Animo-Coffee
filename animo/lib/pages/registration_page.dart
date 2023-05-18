import 'package:animo/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum FieldValidationState { empty, valid, invalid }

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  FieldValidationState _emailFieldState = FieldValidationState.empty;
  FieldValidationState _passwordFieldState = FieldValidationState.empty;
  FieldValidationState _passwordRepeatFieldState = FieldValidationState.empty;

  String _email = "";
  String _password = "";
  String _passwordRepeat = "";

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
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

  void _validateRepeatPassword(String value) {
    setState(() {
      _passwordRepeatFieldState == _passwordFieldState
          ? _passwordRepeatFieldState = FieldValidationState.valid
          : _passwordRepeatFieldState = FieldValidationState.invalid;
      _passwordRepeat = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 48),
      ),
      body: Container(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('images/background.jpeg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.5), BlendMode.dstATop),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 24, right: 24),
                    child: Image(image: AssetImage("images/logoFullBlack.png")),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 36, right: 36, top: 72, bottom: 36),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    hintText: 'Enter your email',
                                    labelStyle:
                                        TextStyle(fontWeight: FontWeight.w300),
                                    hintStyle:
                                        TextStyle(fontWeight: FontWeight.w300),
                                    errorStyle: TextStyle(fontSize: 20),
                                    prefixIcon: Icon(Icons.email),
                                    prefixIconColor: Colors.black,
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
                                const SizedBox(height: 16.0),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Password',
                                    hintText: 'Enter your password',
                                    labelStyle:
                                        TextStyle(fontWeight: FontWeight.w300),
                                    hintStyle:
                                        TextStyle(fontWeight: FontWeight.w300),
                                    errorStyle: TextStyle(fontSize: 20),
                                    prefixIcon: Icon(Icons.lock),
                                    prefixIconColor: Colors.black,
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
                                const SizedBox(height: 16.0),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Repeat Password',
                                    hintText: 'Enter your password again',
                                    labelStyle:
                                        TextStyle(fontWeight: FontWeight.w300),
                                    hintStyle:
                                        TextStyle(fontWeight: FontWeight.w300),
                                    errorStyle: TextStyle(fontSize: 20),
                                    prefixIcon: Icon(Icons.lock),
                                    prefixIconColor: Colors.black,
                                  ),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your password again';
                                    } else if (_passwordRepeatFieldState ==
                                        FieldValidationState.invalid) {
                                      return 'Passwords don\'t match';
                                    }
                                    return null;
                                  },
                                  onChanged: _validateRepeatPassword,
                                ),
                                SizedBox(
                                  height: 60,
                                ),
                                ElevatedButton(
                                    onPressed: _submitForm,
                                    child: Text(
                                      'REGISTER',
                                    )),
                              ]),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
              ColoredBox(
                color: Colors.black45,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        "V16.05.23",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
