import 'package:flutter/material.dart';

class RegisteredDevicesPage extends StatefulWidget {
  @override
  _RegisteredDevicesPage createState() => _RegisteredDevicesPage();
}

void handleClick(String value) {
  switch (value) {
    case 'Add new device':
      break;
    case 'Settings':
      break;
    case 'Log out':
      break;
  }
}

Text handleColorMoreMenuOptions(String value) {
  switch (value) {
    case 'Add new device':
      return Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
      );
      break;
    case 'Settings':
      return Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w300),
      );
      break;
    case 'Log out':
      return Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w300, color: Colors.red),
      );
      break;
    default:
      return Text(value);
  }
}

class _RegisteredDevicesPage extends State<RegisteredDevicesPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/background2.png'),
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.5), BlendMode.dstATop),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Container(
          padding: EdgeInsets.all(10),
          child: const Image(
            image: AssetImage('images/logoSymbolWhite.png'),
            height: 1,
            width: 1,
          ),
        ),
        title: const Text(
          "Your devices",
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
              return {'Add new device', 'Settings', 'Log out'}
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
    );
  }
}
