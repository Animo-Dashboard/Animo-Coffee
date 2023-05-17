import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
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
        primarySwatch: Colors.blue,
        fontFamily: "FuturaStd",
        hintColor: Colors.black,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              fontFamily: "FuturaStd",
            ),
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 16,
              left: 78,
              right: 78,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w700),
          headline2: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
          bodyText1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
          bodyText2: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
      ),
      home: const MyHomePage(title: 'Flutter Home Page'),
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
                    padding: const EdgeInsets.all(24),
                    child: Image.asset("images/logoFullBlack.png"),
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
                    child: const Text(
                      "V16.05.23",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
