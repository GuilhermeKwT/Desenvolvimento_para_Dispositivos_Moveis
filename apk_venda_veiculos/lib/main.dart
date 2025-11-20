import 'package:apk_veiculos/view/auth_page.dart';
import 'package:apk_veiculos/core/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    darkTheme: AppTheme.darkTheme,
    themeMode: ThemeMode.dark,
    home: const AuthPage(),
    debugShowCheckedModeBanner: false,
  ));
}

