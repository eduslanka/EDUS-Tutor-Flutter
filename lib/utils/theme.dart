// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData basicTheme() {
  TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith(
      headlineSmall: GoogleFonts.poppins(
        textStyle: base.headlineSmall?.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF415094),
        ),
      ),
      titleMedium: GoogleFonts.poppins(
        textStyle: base.titleMedium?.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF415094),
        ),
      ),
      titleSmall: GoogleFonts.poppins(
        textStyle: base.titleMedium?.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      titleLarge: GoogleFonts.poppins(
        textStyle: base.titleLarge?.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF415094),
        ),
      ),
      headlineMedium: GoogleFonts.poppins(
        textStyle: base.headlineSmall?.copyWith(
          fontSize: 12.sp,
          fontWeight: FontWeight.w300,
          color: const Color(0xFF727FC8),
        ),
      ),
      displaySmall: GoogleFonts.poppins(
        textStyle: base.headlineSmall?.copyWith(
          fontSize: 22.sp,
          color: Colors.grey,
        ),
      ),
      bodySmall: GoogleFonts.poppins(
        textStyle: base.bodySmall?.copyWith(
          color: const Color(0xFFCCC5AF),
        ),
      ),
      bodyMedium: GoogleFonts.poppins(
        textStyle: base.bodyMedium?.copyWith(
          color: const Color(0xFF807A6B),
        ),
      ),
    );
  }

  final ThemeData base = ThemeData.light();
  return base.copyWith(
      textTheme: _basicTextTheme(base.textTheme),
      //textTheme: Typography().white,
      primaryColor: Colors.indigo,
      //primaryColor: Color(0xff4829b2),
      indicatorColor: const Color(0xFF807A6B),
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      iconTheme: IconThemeData(
        color: Colors.white,
        size: ScreenUtil().setSp(30.0),
      ),
      tabBarTheme: base.tabBarTheme.copyWith(
        labelColor: const Color(0xffce107c),
        unselectedLabelColor: Colors.grey,
      ),
      colorScheme: const ColorScheme(
        background: Colors.white,
        brightness: Brightness.light,
        primary: Colors.red,
        onPrimary: Colors.green,
        secondary: Colors.grey,
        onSecondary: Colors.black12,
        error: Colors.red,
        onError: Colors.redAccent,
        onBackground: Colors.white,
        surface: Colors.grey,
        onSurface: Colors.blueGrey,
      ));
}
