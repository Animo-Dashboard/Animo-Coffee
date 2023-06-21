import 'package:animo/pages/login_page.dart';
import 'package:flutter/material.dart';

class CustomColors {
  static var red = Color(0xFFD54147);
  static var blue = Color(0xFF6BA4B8);
  static var grey = Color(0xFF919388);
}

Text handleColorMoreMenuOptions(String value) {
  switch (value) {
    case 'Add new device':
    case 'Add new error':
      return Text(
        value,
        style: TextStyle(fontWeight: FontWeight.w300, color: CustomColors.blue),
      );
    case "Admin":
    case 'Log out':
      return Text(
        value,
        style: TextStyle(fontWeight: FontWeight.w300, color: CustomColors.red),
      );
    default:
      return Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w300),
      );
  }
}

void logOut(BuildContext context) {
  Navigator.pushReplacementNamed(context, '/login');
}

String getVersion() {
  return "v21.06.23";
}

MaterialColor turnIntoMaterialColor(Color color) {
  final int red = color.red;
  final int green = color.green;
  final int blue = color.blue;

  final Map<int, Color> shades = {
    50: Color.fromRGBO(red, green, blue, .1),
    100: Color.fromRGBO(red, green, blue, .2),
    200: Color.fromRGBO(red, green, blue, .3),
    300: Color.fromRGBO(red, green, blue, .4),
    400: Color.fromRGBO(red, green, blue, .5),
    500: Color.fromRGBO(red, green, blue, .6),
    600: Color.fromRGBO(red, green, blue, .7),
    700: Color.fromRGBO(red, green, blue, .8),
    800: Color.fromRGBO(red, green, blue, .9),
    900: Color.fromRGBO(red, green, blue, 1),
  };

  return MaterialColor(color.value, shades);
}
