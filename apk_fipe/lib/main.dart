import 'package:apk_fipe/view/home_page.dart';
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme(brightness: Brightness.light, primary: const Color.fromARGB(255, 57, 69, 185), onPrimary: Colors.black, secondary: Color.fromARGB(255, 5, 5, 231), onSecondary: Colors.white, error: const Color.fromARGB(255, 127, 25, 25), onError: Colors.white, surface: const Color.fromARGB(255, 219, 219, 219), onSurface: Colors.black),
);

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme(brightness: Brightness.dark, primary: const Color.fromARGB(255, 78, 51, 128), onPrimary: Colors.white, secondary: Color.fromARGB(255, 91, 36, 192), onSecondary: Colors.white, error: const Color.fromARGB(255, 127, 25, 25), onError: Colors.white, surface: const Color.fromARGB(255, 25, 25, 25), onSurface: Colors.white),
);

void main() {
  runApp(MaterialApp(
    theme: lightTheme,
    darkTheme: darkTheme,
    themeMode: ThemeMode.system,
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

