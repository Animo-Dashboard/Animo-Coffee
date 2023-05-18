import 'package:animo/pages/addNewDevice_page.dart';
import 'package:animo/pages/errorHandling_page.dart';
import 'package:animo/pages/login_page.dart';
import 'package:animo/pages/registeredDevices_page.dart';
import 'package:animo/pages/registration_page.dart';
import 'package:flutter/material.dart';
import 'inAppFunctions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Front-End Demo',
      theme: ThemeData(
        primarySwatch: turnIntoMaterialColor(CustomColors.blue),
        fontFamily: "FuturaStd",
        hintColor: Colors.black,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all(
                TextStyle(fontSize: 28, fontWeight: FontWeight.w300)),
            padding: MaterialStateProperty.all(const EdgeInsets.only(
                top: 10, bottom: 10, left: 50, right: 50)),
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
        ),
        textTheme: const TextTheme(
            titleLarge: TextStyle(fontSize: 36.0),
            titleMedium: TextStyle(fontSize: 24.0),
            bodyLarge: TextStyle(fontSize: 20.0),
            bodyMedium: TextStyle(fontSize: 16.0)),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/login': (context) => LoginPage(),
        '/registration': (context) => const RegistrationPage(),
        '/registeredDevices': (context) => const RegisteredDevicesPage(),
        '/errorHandling': (context) => const ErrorHandlingPage(),
        '/addNewDevice': (context) => const AddNewDevicePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Go to Login Page'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registration');
              },
              child: const Text('Go to Registration Page'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registeredDevices');
              },
              child: const Text('Go to Devices Page'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/errorHandling');
              },
              child: const Text('Error Finding Page'),
            ),
          ],
        ),
      ),
    );
  }
}
