import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/utils/assets/fonts.dart';

/// ثيم التطبيق الفاتح - تصميم يعكس الأيقونة البنفسجية الأنيقة
ThemeData light = ThemeData(
  fontFamily: AppFontFamilies.arial,
  // الألوان الأساسية - تدرج بنفسجي أزرق مستوحى من الأيقونة
  primaryColor: const Color(0xFF6366F1), // بنفسجي أساسي
  secondaryHeaderColor: const Color(0xFF8B5CF6), // بنفسجي فاتح
  disabledColor: const Color(0xFFBDBDBD),
  brightness: Brightness.light,
  focusColor: Colors.white,
  hintColor: const Color(0xFF9CA3AF),

  // ألوان الخلفيات - نظيفة مع لمسة بنفسجية خفيفة
  cardColor: Colors.white,
  canvasColor: const Color(0xFFFBFBFF), // أبيض مع لمسة بنفسجية خفيفة جداً
  splashColor: const Color(0xFFF3F4F6), // رمادي فاتح للتأثيرات
  shadowColor: const Color(0xFF6366F1).withOpacity(0.08),

  // إعدادات البطاقات والأدراج
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 3,
    shadowColor: const Color(0xFF6366F1).withOpacity(0.1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.r),
    ),
  ),

  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.white,
    shadowColor: Color(0xFF6366F1),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF6366F1),
    ),
  ),

  // نظام الألوان الموحد - مستوحى من الأيقونة البنفسجية
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF6366F1), // بنفسجي أساسي
    secondary: Color(0xFF8B5CF6), // بنفسجي فاتح
    tertiary: Color(0xFFA855F7), // بنفسجي زاهي للعناصر المميزة
    surface: Colors.white, // أبيض نقي
    background: Color(0xFFFBFBFF), // أبيض مع لمسة بنفسجية
    error: Color(0xFFEF4444), // أحمر حديث للتحذيرات
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color(0xFF1F2937),
    onBackground: Color(0xFF374151),
    onError: Colors.white,
  ),

  // قوائم منبثقة ومربعات حوار
  popupMenuTheme: PopupMenuThemeData(
    color: Colors.white,
    surfaceTintColor: Colors.white,
    elevation: 12,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.r),
    ),
  ),

  dialogTheme: DialogTheme(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24.r),
    ),
  ),

  // الأزرار العائمة - لون بنفسجي متدرج
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color(0xFF8B5CF6),
    foregroundColor: Colors.white,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24.r),
    ),
  ),

  // شريط التطبيق السفلي
  bottomAppBarTheme: BottomAppBarTheme(
    color: Colors.white,
    surfaceTintColor: Colors.white,
    height: 65.h,
    padding: EdgeInsets.symmetric(vertical: 6.h),
    elevation: 10,
  ),

  // خطوط الفصل
  dividerTheme: const DividerThemeData(
    color: Color(0xFFE5E7EB),
    thickness: 1,
    space: 1,
  ),

  // شريط التبويب
  tabBarTheme: TabBarTheme(
    dividerColor: Colors.transparent,
    labelColor: const Color(0xFF6366F1),
    unselectedLabelColor: const Color(0xFF9CA3AF),
    indicator: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          const Color(0xFF6366F1).withOpacity(0.15),
          const Color(0xFF8B5CF6).withOpacity(0.15),
        ],
      ),
      borderRadius: BorderRadius.circular(12.r),
    ),
  ),

  // شريط التطبيق العلوي
  appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF6366F1),
      elevation: 2,
      shadowColor: const Color(0xFF6366F1).withOpacity(0.1),
      titleTextStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      iconTheme: const IconThemeData(color: Colors.black)),

  // شريط التنقل السفلي
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: const Color(0xFF6366F1),
    unselectedItemColor: const Color(0xFF9CA3AF),
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
  scaffoldBackgroundColor: const Color(0xFFFBFBFF),

  // حقول الإدخال
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.white,
    filled: true,
    hintStyle: TextStyle(
      color: const Color(0xFF9CA3AF),
      fontSize: 14.sp,
    ),
    labelStyle: TextStyle(
      color: const Color(0xFF6366F1),
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: const BorderSide(
        color: Color(0xFFE5E7EB),
        width: 1.5,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: const BorderSide(
        color: Color(0xFF6366F1),
        width: 2.5,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: const BorderSide(
        color: Color(0xFFEF4444),
        width: 1.5,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: const BorderSide(
        color: Color(0xFFEF4444),
        width: 2.5,
      ),
    ),
  ),

  // أنماط النصوص - ألوان محدثة لتتناسب مع التصميم البنفسجي
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28.sp,
      fontWeight: FontWeight.w800,
      color: const Color(0xFF1F2937),
    ),
    headlineMedium: TextStyle(
      fontSize: 22.sp,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF1F2937),
    ),
    titleLarge: TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF1F2937),
    ),
    titleMedium: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF374151),
    ),
    bodyLarge: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: const Color(0xFF1F2937),
    ),
    bodyMedium: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: const Color(0xFF374151),
    ),
    bodySmall: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w300,
      color: const Color(0xFF6B7280),
    ),
  ),

  // إضافات لتعزيز التصميم
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF6366F1),
      foregroundColor: Colors.white,
      elevation: 3,
      shadowColor: const Color(0xFF6366F1).withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF6366F1),
      side: const BorderSide(color: Color(0xFF6366F1)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
    ),
  ),
);
