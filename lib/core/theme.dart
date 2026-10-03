import 'package:flutter/material.dart';
import 'motion.dart';

/// Design tokens, taken from the GitaSetu UI reference.
class GS {
  static const cream = Color(0xFFF8F3EA);
  static const card = Color(0xFFFFFFFF);
  static const tint = Color(0xFFF3EBDD);
  static const line = Color(0xFFEBE1D0);
  static const ink = Color(0xFF2A2A26);
  static const muted = Color(0xFF6E6A60);
  static const teal = Color(0xFF1E6B66);
  static const tealDeep = Color(0xFF17504D);
  static const navy = Color(0xFF0F2B33);
  static const navy2 = Color(0xFF1A464F);
  static const gold = Color(0xFFC9953E);
  static const terracotta = Color(0xFFC0652F);
  static const terraBg = Color(0xFFF7E3D2);
  static const sage = Color(0xFFDCEBE3);
  static const userBubble = Color(0xFFD9E9E4);

  static const serif = 'Lora';
  static const sans = 'Nunito';
  static const deva = 'NotoSerifDevanagari';

  static TextStyle h(double size, {Color color = ink, FontWeight w = FontWeight.w600, double? height}) =>
      TextStyle(fontFamily: serif, fontFamilyFallback: const [sans], fontSize: size, fontWeight: w, color: color, height: height ?? 1.2);

  static TextStyle b(double size, {Color color = ink, FontWeight w = FontWeight.w400, double? height}) =>
      TextStyle(fontFamily: sans, fontSize: size, fontWeight: w, color: color, height: height ?? 1.4);

  static TextStyle sanskrit(double size, {Color color = ink}) =>
      TextStyle(fontFamily: deva, fontFamilyFallback: const [sans], fontSize: size, color: color, height: 1.55);

  static List<BoxShadow> get softShadow => [
        BoxShadow(color: const Color(0xFF3B2F1E).withValues(alpha: 0.06), blurRadius: 18, offset: const Offset(0, 6)),
      ];
}

class AppTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: GS.teal,
      brightness: Brightness.light,
      primary: GS.teal,
      surface: GS.cream,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: GS.cream,
      fontFamily: GS.sans,
      pageTransitionsTheme: PageTransitionsTheme(builders: {
        for (final p in TargetPlatform.values) p: const CalmPageTransitionsBuilder(),
      }),
      textTheme: ThemeData.light().textTheme.apply(fontFamily: GS.sans, bodyColor: GS.ink, displayColor: GS.ink),
      appBarTheme: const AppBarTheme(
        backgroundColor: GS.cream,
        foregroundColor: GS.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: GS.b(14, color: GS.muted),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(26), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: Colors.transparent,
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith((s) => GS.b(11,
            color: s.contains(WidgetState.selected) ? GS.teal : GS.muted,
            w: s.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w400)),
        iconTheme: WidgetStateProperty.resolveWith(
            (s) => IconThemeData(color: s.contains(WidgetState.selected) ? GS.teal : GS.muted, size: 24)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: GS.navy,
        contentTextStyle: GS.b(14, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
