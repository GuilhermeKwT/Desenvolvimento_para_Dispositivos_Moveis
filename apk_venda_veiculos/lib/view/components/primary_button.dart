import 'package:flutter/material.dart';
import 'package:apk_venda_veiculos/core/theme.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool loading;
  final double height;
  final IconData? icon;
  final bool fullWidth;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.loading = false,
    this.height = 48.0,
    this.icon,
    this.fullWidth = false,
    this.padding,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color bg = backgroundColor ?? AppTheme.primaryPurple;

    final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: Colors.white,
      padding: padding,
    );

    final Widget child = loading
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.2,
            ),
          )
        : Text(label);

    final Widget button = icon != null
        ? ElevatedButton.icon(
            onPressed: loading ? null : onPressed,
            icon: Icon(icon, color: Colors.white),
            label: child,
            style: style,
          )
        : ElevatedButton(
            onPressed: loading ? null : onPressed,
            style: style,
            child: child,
          );

    if (fullWidth) {
      return SizedBox(width: double.infinity, height: height, child: button);
    }

    return SizedBox(height: height, child: button);
  }
}
