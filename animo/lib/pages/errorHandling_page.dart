import 'package:flutter/material.dart';

class ErrorHandlingPage extends StatefulWidget {
  const ErrorHandlingPage({super.key});

  @override
  _ErrorHandlingPageState createState() => _ErrorHandlingPageState();
}

class _ErrorHandlingPageState extends State<ErrorHandlingPage> {
  List<ErrorItem> errorItems = [];

  void handleClick(String value) {
    switch (value) {
      case 'Add new error':
        addNewError();
        break;
      case 'Settings':
        // Handle 'Settings' action
        break;
      case 'Log out':
        // Handle 'Log out' action
        break;
    }
  }

  Text handleColorMoreMenuOptions(String value) {
    switch (value) {
      case 'Add new error':
        return Text(
          value,
          style:
              const TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
        );
      case 'Settings':
        return Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w300),
        );
      case 'Log out':
        return Text(
          value,
          style:
              const TextStyle(fontWeight: FontWeight.w300, color: Colors.red),
        );
      default:
        return Text(value);
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Container(
          padding: const EdgeInsets.all(10),
          child: const Image(
            image: AssetImage('images/logoSymbolWhite.png'),
            height: 1,
            width: 1,
          ),
        ),
        title: const Text(
          "Errors",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            icon: const Icon(
              Icons.more_horiz_sharp,
              size: 48,
            ),
            padding: const EdgeInsets.only(right: 30),
            itemBuilder: (BuildContext context) {
              return ['Add new error', 'Settings', 'Log out']
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: handleColorMoreMenuOptions(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/background2.png'),
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.5),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: ListView.builder(
          itemCount: errorItems.length,
          itemBuilder: (context, index) {
            final errorItem = errorItems[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  title: Text(
                    'Error ID: ${errorItem.id}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Error Name: ${errorItem.name}',
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
