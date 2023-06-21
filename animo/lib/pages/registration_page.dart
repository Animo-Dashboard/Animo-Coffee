import 'package:animo/inAppFunctions.dart';
import 'package:animo/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

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
      try {
        // Create a new user with the entered email and password
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // Save the user's email and password to Firestore with "verified" field set to false
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userCredential.user!.uid)
            .set({
          'email': _email,
          'password': _password,
          'verified':
              false, // Set "verified" field to false during registration
        });

        // Send verification email to the admin
        await sendVerificationEmail(_email);

        print('Registration successful! Verification email sent to admin.');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } catch (e) {
        print('Registration failed: $e');
      }
    }
  }

  Future<void> sendVerificationEmail(String userEmail) async {
    final smtpServer = gmail('your-email@gmail.com',
        'your-password'); // Replace with your own email server details

    final message = Message()
      ..from =
          Address('your-email@gmail.com') // Replace with your own email address
      ..recipients.add(
          'admin-email@example.com') // Replace with the admin's email address
      ..subject = 'New user registration: Verification required'
      ..text =
          'A new user with email $userEmail has registered and requires verification.';

    try {
      final sendReport = await send(message, smtpServer);
      print('Verification email sent: ${sendReport.toString()}');
    } catch (e) {
      print('Error sending verification email: $e');
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
      _passwordRepeatFieldState = value == _password
          ? FieldValidationState.valid
          : FieldValidationState.invalid;
      _passwordRepeat = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black, size: 48),
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
                  child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 24, right: 24, top: 50),
                      child:
                          Image(image: AssetImage("images/logoFullBlack.png")),
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(
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
                                      labelStyle: TextStyle(
                                          fontWeight: FontWeight.w300),
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w300),
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
                                      labelStyle: TextStyle(
                                          fontWeight: FontWeight.w300),
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w300),
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
                                      labelStyle: TextStyle(
                                          fontWeight: FontWeight.w300),
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w300),
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
                                  const SizedBox(
                                    height: 27,
                                  ),
                                  ElevatedButton(
                                      onPressed: _submitForm,
                                      child: const Text(
                                        'REGISTER',
                                      )),
                                ]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              ColoredBox(
                color: Colors.black45,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        getVersion(),
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
