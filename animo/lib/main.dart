import 'dart:async';
import 'package:animo/pages/addNewDevice_page.dart';
import 'package:animo/pages/errorHandling_page.dart';
import 'package:animo/pages/login_page.dart';
import 'package:animo/pages/registeredDevices_page.dart';
import 'package:animo/pages/registration_page.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'inAppFunctions.dart';
import 'package:animo/pages/registerDevice_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

final globalNavigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Front-End Demo',
      navigatorKey: globalNavigatorKey,
      theme: ThemeData(
        primarySwatch: turnIntoMaterialColor(CustomColors.blue),
        fontFamily: "FuturaStd",
        hintColor: Colors.black,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all(const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                fontFamily: "FuturaStd")),
            padding: MaterialStateProperty.all(const EdgeInsets.only(
                top: 16, bottom: 16, left: 78, right: 78)),
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
        ),
        textTheme: const TextTheme(
            titleLarge: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w700),
            titleMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
            bodyLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            bodyMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/login': (context) => LoginPage(),
        '/registration': (context) => const RegistrationPage(),
        '/registeredDevices': (context) => const RegisteredDevicesPage(),
        '/errorHandling': (context) => const ErrorHandlingPage(),
        '/registerDevice': (context) => const RegisterDevicePage(),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 24, right: 24),
                    child: Image(image: AssetImage("images/logoFullBlack.png")),
                  ),
                  FutureBuilder(
                      future: Future.delayed(
                          const Duration(seconds: 3),
                          () => {
                                const AsyncSnapshot.withData(
                                    ConnectionState.done, "Done")
                              }),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasData) {
                          Future.microtask(() => Navigator.pushReplacementNamed(
                              context, '/login'));
                        }
                        return Column(
                          children: const [
                            Text(
                              "Please wait...",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 12),
                            CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.black,
                            ),
                          ],
                        );
                      })
                ],
              ),
            ),
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
          ])),
    );
  }
}
