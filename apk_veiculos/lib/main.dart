import 'package:apk_veiculos/view/home_page.dart';
import 'package:apk_veiculos/core/theme.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
 options: DefaultFirebaseOptions.currentPlatform
 );

  runApp(MaterialApp(
    darkTheme: AppTheme.darkTheme,
    themeMode: ThemeMode.dark,
    home: const HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

