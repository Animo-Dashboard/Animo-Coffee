import 'package:animo/inAppFunctions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

import 'login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  final FirebaseAuth? auth;

  const ForgotPasswordPage({Key? key, this.auth}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String pageTitle = "Forgot password";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_email.isNotEmpty) {
        await _auth.sendPasswordResetEmail(email: _email);
        print('Reset password link sent to $_email');
        _showSuccessNotification("Email sent");
      } else {
        _showErrorNotification('Please enter your email');
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  void _showSuccessNotification(String message) {
    final scaffoldMessengerState = _scaffoldKey.currentState;
    if (scaffoldMessengerState != null) {
      scaffoldMessengerState.showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showErrorNotification(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                      padding: EdgeInsets.only(
                          left: 24, right: 24, top: 50, bottom: 80),
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
                                      } else if (!EmailValidator.validate(
                                          value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        _email = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 16.0),
                                  ElevatedButton(
                                    onPressed: _submitForm,
                                    child: const Text('SEND LINK'),
                                  ),
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
