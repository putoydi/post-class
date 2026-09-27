import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      
      // Global Text Styling Theme map from your Type Scale
      textTheme: TextTheme(
        headlineSmall: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.normal,
          color: AppColors.textAndOutlines,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.textAndOutlines,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.placeholderText,
        ),
      ),
      
      // Bottom navigation visual standards mapping
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.noteGreen,
        selectedItemColor: AppColors.selectedIcon,
        unselectedItemColor: AppColors.placeholderText,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
