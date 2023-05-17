import 'package:animo/pages/errorHandling_page.dart';
import 'package:animo/pages/login_page.dart';
import 'package:animo/pages/registeredDevices_page.dart';
import 'package:animo/pages/registration_page.dart';
import 'package:flutter/material.dart';
import 'inAppFunctions.dart';
import 'package:animo/pages/registerDevice_page.dart';

void main() {
  runApp(const MyApp());
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
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/login': (context) => const LoginPage(),
        '/registration': (context) => const RegistrationPage(),
        '/registeredDevices': (context) => const RegisteredDevicesPage(),
        '/errorHandling': (context) => const ErrorHandlingPage(),
        '/registerDevice': (context) => const RegisterDevicePage(),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline6,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Go to Login Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registration');
              },
              child: const Text('Go to Registration Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registeredDevices');
              },
              child: const Text('Go to Devices Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/errorHandling');
              },
              child: const Text('Error Finding Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registerDevice');
              },
              child: const Text('Register Device Page'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
