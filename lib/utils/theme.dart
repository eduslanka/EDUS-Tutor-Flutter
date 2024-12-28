// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData basicTheme() {
  TextTheme basicTextTheme(TextTheme base) {
    const String fontFamily = 'Poppins'; // Use your custom Poppins font file
    return base.copyWith(
      headlineSmall: base.headlineSmall?.copyWith(
        fontFamily: fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black, // Black text
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontFamily: fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black, // Black text
      ),
      titleSmall: base.titleMedium?.copyWith(
        fontFamily: fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black, // Black text
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontFamily: fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black, // Black text
      ),
      headlineMedium: base.headlineSmall?.copyWith(
        fontFamily: fontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.w300,
        color: Colors.black, // Black text
      ),
      displaySmall: base.headlineSmall?.copyWith(
        fontFamily: fontFamily,
        fontSize: 22.sp,
        color: Colors.black, // Black text
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontFamily: fontFamily,
        fontSize: 12.sp,
        color: Colors.black, // Black text
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontFamily: fontFamily,
        fontSize: 14.sp,
        color: Colors.black, // Black text
      ),
    );
  }

  final ThemeData base = ThemeData.light();
  return base.copyWith(
    textTheme: basicTextTheme(base.textTheme),
    primaryColor: const Color(0xFF053EFF), // Blue
    scaffoldBackgroundColor: Colors.white, // White background
    iconTheme: IconThemeData(
      color: Colors.white, // White icons
      size: ScreenUtil().setSp(24.0), // Adjusted size
    ),
    tabBarTheme: base.tabBarTheme.copyWith(
      labelColor: Colors.black, // Black for selected tabs
      unselectedLabelColor: Colors.black54, // Semi-black for unselected tabs
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF053EFF), // Blue button background
        foregroundColor: Colors.white, // White text on button
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14, // Base button text size
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF053EFF), // Blue app bar
      titleTextStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18, // App bar title font size
        fontWeight: FontWeight.w600,
        color: Colors.white, // White text
      ),
      iconTheme: const IconThemeData(color: Colors.white), // White icons
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF053EFF), // Blue primary color
      onPrimary: Colors.white, // White text/icons on blue
      secondary: Color(0xFF053EFF), // Secondary blue
      onSecondary: Colors.white, // White text/icons on secondary
      background: Colors.white, // White background
      onBackground: Colors.black, // Black text/icons on white
      surface: Colors.white, // White surface (e.g., cards)
      onSurface: Colors.black, // Black text/icons on surfaces
      error: Colors.red, // Error red
      onError: Colors.white, // White text/icons on error
    ),
  );
}
