import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GradientButton(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 13.0.h, horizontal: 40.0.w),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: const [
              Color(0xFF1b5482), // اللون الأول في الوسط
              Color(0xFF0f83a9), // اللون الثاني في الحواف
            ],
            radius: 1.5.r, // حجم التدرج

            tileMode: TileMode.clamp,
            center: Alignment.center, // مركز التدرج
          ),
          borderRadius: BorderRadius.circular(30.0.r), // شكل دائري
        ),
        child: Center(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 24.0.sp,
                ),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
