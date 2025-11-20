import 'package:flutter/material.dart';
import 'package:apk_veiculos/core/theme.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? bottom;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.appGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: AppTheme.accentGray,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(AppTheme.borderRadiusLarge),
            ),
            side: BorderSide(
              color: AppTheme.borderGray,
              width: 2,
            ),
          ),
          bottom: bottom,
        ),
        body: body,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
