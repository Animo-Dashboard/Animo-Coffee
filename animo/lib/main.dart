import 'dart:async';
import 'package:animo/pages/MaintenanceSelection_page.dart';
import 'package:animo/pages/addNewDevice_page.dart';
import 'package:animo/pages/admin_page.dart';
import 'package:animo/pages/admin_roleChange_page.dart';
import 'package:animo/pages/calciumLevels_page.dart';
import 'package:animo/pages/dashboard_page.dart';
import 'package:animo/pages/deviceStatistics_page.dart';
import 'package:animo/pages/errorHandling_page.dart';
import 'package:animo/pages/forgotPasword_page.dart';
import 'package:animo/pages/login_page.dart';
import 'package:animo/pages/machineError_page.dart';
import 'package:animo/pages/machineSpecs_page.dart';
import 'package:animo/pages/registerDevice_page.dart';
import 'package:animo/pages/registeredDevices_page.dart';
import 'package:animo/pages/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'inAppFunctions.dart';
import 'firebase_options.dart';

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
      title: 'Animo Application',
      theme: ThemeData(
        primarySwatch: turnIntoMaterialColor(CustomColors.blue),
        fontFamily: "FuturaStd",
        hintColor: Colors.black,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            alignment: AlignmentDirectional.center,
            textStyle: MaterialStateProperty.all(
                TextStyle(fontSize: 28, fontWeight: FontWeight.w300)),
            padding: MaterialStateProperty.all(const EdgeInsets.only(
                top: 16, bottom: 16, left: 20, right: 20)),
            maximumSize: MaterialStateProperty.all(const Size.fromWidth(300)),
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
        ),
        textTheme: const TextTheme(
            titleLarge: TextStyle(fontSize: 36.0),
            titleMedium: TextStyle(fontSize: 28.0),
            bodyLarge: TextStyle(fontSize: 24.0),
            bodyMedium: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300)),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/login': (context) => LoginPage(),
        '/registration': (context) => const RegistrationPage(),
        '/forgotPassword': (context) => const ForgotPasswordPage(),
        '/registerDevice': (context) => const RegisterDevicePage(),
        '/registeredDevices': (context) => const RegisteredDevicesPage(),
        '/errorHandling': (context) => const ErrorHandlingPage(),
        '/addNewDevice': (context) => const AddNewDevicePage(),
        '/admin': (context) => const AdminPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/deviceStatistics': (context) => const DeviceStatisticsPage(),
        '/machineSpecs': (context) => MachineSpecsPage(),
        '/maintenance': (context) => MaintenanceSelectionPage(),
        '/api': (context) => ZipCodeSearchPage(),
        '/roleChange': (context) => AssignRolePage(),
        '/machineErrors': (context) => MachineErrorPage()
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
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  Future<void> _navigateToNextPage() async {
    await Future.delayed(const Duration(seconds: 3));
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, '/login');
  }

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
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(
                      "images/logoFullBlack.png",
                      height: 400,
                      width: 300,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Column(
                    children: const [
                      Text(
                        "Please wait...",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12),
                      CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
