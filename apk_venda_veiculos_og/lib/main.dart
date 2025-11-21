import 'package:apk_venda_veiculos/firebase_options.dart';
import 'package:apk_venda_veiculos/view/auth_page.dart';
import 'package:apk_venda_veiculos/core/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(MaterialApp(
    darkTheme: AppTheme.darkTheme,
    themeMode: ThemeMode.dark,
    home: const AuthPage(),
    debugShowCheckedModeBanner: false,
  ));
}

