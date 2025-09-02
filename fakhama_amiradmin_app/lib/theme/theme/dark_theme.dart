import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/utils/assets/fonts.dart';
import 'package:flutter/material.dart';

/// ثيم التطبيق المظلم - تصميم ليلي أنيق مع لمسة بنفسجية ساحرة
ThemeData dark = ThemeData(
  fontFamily: AppFontFamilies.arial,

  // الألوان الأساسية - بنفسجي مضيء مع خلفيات داكنة عميقة
  primaryColor: const Color(0xFF8B5CF6), // بنفسجي مضيء
  secondaryHeaderColor: const Color(0xFFA855F7), // بنفسجي زاهي
  disabledColor: const Color(0xFF6B7280),
  brightness: Brightness.dark,
  focusColor: const Color(0xFF1F2937),
  hintColor: const Color(0xFF9CA3AF),

  // ألوان الخلفيات - داكنة عميقة مع لمسة بنفسجية
  cardColor: const Color(0xFF1F2937),
  canvasColor: const Color(0xFF0F172A), // أسود عميق مع لمسة بنفسجية
  splashColor: const Color(0xFF8B5CF6).withOpacity(0.2),
  shadowColor: const Color(0xFF8B5CF6).withOpacity(0.15),

  // إعدادات البطاقات والأدراج
  cardTheme: CardTheme(
    color: const Color(0xFF1F2937),
    elevation: 6,
    shadowColor: const Color(0xFF8B5CF6).withOpacity(0.2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.r),
    ),
  ),

  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xFF0F172A),
    shadowColor: Color(0xFF8B5CF6),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF8B5CF6),
    ),
  ),

  // نظام الألوان الموحد المظلم - متدرج بنفسجي
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF8B5CF6), // بنفسجي مضيء
    secondary: Color(0xFFA855F7), // بنفسجي زاهي
    tertiary: Color(0xFF06B6D4), // سماوي للعناصر المميزة
    surface: Color(0xFF1F2937), // رمادي داكن
    background: Color(0xFF0F172A), // أسود عميق
    error: Color(0xFFF87171), // أحمر مضيء حديث
    onPrimary: Color(0xFF1E1B4B),
    onSecondary: Color(0xFF1E1B4B),
    onSurface: Color(0xFFF9FAFB),
    onBackground: Color(0xFFE5E7EB),
    onError: Colors.white,
  ),

  // قوائم منبثقة ومربعات حوار
  popupMenuTheme: PopupMenuThemeData(
    color: const Color(0xFF1F2937),
    surfaceTintColor: const Color(0xFF0F172A),
    elevation: 16,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.r),
      side: BorderSide(
        color: const Color(0xFF8B5CF6).withOpacity(0.1),
        width: 0.5,
      ),
    ),
  ),

  dialogTheme: DialogTheme(
    backgroundColor: const Color(0xFF1F2937),
    surfaceTintColor: const Color(0xFF0F172A),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24.r),
      side: BorderSide(
        color: const Color(0xFF8B5CF6).withOpacity(0.2),
        width: 1,
      ),
    ),
  ),

  // الأزرار العائمة - تدرج بنفسجي ساحر
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color(0xFF8B5CF6),
    foregroundColor: Colors.white,
    elevation: 12,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24.r),
    ),
  ),

  // شريط التطبيق السفلي
  bottomAppBarTheme: BottomAppBarTheme(
    color: const Color(0xFF1F2937),
    surfaceTintColor: const Color(0xFF0F172A),
    height: 65.h,
    padding: EdgeInsets.symmetric(vertical: 6.h),
    elevation: 16,
  ),

  // خطوط الفصل
  dividerTheme: const DividerThemeData(
    color: Color(0xFF374151),
    thickness: 1,
    space: 1,
  ),

  // شريط التبويب - مع تأثير متدرج
  tabBarTheme: TabBarTheme(
    dividerColor: Colors.transparent,
    labelColor: const Color(0xFF8B5CF6),
    unselectedLabelColor: const Color(0xFF9CA3AF),
    indicator: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          const Color(0xFF8B5CF6).withOpacity(0.3),
          const Color(0xFFA855F7).withOpacity(0.2),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(
        color: const Color(0xFF8B5CF6).withOpacity(0.3),
        width: 1,
      ),
    ),
  ),

  // شريط التطبيق العلوي - مع تدرج خفيف
  appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF0F172A),
      foregroundColor: const Color(0xFF8B5CF6),
      elevation: 4,
      shadowColor: const Color(0xFF8B5CF6).withOpacity(0.2),
      titleTextStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white)),

  // شريط التنقل السفلي
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color(0xFF1F2937),
    selectedItemColor: const Color(0xFF8B5CF6),
    unselectedItemColor: const Color(0xFF6B7280),
    selectedLabelStyle: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 11.sp,
      fontWeight: FontWeight.w400,
    ),
    type: BottomNavigationBarType.fixed,
    elevation: 20,
  ),

  // خلفية التطبيق
  scaffoldBackgroundColor: const Color(0xFF0F172A),

  // حقول الإدخال - تصميم حديث مع لمسات بنفسجية
  inputDecorationTheme: InputDecorationTheme(
    fillColor: const Color(0xFF1F2937),
    filled: true,
    hintStyle: TextStyle(
      color: const Color(0xFF9CA3AF),
      fontSize: 14.sp,
    ),
    labelStyle: TextStyle(
      color: const Color(0xFF8B5CF6),
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: const BorderSide(
        color: Color(0xFF374151),
        width: 1.5,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: const BorderSide(
        color: Color(0xFF8B5CF6),
        width: 2.5,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: const BorderSide(
        color: Color(0xFFF87171),
        width: 1.5,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: const BorderSide(
        color: Color(0xFFF87171),
        width: 2.5,
      ),
    ),
  ),

  // أنماط النصوص - ألوان محسنة للوضع المظلم
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28.sp,
      fontWeight: FontWeight.w800,
      color: const Color(0xFFF9FAFB),
    ),
    headlineMedium: TextStyle(
      fontSize: 22.sp,
      fontWeight: FontWeight.w700,
      color: const Color(0xFFF9FAFB),
    ),
    titleLarge: TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
      color: const Color(0xFFF3F4F6),
    ),
    titleMedium: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: const Color(0xFFE5E7EB),
    ),
    bodyLarge: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: const Color(0xFFF3F4F6),
    ),
    bodyMedium: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: const Color(0xFFD1D5DB),
    ),
    bodySmall: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w300,
      color: const Color(0xFF9CA3AF),
    ),
  ),

  // إضافات للأزرار - تصميم حديث
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF8B5CF6),
      foregroundColor: Colors.white,
      elevation: 6,
      shadowColor: const Color(0xFF8B5CF6).withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF8B5CF6),
      side: const BorderSide(
        color: Color(0xFF8B5CF6),
        width: 1.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
    ),
  ),

  // تحسين التبديل والراديو
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return const Color(0xFF8B5CF6);
      }
      return const Color(0xFF6B7280);
    }),
    trackColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return const Color(0xFF8B5CF6).withOpacity(0.5);
      }
      return const Color(0xFF374151);
    }),
  ),

  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return const Color(0xFF8B5CF6);
      }
      return const Color(0xFF6B7280);
    }),
  ),

  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return const Color(0xFF8B5CF6);
      }
      return Colors.transparent;
    }),
    checkColor: MaterialStateProperty.all(Colors.white),
    side: const BorderSide(color: Color(0xFF6B7280), width: 2),
  ),
);
