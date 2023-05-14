import 'package:flutter/material.dart';
import 'package:animo/inAppFunctions.dart';
import 'package:animo/reuseWidgets.dart';

class ErrorHandlingPage extends StatefulWidget {
  const ErrorHandlingPage({super.key});

  @override
  _ErrorHandlingPageState createState() => _ErrorHandlingPageState();
}

class _ErrorHandlingPageState extends State<ErrorHandlingPage> {
  List<ErrorItem> errorItems = [];
  String pageTitle = "Errors";

  List<String> moreMenuOptions = ['Add new error', 'Settings', 'Log out'];
  void handleClick(String value) {
    switch (value) {
      case 'Add new error':
        addNewError();
        break;
      case 'Settings':
        // Handle 'Settings' action
        break;
      case 'Log out':
        logOut(context);
        break;
    }
  }

  void addNewError() {
    ErrorItem newError = ErrorItem(
      id: 1,
      name: 'Milk Tray Empty',
    );

    setState(() {
      errorItems.add(newError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, moreMenuOptions, pageTitle, handleClick),
      body: Container(
        decoration: getAppBackground(),
        child: ListView.builder(
          itemCount: errorItems.length,
          itemBuilder: (context, index) {
            final errorItem = errorItems[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black12,
                ),
                child: ListTile(
                  title: Text(
                    'Error ID: ${errorItem.id}',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: CustomColors.red,
                        fontSize: 20),
                  ),
                  subtitle: Text(
                    'Error Name: ${errorItem.name}',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: CustomColors.red,
                        fontSize: 14),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ErrorItem {
  final int id;
  final String name;

  ErrorItem({required this.id, required this.name});
}