import 'dart:ui';
import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette - Premium Emerald & Gold
  static const Color primary = Color(0xFF10b981);
  static const Color primaryDark = Color(0xFF059669);
  static const Color secondary = Color(0xFFfbbf24);
  static const Color accent = Color(0xFF8b5cf6);
  static const Color error = Color(0xFFef4444);

  // Dark Theme Backgrounds
  static const Color bgMain = Color(0xFF020617);
  static const Color bgCard = Color(0xB31E293B); // rgba(30, 41, 59, 0.7)
  static const Color glassBorder = Color(0x1AFFFFFF); // rgba(255, 255, 255, 0.1)

  // Text
  static const Color textMain = Color(0xFFf8fafc);
  static const Color textMuted = Color(0xFF94a3b8);
}

// Glassmorphism reusable box
class GlassBox extends StatelessWidget {
  final Widget child;
  final double width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color backgroundColor;

  const GlassBox({
    Key? key,
    required this.child,
    this.width = double.infinity,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.borderRadius = 24.0,
    this.backgroundColor = AppTheme.bgCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppTheme.glassBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x5E000000), // rgba(0, 0, 0, 0.37)
            blurRadius: 32,
            offset: Offset(0, 8),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: Padding(
            padding: padding!,
            child: child,
          ),
        ),
      ),
    );
  }
}
