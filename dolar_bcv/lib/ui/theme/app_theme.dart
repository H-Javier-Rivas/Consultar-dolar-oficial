import 'dart:ui';
import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette - Premium Emerald & Gold
  static const Color primary = Color(0xFF10b981);
  static const Color primaryDark = Color(0xFF059669);
  static const Color secondary = Color(0xFFfbbf24);
  static const Color accent = Color(0xFF8b5cf6);
  static const Color error = Color(0xFFef4444);

  // Dark Theme Colors
  static const Color bgMain = Color(0xFF020617);
  static const Color bgCard = Color(0xB31E293B); // rgba(30, 41, 59, 0.7)
  static const Color glassBorder = Color(0x1AFFFFFF); // rgba(255, 255, 255, 0.1)
  static const Color textMain = Color(0xFFf8fafc);
  static const Color textMuted = Color(0xFF94a3b8);

  // Light Theme Colors
  static const Color bgMainLight = Color(0xFFF1F5F9);
  static const Color bgCardLight = Color(0xB3FFFFFF); // rgba(255, 255, 255, 0.7)
  static const Color glassBorderLight = Color(0x330F172A); // rgba(15, 23, 42, 0.2)
  static const Color textMainLight = Color(0xFF0F172A);
  static const Color textMutedLight = Color(0xFF64748B);

  // Helper to get colors based on context
  static bool isDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;
  
  static Color getBgMain(BuildContext context) => isDark(context) ? bgMain : bgMainLight;
  static Color getBgCard(BuildContext context) => isDark(context) ? bgCard : bgCardLight;
  static Color getGlassBorder(BuildContext context) => isDark(context) ? glassBorder : glassBorderLight;
  static Color getTextMain(BuildContext context) => isDark(context) ? textMain : textMainLight;
  static Color getTextMuted(BuildContext context) => isDark(context) ? textMuted : textMutedLight;
}

// Glassmorphism reusable box
class GlassBox extends StatelessWidget {
  final Widget child;
  final double width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;

  const GlassBox({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.borderRadius = 24.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppTheme.getBgCard(context);
    final borderColor = AppTheme.getGlassBorder(context);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: AppTheme.isDark(context) 
                ? const Color(0x5E000000) 
                : const Color(0x1A000000),
            blurRadius: 32,
            offset: const Offset(0, 8),
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
