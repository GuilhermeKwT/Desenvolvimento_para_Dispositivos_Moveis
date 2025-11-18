import 'package:apk_veiculos/view/home_page.dart';
import 'package:apk_veiculos/core/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: AppTheme.darkTheme,
    darkTheme: AppTheme.darkTheme,
    themeMode: ThemeMode.dark,
    home: const HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

