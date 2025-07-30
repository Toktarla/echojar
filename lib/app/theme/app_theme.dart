import 'package:echojar/common/utils/animations/fade_in_transition.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.background,
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: FadePageTransitionsBuilder(),
      TargetPlatform.iOS: FadePageTransitionsBuilder(),
    },
  ),
  cardColor: AppColors.surface,
  dividerColor: AppColors.border,
  iconTheme: const IconThemeData(color: AppColors.textPrimary),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    displayMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    displaySmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.textPrimary),

    headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.textPrimary),

    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary),

    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.textPrimary),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.textPrimary),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.textSecondary),
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.surface,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.textSecondary,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),

  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.all(AppColors.primary),
    trackColor: WidgetStateProperty.all(AppColors.primaryLight),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.background),
        elevation: 0,
        iconColor: AppColors.textPrimary,
      ),
  ),

  drawerTheme: const DrawerThemeData(
    backgroundColor: AppColors.surface,
  ),

  cardTheme: const CardTheme(
    elevation: 2,
    margin: EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),

  dialogTheme: const DialogTheme(
    backgroundColor: AppColors.surface,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),
    contentTextStyle: TextStyle(
      fontSize: 16,
      color: AppColors.textPrimary,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.surface,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

  datePickerTheme: DatePickerThemeData(
    backgroundColor: AppColors.surface,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),

    // Header
    headerBackgroundColor: AppColors.primary,
    headerForegroundColor: Colors.white,
    headerHeadlineStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headerHelpStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white70,
    ),

    // Year/month picker
    yearStyle: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    yearForegroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.selected)) return Colors.white;
      return AppColors.textSecondary;
    }),
    yearBackgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.selected)) return AppColors.primary;
      return Colors.transparent;
    }),

    // Day picker
    dayStyle: TextStyle(
      fontSize: 14,
      color: AppColors.textPrimary,
    ),
    dayForegroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) return Colors.white;
      if (states.contains(WidgetState.disabled)) return AppColors.textSecondary.withOpacity(0.3);
      return AppColors.textPrimary;
    }),
    dayBackgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) return AppColors.primary;
      return Colors.transparent;
    }),

    // Today indicator
    todayForegroundColor: WidgetStateProperty.all(AppColors.primary),
    todayBackgroundColor: WidgetStateProperty.all(AppColors.primaryLight),

    // Dialog action buttons
    cancelButtonStyle: TextButton.styleFrom(
      foregroundColor: AppColors.textSecondary,
      textStyle: const TextStyle(fontWeight: FontWeight.w500),
    ),
    confirmButtonStyle: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
);
