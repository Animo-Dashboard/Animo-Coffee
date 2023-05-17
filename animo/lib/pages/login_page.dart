import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:animo/inAppFunctions.dart';

enum FieldValidationState { empty, valid, invalid }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  FieldValidationState _emailFieldState = FieldValidationState.empty;
  FieldValidationState _passwordFieldState = FieldValidationState.empty;

  String _email = "";
  String _password = "";

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, do login logic here
      print('Login successful!');
      print('Email: $_email');
      print('Password: $_password');
      Navigator.pushReplacementNamed(context, "/registeredDevices");
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
      resizeToAvoidBottomInset: false,
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
                                SizedBox(height: 26),
                                TextButton(
                                    onPressed: () {
                                      // Navigator.pushNamed(
                                      // context, '/registration');
                                    },
                                    child: const Text(
                                      "Forgot password?",
                                      style: TextStyle(fontSize: 24),
                                    )),
                                SizedBox(
                                  height: 60,
                                ),
                                ElevatedButton(
                                    onPressed: _submitForm,
                                    child: Text(
                                      'LOGIN',
                                    )),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/registration');
                                    },
                                    child: const Text(
                                      "Register new account",
                                      style: TextStyle(
                                        fontSize: 24,
                                      ),
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
